//
//  CoreFavouritesDishManager.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 20.04.2023.
//

import CoreData


final class CoreFavouritesDishManager {
    
    var allDishes: [Dish] = []
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        refresh()
    }
    
    func refresh() -> [Dish] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CoreFavourites.self))
        
        do {
            guard let results = try context.fetch(request) as? [CoreFavourites],
                  let dishes = results.first?.dish?.array as? [CoreDish] else {
                allDishes = []
                return allDishes
            }
            
            allDishes = dishes.map {
                Dish(title: $0.name ?? "",
                     kcal: $0.energyKcal,
                     prot: $0.proteinG,
                     fat: $0.fatG,
                     carb: $0.carbsG )
            }
        } catch {
            allDishes = []
        }
        return allDishes
    }
}
