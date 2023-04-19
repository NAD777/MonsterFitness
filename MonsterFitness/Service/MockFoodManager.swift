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

    let weightConsumed: Double
    let dishConsumed: Dish
    let dayPart: DayPart
}

protocol FoodStorage {
    var date: Date { get }

    var allPortions: [Portion] { get }
    
    func addConsumedDish(_ model: Portion)
    
    func deleteDish(index: Int) throws

    func getTotalCalorieIntake() -> Double
}

final class MockFoodManager: FoodStorage {
    enum Errors: Error {
        case doesNotExist
    }

    private var storage: [Portion] = [
        Portion(weightConsumed: 0.3, dishConsumed: Dish(title: "Пиво", kcal: 30, prot: 30, fat: 30, carb: 30), dayPart: .breakfast),
        Portion(weightConsumed: 0.3, dishConsumed: Dish(title: "Пиво", kcal: 30, prot: 30, fat: 30, carb: 30), dayPart: .lunch),
        Portion(weightConsumed: 0.3, dishConsumed: Dish(title: "Пиво", kcal: 30, prot: 30, fat: 30, carb: 30), dayPart: .dinner),
        Portion(weightConsumed: 0.3, dishConsumed: Dish(title: "Пиво", kcal: 30, prot: 30, fat: 30, carb: 30), dayPart: .unspecified),
        Portion(weightConsumed: 0.3, dishConsumed: Dish(title: "Пиво", kcal: 30, prot: 30, fat: 30, carb: 30), dayPart: .unspecified),
        Portion(weightConsumed: 0.3, dishConsumed: Dish(title: "Пиво", kcal: 30, prot: 30, fat: 30, carb: 30), dayPart: .breakfast),
        Portion(weightConsumed: 0.3, dishConsumed: Dish(title: "Пиво", kcal: 30, prot: 30, fat: 30, carb: 30), dayPart: .breakfast)

    ]
    
    let date = Date()

    var allPortions: [Portion] { storage }
    
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
}
