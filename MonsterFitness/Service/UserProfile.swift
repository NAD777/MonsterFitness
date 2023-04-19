//
//  File.swift
//  MonsterFitness
//
//  Created by Dmitry on 18.04.2023.
//

import Foundation

final class UserProfile {
    private let defaults = UserDefaults.standard
    var currentUser: User? {
        didSet {
            update()
        }
    }
    init() {
        let name = defaults.string(forKey: "name") ?? "Unknown"
        let age = defaults.integer(forKey: "age")
        let weight = defaults.integer(forKey: "weight")
        let height = defaults.integer(forKey: "height")
        let target = defaults.integer(forKey: "target")
        let targetSteps = defaults.integer(forKey: "targetSteps")
        let gender = Genders(rawValue: defaults.integer(forKey: "gender"))
        let type = PhysicalActivityLevel(rawValue: defaults.integer(forKey: "type"))
        currentUser = User(name: name, age: age, weight: weight, height: height, gender: gender, target: target, targetSteps: targetSteps, activityLevel: type)
    }
    
    func update() {
        defaults.set(currentUser?.name, forKey: "name")
        defaults.set(currentUser?.age, forKey: "age")
        defaults.set(currentUser?.weight, forKey: "weight")
        defaults.set(currentUser?.height, forKey: "height")
        defaults.set(currentUser?.target, forKey: "target")
        defaults.set(currentUser?.targetSteps, forKey: "targetSteps")
        defaults.set(currentUser?.gender?.rawValue, forKey: "gender")
        defaults.set(currentUser?.activityLevel?.rawValue, forKey: "type")
    }
}
