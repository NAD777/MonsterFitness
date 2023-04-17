//
//  Dish.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 15.04.2023.
//

import Foundation

struct Dish {
    let title: String
    let kcal: Double
    let prot: Double
    let fat: Double
    let carb: Double

    init(title: String, kcal: Double, prot: Double, fat: Double, carb: Double) {
        self.title = title
        self.kcal = kcal
        self.prot = prot
        self.fat = fat
        self.carb = carb
    }
}
