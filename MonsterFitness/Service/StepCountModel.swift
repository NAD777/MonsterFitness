//
//  StepCountModel.swift
//  MonsterFitness
//
//  Created by Denis on 13.04.2023.
//

import Foundation
import HealthKit

protocol StepAccess {
    func getStepCountsForPreviousYear(completion: @escaping ([Date: Int]) -> Void ) throws
    
    func getStepCountForToday() async -> Int
}

final class StepCountModel: StepAccess {
    enum Errors: Error {
        case unknownError
    }

    private let healthStore = HKHealthStore()
    
    public func getStepCountForTodayForAsync(completion: @escaping (Result<Int, Error>) -> Void) throws {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw Errors.unknownError
        }
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, result, _ in

            guard let result = result, let sum = result.sumQuantity() else {
                completion(.success(0))
                return
            }
            completion(.success(Int(sum.doubleValue(for: HKUnit.count()))))
        }
        healthStore.execute(query)
    }
    
    // обертка для обратной совместимости асинка с замыканиями
    func getStepCountForToday() async -> Int {
        return try! await withCheckedThrowingContinuation { continuation in
            try? getStepCountForTodayForAsync { result in
                switch result {
                case .success(let steps):
                    continuation.resume(returning: steps)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    

    // получаем данные о шагах за прошлый год
    public func getStepCountsForPreviousYear(completion: @escaping ([Date: Int]) -> Void ) throws {
        let healthStore = HKHealthStore()
        guard let stepCountQuantity = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw Errors.unknownError
        }
        let calendar = Calendar.current

        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -365, to: endDate)!

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: stepCountQuantity, quantitySamplePredicate: predicate,
                    options: .cumulativeSum, anchorDate: startDate, intervalComponents: DateComponents(day: 1))

        var stepCounts: [Date: Int] = [:]
        query.initialResultsHandler = { _, results, error in
            guard let results = results else {
                print("Failed to retrieve step counts: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Iterate through each day's step count data and add it to the dictionary
            results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                let date = statistics.startDate
                let stepCount = Int(statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0)
                stepCounts[date] = stepCount
            }
            completion(stepCounts)
        }
        healthStore.execute(query)
    }

}
