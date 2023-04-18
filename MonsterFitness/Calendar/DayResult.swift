//
//  DayResult.swift
//  MonsterFitness
//
//  Created by Yandex on 18.04.2023.
//

import Foundation


struct dayResult: Identifiable {
    var day: Date
    var consumed: Double = 0.0
    var burnt: Double = 0.0
    var animated: Bool = false
    var id = UUID()
}
