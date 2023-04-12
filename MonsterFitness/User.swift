//
//  User.swift
//  MonsterFitness
//
//  Created by Dmitry on 12.04.2023.
//

import Foundation


class User{
    
    let name: String
    var age: Int?
    var weight: Int?
    var height: Int?
    var gender: Int?
    
    init(name: String, age: Int? = nil, weight: Int? = nil, height: Int? = nil, gender: Int? = nil) {
        self.name = name
        self.age = age
        self.weight = weight
        self.height = height
        self.gender = gender
    }
    
}
