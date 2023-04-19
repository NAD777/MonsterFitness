//
//  MockFoodManager.swift
//  MonsterFitness
//
//  Created by Denis on 15.04.2023.
//

import Foundation

struct Portion {
    enum DayPart: String {
        case breakfast = "Завтрак"
        case lunch = "Обед"
        case dinner = "Ужин"
        case unspecified = "Не указан"
    }

//    struct DishMock {
//        let title: String
//        let calories: Double
//        let carbs: Double
//        let fat: Double
//    }

    let weightConsumed: Double
    let dishConsumed: Dish
    let dayPart: DayPart
}

protocol FoodStorage {
    var storage: [Portion] { get set }
    
    func addConsumedDish(_ model: Portion)
    
    func deleteDish(index: Int) throws
    
    func getAllDishes() -> [Portion]
    
    func getTotalCalorieIntake() -> Double
}

final class MockFoodManager: FoodStorage {
    
    enum Errors: Error {
        case doesNotExist
    }
    
    
    public var storage: [Portion] = [
        Portion(weightConsumed: 0.3, dishConsumed: Dish(title: "Пиво", kcal: 30, prot: 30, fat: 30, carb: 30), dayPart: .breakfast),
        Portion(weightConsumed: 0.3, dishConsumed: Dish(title: "Пиво", kcal: 30, prot: 30, fat: 30, carb: 30), dayPart: .lunch),
        Portion(weightConsumed: 0.3, dishConsumed: Dish(title: "Пиво", kcal: 30, prot: 30, fat: 30, carb: 30), dayPart: .dinner),
        Portion(weightConsumed: 0.3, dishConsumed: Dish(title: "Пиво", kcal: 30, prot: 30, fat: 30, carb: 30), dayPart: .unspecified),
        Portion(weightConsumed: 0.3, dishConsumed: Dish(title: "Пиво", kcal: 30, prot: 30, fat: 30, carb: 30), dayPart: .unspecified),
        Portion(weightConsumed: 0.3, dishConsumed: Dish(title: "Пиво", kcal: 30, prot: 30, fat: 30, carb: 30), dayPart: .breakfast),
        Portion(weightConsumed: 0.3, dishConsumed: Dish(title: "Пиво", kcal: 30, prot: 30, fat: 30, carb: 30), dayPart: .breakfast),

    ]
    
    init(storage: [Portion]) {
        if storage.isEmpty != true {
            self.storage = storage
        }
    }
    
    func getTotalCalorieIntake() -> Double {
        var calorieTotal: Double = 0.0
        for meal in storage {
            calorieTotal += meal.weightConsumed*meal.dishConsumed.kcal * 10
        }
        return calorieTotal
    }
    
    
    public func addConsumedDish(_ model: Portion) {
        self.storage.append(model)
    }
    
    public func deleteDish(index: Int) throws {
        if index >= 0 && index < self.storage.count {
            self.storage.remove(at: index)
        } else {
            throw Errors.doesNotExist
        }
    }
    
    public func getAllDishes() -> [Portion] {
        return self.storage
    }
    
}
