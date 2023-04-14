//
//  CalendarPage.swift
//  MonsterFitness
//
//  Created by Yandex on 14.04.2023.
//

import UIKit

final class CalendarController: UIViewController {
    
    var calendar = UIDatePicker()
    var dateText = UILabel()
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCalendar()
        setupLabel()
    }
    
    func setupCalendar() {
        
        dateFormatter.dateFormat = "MMM d, y"
        calendar.preferredDatePickerStyle = .inline
        calendar.locale = .current
        calendar.date = Date.now
        calendar.datePickerMode = .date
        view.addSubview(calendar)

        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: -100).isActive = true
        calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        calendar.addAction(UIAction(handler: { _ in
            self.dateText.text = self.dateFormatter.string(from: self.calendar.date)
        }), for: .valueChanged)
    }
    
    func setupLabel() {
        
        dateText.text = dateFormatter.string(from: calendar.date)
        view.addSubview(dateText)
        dateText.translatesAutoresizingMaskIntoConstraints = false
        dateText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
    }
}
