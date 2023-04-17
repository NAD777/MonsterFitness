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

    struct Dish {
        let title: String
        let calories: Double
        let carbs: Double
        let fat: Double
    }

    let weightConsumed: Double
    let dishConsumed: Dish
    let dayPart: DayPart
}

class MockFoodManager {
    public var storage: [Portion] = [
        Portion(weightConsumed: 0.500, dishConsumed: Portion.Dish(title: "Пиво", calories: 30, carbs: 9, fat: 0), dayPart: .dinner),
        Portion(weightConsumed: 0.400, dishConsumed: Portion.Dish(title: "Шницель", calories: 30, carbs: 9, fat: 0), dayPart: .lunch),
        Portion(weightConsumed: 0.500, dishConsumed: Portion.Dish(title: "Суп", calories: 30, carbs: 9, fat: 0), dayPart: .unspecified),
        Portion(weightConsumed: 0.500, dishConsumed: Portion.Dish(title: "Рамен", calories: 30, carbs: 9, fat: 0), dayPart: .breakfast),
        Portion(weightConsumed: 0.500, dishConsumed: Portion.Dish(title: "Пиво", calories: 30, carbs: 9, fat: 0), dayPart: .dinner)
    ]
    
    init(storage: [Portion]) {
    }
    
}
