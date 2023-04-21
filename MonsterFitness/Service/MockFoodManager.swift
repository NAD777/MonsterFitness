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
}

protocol FoodStorage {
    var date: Date { get }

    var allPortions: [Portion] { get }
        
    func deletePortion(index: Int)

    func getTotalCalorieIntake() -> Double
    
    func updateStorage()
}
