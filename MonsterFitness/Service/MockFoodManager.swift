//
//  MockFoodManager.swift
//  MonsterFitness
//
//  Created by Denis on 15.04.2023.
//

import Foundation

enum DayPart: String {
    case breakfast = "Завтрак"
    case lunch = "Обед"
    case dinner = "Ужин"
    case unspecified = "Не указан"
}

struct Dish {
    let title: String
    let calories: Double
    let carbs: Double
    let fat: Double
}

struct Portion {
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

class MockFoodManager: FoodStorage {
    
    enum Errors: Error {
        case doesNotExist
    }
    
    public var storage: [Portion] = [
        Portion(weightConsumed: 0.500, dishConsumed: Dish(title: "Пиво", calories: 30, carbs: 9, fat: 0), dayPart: .dinner),
        Portion(weightConsumed: 0.300, dishConsumed: Dish(title: "Шницель", calories: 240, carbs: 9, fat: 0), dayPart: .lunch),
        Portion(weightConsumed: 0.500, dishConsumed: Dish(title: "Суп", calories: 50, carbs: 9, fat: 0), dayPart: .unspecified),
        Portion(weightConsumed: 0.400, dishConsumed: Dish(title: "Рамен", calories: 60, carbs: 9, fat: 0), dayPart: .breakfast),
        Portion(weightConsumed: 0.090, dishConsumed: Dish(title: "Бекон", calories: 900, carbs: 9, fat: 0), dayPart: .dinner)
    ]
    
    init(storage: [Portion]) {
        if storage.isEmpty != true {
            self.storage = storage
        }
        
    }
    
    func getTotalCalorieIntake() -> Double {
        var calorieTotal: Double = 0.0
        for meal in storage {
            calorieTotal += meal.weightConsumed*meal.dishConsumed.calories * 10
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
