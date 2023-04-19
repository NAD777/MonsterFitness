//
//  CoreStorage.swift
//  MonsterFitness
//
//  Created by Vitaliy V. Korzyuk on 19.04.2023.
//

import CoreData

final class CoreStorage {
    func savePortion(_ portion: UIPortion, date: Date) {
        let coreDish = CoreDish(context: persistentContainer.viewContext)
        coreDish.energyKcal = portion.dish?.kcal ?? 0
        coreDish.name = portion.dish?.title ?? ""

        let corePortion = CorePortion(context: persistentContainer.viewContext)
        corePortion.weight = Double(portion.weight)
        corePortion.dish = coreDish

        let coreMenu = fetchMenu(date: date) ?? makeMenu(date: date)
        coreMenu.insertIntoBreakfast(corePortion, at: coreMenu.breakfast?.count ?? 0)

        saveContext()
    }

    func fetchMenu(date: Date) -> CoreMenu? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CoreMenu.self))
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)
        do {
            if let results = try persistentContainer.viewContext.fetch(request) as? [CoreMenu] {
                return results.first
            }
        } catch {}
        return nil
    }

    func makeMenu(date: Date) -> CoreMenu {
        let coreMenu = CoreMenu(context: persistentContainer.viewContext)
        coreMenu.date = date
        return coreMenu
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MonsterFitness")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
