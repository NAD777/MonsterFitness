//
//  StepCountModel.swift
//  MonsterFitness
//
//  Created by Denis on 13.04.2023.
//

import Foundation
import HealthKit

final class StepCountModel: Error {
    enum Errors: Error {
        case unknownError
    }

    private let healthStore = HKHealthStore()

    public func readStepCount(completion: @escaping (Double) -> Void) throws {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw Errors.unknownError
        }
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, result, _ in

            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        healthStore.execute(query)

    }
}
