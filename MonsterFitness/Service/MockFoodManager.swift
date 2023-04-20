//
//  MockFoodManager.swift
//  MonsterFitness
//
//  Created by Denis on 15.04.2023.
//

import Foundation
import CoreData

struct Portion {
    enum DayPart: String {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case unspecified = "Other"
    }

    let weightConsumed: Double
    let dishConsumed: Dish
    let dayPart: DayPart
    var dayPartInt: Int {
        switch dayPart {
        case .breakfast:
            return 0
        case .lunch:
            return 1
        case .dinner:
            return 2
        case .unspecified:
            return 3
        }
    }
}

protocol FoodStorage {
    var date: Date { get }

    var allPortions: [Portion] { get }
    
    func addConsumedDish(_ model: Portion)
    
    func deleteDish(index: Int) throws

    func getTotalCalorieIntake() -> Double
    
    func updateStorage()
}
