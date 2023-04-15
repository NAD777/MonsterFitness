//
//  CalendarController.swift
//  MonsterFitness
//
//  Created by Yandex on 15.04.2023.
//

import UIKit
import SwiftUI
import Charts

struct DifferenceOfCalories: Identifiable {
    var day: String
    var cnt: Int
    var id = UUID()
}

// MARK: это удалить
let sample: [DifferenceOfCalories] = [
    .init(day: "пн", cnt: 120),
    .init(day: "вт", cnt: 450),
    .init(day: "ср", cnt: -60),
    .init(day: "чт", cnt: 0),
    .init(day: "пт", cnt: 303),
    .init(day: "сб", cnt: -400),
    .init(day: "вс", cnt: 100)
    ]

// MARK: для красивой анимации beginsample должен быть с теми же знаками (+/-) что и реальные данные
let beginsample: [DifferenceOfCalories] = [
    .init(day: "пн", cnt: 1),
    .init(day: "вт", cnt: 1),
    .init(day: "ср", cnt: -1),
    .init(day: "чт", cnt: 0),
    .init(day: "пт", cnt: 1),
    .init(day: "сб", cnt: -1),
    .init(day: "вс", cnt: 1)
    ]

struct BarChart: View {
    @State private var end = 0.0
    @State var data = beginsample
    var body: some View {
        Chart {
            ForEach(data) { oneday in
                if oneday.cnt > 0 {
                    BarMark(x: .value("x", oneday.day), y: .value("y", oneday.cnt))
                        .foregroundStyle(by: .value("color", "Green"))
                        .cornerRadius(8)
                } else {
                    BarMark(x: .value("x", oneday.day), y: .value("y", oneday.cnt))
                        .foregroundStyle(by: .value("color", "Red"))
                        .cornerRadius(8)
                }
            }
        }
        .chartForegroundStyleScale(["Green": .green, "Red": .red])
        .chartLegend(.hidden)
        .chartYScale(domain: -500...500) // MARK: границы нужно считать
        .onAppear {
            withAnimation(.easeIn(duration: 1)) {
                for index in 0...6 {
                    data[index].cnt = sample[index].cnt
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisValueLabel().foregroundStyle(Color.white)
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic) { _ in
                AxisGridLine(centered: true, stroke: StrokeStyle(dash: [0])).foregroundStyle(Color.secondary)
                AxisValueLabel().foregroundStyle(Color.white)
            }
        }
    }
}



final class CalendarController: UIViewController {
    
    private var calendar = UIDatePicker()
    private var dateText = UILabel()
    // MARK: поменять потом на кнопку Details, возвращающую на главный экран
    private var button = UIButton(type: .system)
    private static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM d, y"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 13 / 255, alpha: 1)
        setupCalendar()
        setupLabel()
        setupBarView()
        setupButton()
    }
    
    private func setupCalendar() {
        // MARK: поменять цвет текста календаря
        calendar.preferredDatePickerStyle = .inline
        calendar.locale = .current
        calendar.date = Date.now
        calendar.datePickerMode = .date
        calendar.tintColor = .systemGreen
        view.addSubview(calendar)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: -100).isActive = true
        calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        calendar.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.dateText.text = CalendarController.dateFormatter.string(from: self.calendar.date)
            self.setupBarView()
        }), for: .valueChanged)
        
    }
    
    private func setupLabel() {
        
        dateText.text = CalendarController.dateFormatter.string(from: calendar.date)
        view.addSubview(dateText)
        dateText.textColor = .white
        dateText.translatesAutoresizingMaskIntoConstraints = false
        dateText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
    }

    private func setupBarView() {
        
        guard let graphic = UIHostingController(rootView: BarChart()).view else { return }
        view.addSubview(graphic)
        graphic.translatesAutoresizingMaskIntoConstraints = false
        graphic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        graphic.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        graphic.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        graphic.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        graphic.backgroundColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 13 / 255, alpha: 1)
    }
    
    private func setupButton() {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
        button.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc
    func buttonTapped(_ sender: UIButton) {
        self.setupBarView()
    }
}
