//
//  DayResultManager.swift
//  MonsterFitness
//
//  Created by Yandex on 20.04.2023.
//

import Foundation
import CoreData

final class DayResultManager {
    let date: Date
    var week: [DayResult]
    var context: NSManagedObjectContext
    
    init(day: Date, context: NSManagedObjectContext) {
        self.date = day
        self.context = context
        var dates: [Date] = []
        let weekday: Int = Calendar.current.component(.weekday, from: day)
        let firstDate: Date = Date(timeInterval: Double((-weekday+1)*86400), since: day)
        for numDay in 0...6 {
            dates += [Date(timeInterval: Double(numDay * 86400), since: firstDate)]
        }
        self.week = dates.map {
            DayResult(day: $0)
        }
        
        for (index, date) in dates.enumerated() {
            let request: NSFetchRequest<CoreDayResult> = CoreDayResult.fetchRequest()
            request.predicate = NSPredicate(format: "date == %@", date as NSDate)
            do {
                guard let results = try? context.fetch(request),
                      let result = results.first else {
                    continue
                }
                self.week[index].consumed = result.consumed
                self.week[index].burnt = result.burnt
            }
        }
    }
}
