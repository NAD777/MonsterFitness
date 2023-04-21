//
//  CoreFoodManager.swift
//  MonsterFitness
//
//  Created by Vitaliy V. Korzyuk on 19.04.2023.
//

import CoreData

final class CoreFoodManager: FoodStorage {
    let date: Date

    var allPortions: [Portion] = []

    init(date: Date, context: NSManagedObjectContext) {
        self.date = date
        updateStorage()
    }
     
    public func updateStorage() {
        let context = CoreStorage().persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CoreMenu.self))
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)

        do {
            guard let results = try context.fetch(request) as? [CoreMenu] else {
                return
            }
            allPortions = []
            if let portions = results.first?.breakfast?.array as? [CorePortion] {
                allPortions += portions.map {
                    Portion(
                        weightConsumed: $0.weight,
                        dishConsumed: Dish(
                            title: $0.dish?.name ?? "",
                            kcal: $0.dish?.energyKcal ?? 0,
                            prot: $0.dish?.proteinG ?? 0,
                            fat: $0.dish?.fatG ?? 0,
                            carb: $0.dish?.carbsG ?? 0
                        ),
                        dayPart: .breakfast)
                }
            }
            if let portions = results.first?.lunch?.array as? [CorePortion] {
                allPortions += portions.map {
                    Portion(
                        weightConsumed: $0.weight,
                        dishConsumed: Dish(
                            title: $0.dish?.name ?? "",
                            kcal: $0.dish?.energyKcal ?? 0,
                            prot: $0.dish?.proteinG ?? 0,
                            fat: $0.dish?.fatG ?? 0,
                            carb: $0.dish?.carbsG ?? 0
                        ),
                        dayPart: .lunch)
                }
            }
            if let portions = results.first?.dinner?.array as? [CorePortion] {
                allPortions += portions.map {
                    Portion(
                        weightConsumed: $0.weight,
                        dishConsumed: Dish(
                            title: $0.dish?.name ?? "",
                            kcal: $0.dish?.energyKcal ?? 0,
                            prot: $0.dish?.proteinG ?? 0,
                            fat: $0.dish?.fatG ?? 0,
                            carb: $0.dish?.carbsG ?? 0
                        ),
                        dayPart: .dinner)
                }
            }
            if let portions = results.first?.other?.array as? [CorePortion] {
                allPortions += portions.map {
                    Portion(
                        weightConsumed: $0.weight,
                        dishConsumed: Dish(
                            title: $0.dish?.name ?? "",
                            kcal: $0.dish?.energyKcal ?? 0,
                            prot: $0.dish?.proteinG ?? 0,
                            fat: $0.dish?.fatG ?? 0,
                            carb: $0.dish?.carbsG ?? 0
                        ),
                        dayPart: .unspecified)
                }
            }
        } catch {}
    }

    func getTotalCalorieIntake() -> Double {
        var calorieTotal: Double = 0.0
        for portion in allPortions {
            calorieTotal += portion.weightConsumed * portion.dishConsumed.kcal
        }
        return calorieTotal
    }

    public func addConsumedDish(_ model: Portion) {
        assertionFailure("not implemented")
    }

    public func deleteDish(index: Int) throws {
        assertionFailure("not implemented")
    }
    
//    public func deleteDishFromFavourite(index: Int) throws {
//        assertionFailure("delete from favaurite does not implemented")
//    }
}

extension Int64 {
    func convert() -> Portion.DayPart {
        switch Int(self) {
        case UIPortion.MealTime.breakfast.rawValue: return .breakfast
        case UIPortion.MealTime.lunch.rawValue: return .lunch
        case UIPortion.MealTime.dinner.rawValue: return .dinner
        default: return .unspecified
        }
    }
}
