//
//  CoreFoodManager.swift
//  MonsterFitness
//
//  Created by Vitaliy V. Korzyuk on 19.04.2023.
//

import CoreData

final class CoreFoodManager: FoodStorage {
    var storage: [Portion]

    init(context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CoreMenu.self))
        do {
            guard let results = try context.fetch(request) as? [CoreMenu],
                let portions = results.first?.breakfast?.array as? [CorePortion] else {
                storage = []
                return
            }

            storage = portions.map {
                Portion(
                    weightConsumed: $0.weight,
                    dishConsumed: Dish(
                        title: $0.dish?.name ?? "",
                        kcal: $0.dish?.energyKcal ?? 0,
                        prot: 30,
                        fat: 30,
                        carb: 30
                    ),
                    dayPart: .breakfast)
            }
        } catch {
            storage = []
        }
    }

    func getTotalCalorieIntake() -> Double {
        var calorieTotal: Double = 0.0
        for meal in storage {
            calorieTotal += meal.weightConsumed * meal.dishConsumed.kcal * 10
        }
        return calorieTotal
    }

    public func addConsumedDish(_ model: Portion) {
        assertionFailure("not implemented")
    }

    public func deleteDish(index: Int) throws {
        assertionFailure("not implemented")
    }
}
