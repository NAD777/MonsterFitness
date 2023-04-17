//
//  UserProfile.swift
//  MonsterFitness
//
//  Created by Dmitry on 17.04.2023.
//

import Foundation

final class UserProfile {
    let defaults = UserDefaults.standard
    var currentUser: User? {
        didSet {
            defaults.set(currentUser?.name, forKey: "name")
            defaults.set(currentUser?.age, forKey: "age")
            defaults.set(currentUser?.weight, forKey: "weight")
            defaults.set(currentUser?.height, forKey: "height")
            defaults.set(currentUser?.target, forKey: "target")
            defaults.set(currentUser?.gender, forKey: "gender")
        }
    }
    init() {
        let name = defaults.string(forKey: "name") ?? "Unknow"
        let age = defaults.integer(forKey: "age")
        let weight = defaults.integer(forKey: "weight")
        let height = defaults.integer(forKey: "height")
        let target = defaults.integer(forKey: "target")
        let genders = ["male": Genders.male, "female": Genders.female, "other": Genders.other]
        let currentGender = genders[defaults.string(forKey: "gender") ?? "other"]
        currentUser = User(name: name, age: age, weight: weight, height: height, gender: currentGender, target: target)
    }
}
