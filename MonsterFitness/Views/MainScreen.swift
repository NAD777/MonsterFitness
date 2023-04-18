//
//  MainScreen.swift
//  MonsterFitness
//
//  Created by Denis on 14.04.2023.
//

import UIKit

final class MainScreen: UIViewController {
    private let todayDateLabel: UILabel = UILabel(frame: .zero)
    private let caloriesConsumedView = CalorieIndicatorView(frame: .zero)
    private let caloriesBurnedView = CalorieIndicatorView(frame: .zero)

    private let fatMeter = FatMeterView(frame: .zero)
    private let summary = CalorieSummaryView(frame: .zero)
    
    private var tableView = UITableView(frame: .zero)
    
    private let mockStorage = MockFoodManager(storage: [])
    private let consumptionEstimator = ConsumptionEstimation(pedometerImpl: StepCountModel())
    private let userMock = User(name: "mockname", age: 23, weight: 64, height: 140, gender: .male, activityLevel: .moderatelyActive)

    var onSearchFoodSelected: (() -> Void)?
    var onPersonSelected: (() -> Void)?

    // Тестовые кнопки перехода на какие-нибудь вьюшки
    lazy private var toFoodButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: 100, width: 60, height: 60))
        button.setTitle("Search", for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(toFood), for: .touchUpInside)
        return button
    }()
    
    lazy private var toPersonButton: UIButton = {
        let button = UIButton(frame: CGRect(x: view.bounds.width - 60 - 20, y: 100, width: 60, height: 60))
        button.setTitle("Person", for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(toPerson), for: .touchUpInside)
        return button
    }()
    
    lazy private var toGraphButton: UIButton = {
        let button = UIButton(frame: CGRect(x: view.bounds.width - 60 - 20, y: 180, width: 60, height: 60))
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(self.toGraph), for: .touchUpInside)
        return button
    }()

    private func setDataForSubviews() {
        try? consumptionEstimator.getCalorieExpandatureForToday(user: userMock) { [weak self] calories in
            DispatchQueue.main.async {
                let consumed = self?.mockStorage.getTotalCalorieIntake() ?? 0
                self?.fatMeter.setData(caloriesDiff: consumed - calories)
                self?.summary.setData(burned: calories, consumed: consumed)
                self?.caloriesBurnedView.getNewCalorieValue(calories: calories)
                self?.caloriesConsumedView.getNewCalorieValue(calories: consumed)
                
            }
        }
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .blue
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EatenProductsCell.self, forCellReuseIdentifier: EatenProductsCell.identifier)
    }
    
    private func setupConstraints() {
        todayDateLabel.translatesAutoresizingMaskIntoConstraints = false
        caloriesConsumedView.translatesAutoresizingMaskIntoConstraints = false
        caloriesBurnedView.translatesAutoresizingMaskIntoConstraints = false
        fatMeter.translatesAutoresizingMaskIntoConstraints = false
        summary.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: todayDateLabel.centerXAnchor),
            view.topAnchor.constraint(equalTo: todayDateLabel.topAnchor, constant: -80),
            todayDateLabel.widthAnchor.constraint(equalToConstant: 150),
            todayDateLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: fatMeter.centerXAnchor),
            
            // констрейнты по горизонтали для блока потрачено-жирометр-съедено
            view.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: caloriesBurnedView.leftAnchor, constant: 0),
            caloriesBurnedView.rightAnchor.constraint(equalTo: fatMeter.leftAnchor, constant: 10),
            fatMeter.rightAnchor.constraint(equalTo: caloriesConsumedView.leftAnchor, constant: 10),
            caloriesConsumedView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 10),
            
            // привязываем жирометр к верхушке
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: fatMeter.topAnchor, constant: -80),
            
            // привязываем элементы по вертикали
            caloriesConsumedView.centerYAnchor.constraint(equalTo: fatMeter.centerYAnchor),
            caloriesBurnedView.centerYAnchor.constraint(equalTo: fatMeter.centerYAnchor),
            
            fatMeter.widthAnchor.constraint(equalToConstant: 100),
            fatMeter.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            summary.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            summary.heightAnchor.constraint(equalToConstant: 60),
            
            view.centerXAnchor.constraint(equalTo: summary.centerXAnchor),
            fatMeter.bottomAnchor.constraint(equalTo: summary.topAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: tableView.leftAnchor, constant: -20),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: summary.bottomAnchor, constant: 40),
            tableView.heightAnchor.constraint(equalToConstant: 400)

        ])
        
    }
    
    private func setupDateLabel() {
        let date = Date()
        let calendar = Calendar.current
        let todayDate = "\(calendar.component(.day, from: date)).\(calendar.component(.month, from: date)).\(calendar.component(.year, from: date))"
        todayDateLabel.text = todayDate
        todayDateLabel.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 30)
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(caloriesConsumedView)
        view.addSubview(todayDateLabel)
        view.addSubview(fatMeter)
        view.addSubview(summary)
        view.addSubview(caloriesBurnedView)
        view.addSubview(tableView)
        view.addSubview(toFoodButton)
        view.addSubview(toPersonButton)
        view.addSubview(toGraphButton)
        setupDateLabel()
        setupTableView()
        setupConstraints()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setDataForSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func toFood() {
        onSearchFoodSelected?()
    }
    
    @objc func toPerson() {
        onPersonSelected?()
    }
    
    @objc func toGraph() {
    
    }
    
}

extension MainScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "завтрак+обед+все"
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}

extension MainScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mockStorage.storage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EatenProductsCell.identifier) as? EatenProductsCell else {
            return UITableViewCell()
        }
        cell.setData(portion: mockStorage.storage[indexPath.row])
        
        return cell
    }
    
}

