//
//  ConsumptionEstimation.swift
//  MonsterFitness
//
//  Created by Denis on 17.04.2023.
//

import Foundation

protocol CalorieEstimator {
    func calculateBasalConsumption(user: User) -> Double
    func getCalorieExpandatureForToday(user: User, closure: @escaping (Double) -> Void) throws
    func calculatePhysicalCalorieExpandature(user: User, closure: @escaping (Double) -> Void)
}

final class ConsumptionEstimation: CalorieEstimator {
    enum Errors: Error {
        case ageNotSpecified
        case genderNotSpecified
        case weightNotSpecified
        case heightNotSpecified
        case activityLevelNotSpecified
    }
    
    let pedometerImpl: StepAccess
    
    private func applyActivityModifier(user: User) -> Double {
        switch user.activityLevel {
        case .passive:
            return 1.1
        case .minimallyActive:
            return 1.15
        case .moderatelyActive:
            return 1.3
        case .active:
            return 1.5
        case .extremelyActive:
            return 1.8
        default:
            return 1.3
        }
    }
    
    internal func calculateBasalConsumption(user: User) -> Double {
        guard let age = user.age else {
            return 0
            //            throw Errors.ageNotSpecified
        }
        guard let gender = user.gender else {
            return 0
            //            throw Errors.genderNotSpecified
        }
        guard let weight = user.weight else {
            return 0
            //            throw Errors.weightNotSpecified
        }
        guard let height = user.height else {
            return 0
            //            throw Errors.heightNotSpecified
        }
        guard let activityLevel = user.activityLevel else {
            return 0
            //            throw Errors.activityLevelNotSpecified
        }
        let activityModifier = applyActivityModifier(user: user)
        
        switch gender {
        case .male:
            let maleCalories: Double = 66.5 + 13.75 * Double(weight) + 5 * Double(height) - 6.75 * Double(age) * activityModifier
            return maleCalories
        case .female:
            let femaleCalories: Double = 66.5 + 13.75 * Double(weight) + 5 * Double(height) - 6.75 * Double(age) * activityModifier
            return femaleCalories
        case .other:
            let otherCalories: Double = 66.5 + 11.75 * Double(weight) + 3 * Double(height) - 5.5 * Double(age) * activityModifier
            return otherCalories
        }
    }
    
    public func getCalorieExpandatureForGivenSteps(user: User, steps: Int) throws -> Double {
        guard let age = user.age else {
            throw Errors.ageNotSpecified
        }
        guard let gender = user.gender else {
            throw Errors.genderNotSpecified
        }
        guard let weight = user.weight else {
            throw Errors.weightNotSpecified
        }
        guard let height = user.height else {
            throw Errors.heightNotSpecified
        }
        guard let activityLevel = user.activityLevel else {
            throw Errors.activityLevelNotSpecified
        }
        
        let newUser = User(name: user.name, age: age, weight: weight, height: height, gender: gender,
                           activityLevel: activityLevel)
        
        let basalExpandature = calculateBasalConsumption(user: newUser)
        let physicalActivityExpandature = calculatePhysicalCalorieExpandatureForGivenSteps(user: newUser, steps: steps)
        return physicalActivityExpandature+basalExpandature
    }
    
    public func getCalorieExpandatureForToday(user: User, closure: @escaping (Double)->Void) throws {
        guard let age = user.age else {
            throw Errors.ageNotSpecified
        }
        guard let gender = user.gender else {
            throw Errors.genderNotSpecified
        }
        guard let weight = user.weight else {
            throw Errors.weightNotSpecified
        }
        guard let height = user.height else {
            throw Errors.heightNotSpecified
        }
        guard let activityLevel = user.activityLevel else {
            throw Errors.activityLevelNotSpecified
        }
        
        let newUser = User(name: user.name, age: age, weight: weight, height: height, gender: gender,
                           activityLevel: activityLevel)
        
        let basalExpandature = calculateBasalConsumption(user: newUser)
        let physicalActivityExpandature = calculatePhysicalCalorieExpandature(user: newUser) { arg in
            closure(arg+basalExpandature)
        }
    }
    
    
    internal func calculatePhysicalCalorieExpandatureForGivenSteps(user: User, steps: Int) -> Double {
        // FIXME: формула сомнительная, я в математике не силен
        let steps = steps
        let caloriesSpentForAMile = 0.57 * Double(user.weight ?? 100000) * 0.453592
        let stepLengthInMeters = Double(user.height ?? 0)/400 + 0.37
        let caloriesSpent = Double(steps) * stepLengthInMeters / caloriesSpentForAMile
        return caloriesSpent
    }
    
    
    internal func calculatePhysicalCalorieExpandature(user: User, closure: @escaping (Double)->Void) {
        // FIXME: формула сомнительная, я в математике не силен
        Task {
            let steps = await self.pedometerImpl.getStepCountForToday()
            let caloriesSpentForAMile = 0.57 * Double(user.weight ?? 100000) * 0.453592
            let stepLengthInMeters = Double(user.height ?? 0)/400 + 0.37
            let caloriesSpent = Double(steps) * stepLengthInMeters / caloriesSpentForAMile
            closure(caloriesSpent)
        }
    }
    
    init(pedometerImpl: StepAccess) {
        self.pedometerImpl = pedometerImpl
    }
}

