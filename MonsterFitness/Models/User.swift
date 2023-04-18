//
//  User.swift
//  MonsterFitness
//
//  Created by Dmitry on 12.04.2023.
//

import Foundation

enum Genders{
    case male
    case female
    case other
}

enum PhysicalActivityLevel {
    case passive
    case minimallyActive
    case moderatelyActive
    case active
    case extremelyActive
}


struct User {
    let name: String
    var age: Int?
    var weight: Int?
    var height: Int?
    var gender: Genders?
    var target: Int = 2500
    var activityLevel: PhysicalActivityLevel?
    
}
