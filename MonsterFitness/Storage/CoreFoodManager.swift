//
//  CoreFoodManager.swift
//  MonsterFitness
//
//  Created by Vitaliy V. Korzyuk on 19.04.2023.
//

import CoreData

final class CoreFoodManager: FoodStorage {
    let date: Date

    let allPortions: [Portion]

    init(date: Date, context: NSManagedObjectContext) {
        self.date = date

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CoreMenu.self))
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)

        do {
            guard let results = try context.fetch(request) as? [CoreMenu],
                let portions = results.first?.breakfast?.array as? [CorePortion] else {
                allPortions = []
                return
            }

            allPortions = portions.map {
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
            allPortions = []
        }
    }

    func getTotalCalorieIntake() -> Double {
        var calorieTotal: Double = 0.0
        for portion in allPortions {
            calorieTotal += portion.weightConsumed * portion.dishConsumed.kcal * 10
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
