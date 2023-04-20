//
//  CalendarController.swift
//  MonsterFitness
//
//  Created by Yandex on 15.04.2023.
//

import UIKit
import SwiftUI
import Charts

struct BarChart: View {
    @State var data: [DayResult]
    var dateFormatter = DateFormatter()
    init(_ sample: [DayResult]) {
        data = sample
        dateFormatter.dateFormat = "d.MM"
    }
    var body: some View {
        AnimatedChart()
    }
    
    @ViewBuilder
    func AnimatedChart() -> some View {
        let max = max( data.max { lhs, rhs in
            return lhs.diff < rhs.diff
        }?.diff ?? 0.0, 0.0)
        
        let min = min( data.min { lhs, rhs in
            return lhs.diff < rhs.diff
        }?.diff ?? 0.0, 0.0)
        Chart {
            ForEach(data) { oneday in
                if (oneday.consumed - oneday.burnt) > 0 {
                    BarMark(x: .value("Date", dateFormatter.string(from: oneday.day)), y: .value("y", oneday.animated ? oneday.diff : 1.0))
                        .foregroundStyle(by: .value("color", "Green"))
                        .cornerRadius(8)
                } else {
                    BarMark(x: .value("Date", dateFormatter.string(from: oneday.day)), y: .value("y", oneday.animated ? oneday.diff : -1.0))
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
    private var storage: DayResultManager
    private var calendar = UIDatePicker()
    private var dateText = UILabel()
    private var button = UIButton(type: .system)
    var date: Date {
        calendar.date
    }
    var onButtonDetails: (() -> Void)?
    private var graphicRollerNext = UIButton(type: .system)
    private var graphicRollerPrev = UIButton(type: .system)
    private static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM d, y"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    
    init(storage: DayResultManager) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundBlack")
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
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.preferredDatePickerStyle = .inline
        calendar.date = storage.date
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
        guard let graphic = UIHostingController(rootView: BarChart(storage.week)).view else { return }
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
        let context = storage.context
        storage = DayResultManager(day: calendar.date, context: context)
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
        onButtonDetails?()
    }
}
