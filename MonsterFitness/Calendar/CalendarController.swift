//
//  CalendarController.swift
//  MonsterFitness
//
//  Created by Yandex on 15.04.2023.
//

import UIKit
import SwiftUI
import Charts

// MARK: это удалить
let sample: [dayResult] = [
    .init(day: Date("2023-04-02"), consumed: 100.0),
    .init(day: Date("2023-04-03"), consumed: -120.0),
    .init(day: Date("2023-04-04"), consumed: 120.0),
    .init(day: Date("2023-04-05"), consumed: 100.0),
    .init(day: Date("2023-04-06"), consumed: -120.0),
    .init(day: Date("2023-04-07"), consumed: 450.0),
    .init(day: Date("2023-04-08"), consumed: 120.0),
    ]
let sample1: [dayResult] = [
    .init(day: Date("2023-04-09"), consumed: -120.0),
    .init(day: Date("2023-04-10"), consumed: -100.0),
    .init(day: Date("2023-04-11"), consumed: 120.0),
    .init(day: Date("2023-04-12"), consumed: -120.0),
    .init(day: Date("2023-04-13"), consumed: -100.0),
    .init(day: Date("2023-04-14"), consumed: 120.0),
    .init(day: Date("2023-04-15"), consumed: -400.0),
    ]

struct BarChart: View {
    @State var data: [dayResult]
    var dateFormatter = DateFormatter()
    init(_ sample: [dayResult]) {
        data = sample
        dateFormatter.dateFormat = "MMM d"
    }
    var body: some View {
        AnimatedChart()
    }
    
    @ViewBuilder
    func AnimatedChart() -> some View {
        let maxData = data.max { lhs, rhs in
            return lhs.consumed - lhs.burnt < rhs.consumed - rhs.burnt
        }
        let max = (maxData?.consumed ?? 0.0) - (maxData?.burnt ?? 0.0) < 0.0 ? 0.0 : (maxData?.consumed ?? 0.0) - (maxData?.burnt ?? 0.0)
        
        let minData = data.max { lhs, rhs in
            return lhs.consumed - lhs.burnt > rhs.consumed - rhs.burnt
        }
        let min = (minData?.consumed ?? 0.0) - (minData?.burnt ?? 0.0) > 0.0 ? 0.0 : (minData?.consumed ?? 0.0) - (minData?.burnt ?? 0.0)
        Chart {
            ForEach(data) { oneday in
                if (oneday.consumed - oneday.burnt) > 0 {
                    BarMark(x: .value("Date", dateFormatter.string(from: oneday.day)), y: .value("y", oneday.animated ? oneday.consumed - oneday.burnt : 1.0))
                        .foregroundStyle(by: .value("color", "Green"))
                        .cornerRadius(8)
                } else {
                    BarMark(x: .value("Date", dateFormatter.string(from: oneday.day)), y: .value("y", oneday.animated ? oneday.consumed - oneday.burnt : -1.0))
                        .foregroundStyle(by: .value("color", "Red"))
                        .cornerRadius(8)
                }
            }
        }
        .chartForegroundStyleScale(["Green": .green, "Red": .red])
        .chartLegend(.hidden)
        .chartYScale(domain: (min-50)...(max+50))
        .onAppear {
            for index in 0...6 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                    withAnimation(.easeIn(duration: 0.5)) {
                        data[index].animated = true
                    }
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
    private var button = UIButton(type: .system)
    private var graphicRollerNext = UIButton(type: .system)
    private var graphicRollerPrev = UIButton(type: .system)
    private static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM d, y"
        return df
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 13 / 255, alpha: 1)
        setupView()
    }
    private func setupView() {
        let infoStack = UIStackView(arrangedSubviews: [dateText, button])
        view.addSubview(infoStack)
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        infoStack.axis = .horizontal
        infoStack.spacing = 10
        infoStack.heightAnchor.constraint(equalToConstant: 30).isActive = true
        setupButton()
        setupLabel()
        
        let mainStack = UIStackView(arrangedSubviews: [calendar, infoStack])
        view.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: -100).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
        setupCalendar()
        setupBarView()
        setupStepper()
    }
    private func setupCalendar() {
        view.overrideUserInterfaceStyle = .dark
        calendar.preferredDatePickerStyle = .inline
        calendar.date = Date.now
        calendar.datePickerMode = .date
        calendar.tintColor = .systemGreen
        calendar.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.dateChanged()
        }), for: .valueChanged)
    }
    private func setupLabel() {
        dateText.text = CalendarController.dateFormatter.string(from: calendar.date)
        dateText.textColor = .white
        dateText.font = .systemFont(ofSize: 20.0, weight: .medium)
    }
    private func setupButton() {
        button.setTitle("Details", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24.0, weight: .medium)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    private func setupBarView() {
        // MARK: sample заменить на реальные данные
        guard let graphic = UIHostingController(rootView: BarChart(sample)).view else { return }
        view.addSubview(graphic)
        graphic.translatesAutoresizingMaskIntoConstraints = false
        graphic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        graphic.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        graphic.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        graphic.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        graphic.backgroundColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 13 / 255, alpha: 1)
    }
    private func setupStepper() {
        let stepper = UIStackView(arrangedSubviews: [graphicRollerPrev, graphicRollerNext])
        view.addSubview(stepper)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.axis = .horizontal
        stepper.spacing = 40
        stepper.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        stepper.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stepper.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stepper.widthAnchor.constraint(equalToConstant: 70).isActive = true
        stepper.distribution = .fillEqually
        
        graphicRollerPrev.setTitle("<", for: .normal)
        graphicRollerNext.setTitle(">", for: .normal)
        graphicRollerPrev.setTitleColor(.systemGreen, for: .normal)
        graphicRollerPrev.titleLabel?.font = .systemFont(ofSize: 44.0, weight: .regular, width: UIFont.Width.init(-0.45))
        graphicRollerNext.setTitleColor(.systemGreen, for: .normal)
        graphicRollerNext.titleLabel?.font = .systemFont(ofSize: 44.0, weight: .regular, width: UIFont.Width.init(-0.45))
        graphicRollerPrev.addTarget(self, action: #selector(calendarPrev), for: .touchUpInside)
        graphicRollerNext.addTarget(self, action: #selector(calendarNext), for: .touchUpInside)
    }
    private func dateChanged() {
        dateText.text = CalendarController.dateFormatter.string(from: calendar.date)
        setupBarView()
    }
    @objc
    func calendarPrev(_ sender: UIButton) {
        calendar.date = Date(timeInterval: -604800, since: calendar.date)
        dateChanged()
    }
    @objc
    func calendarNext(_ sender: UIButton) {
        calendar.date = Date(timeInterval: 604800, since: calendar.date)
        dateChanged()
    }
    @objc
    func buttonTapped(_ sender: UIButton) {
        //self.setupBarView()
    }
}

// MARK: для сэмплов
extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
}
