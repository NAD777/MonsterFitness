//
//  Dish.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 15.04.2023.
//

import Foundation

class Dish {
    var title: String
    var kcal: Double
    var prot: Double
    var fat: Double
    var carb: Double

    init(title: String, kcal: Double, prot: Double, fat: Double, carb: Double) {
        self.title = title
        self.kcal = kcal
        self.prot = prot
        self.fat = fat
        self.carb = carb
    }

    convenience init(title: String, kcal: Double) {
        self.init(title: title, kcal: kcal, prot: 0, fat: 0, carb: 0)
    }
}
