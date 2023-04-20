//
//  DayResult.swift
//  MonsterFitness
//
//  Created by Yandex on 18.04.2023.
//

import Foundation

struct DayResult: Identifiable {
    var day: Date
    var consumed: Double = 0.0
    var burnt: Double = 0.0
    var diff: Double {
        consumed - burnt
    }
    var animated: Bool = false
    var id = UUID()
}
