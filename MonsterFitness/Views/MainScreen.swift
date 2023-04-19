//
//  MainScreen.swift
//  MonsterFitness
//
//  Created by Denis on 14.04.2023.
//

import UIKit

final class MainScreen: UIViewController {
    private let todayDateLabel: UILabel = UILabel(frame: .zero)
    // тут костыль, размер задается через фрейм и констрейнты одновременно
    private let circleIndicator = WheelIndicator(frame: CGRect(x: 0, y: 0, width: 260, height: 260))
    private let summary = CalorieSummaryView(frame: .zero)
    
    private var tableView = UITableView(frame: .zero)
    
    private let mockStorage: FoodStorage
    private let consumptionEstimator = ConsumptionEstimation(pedometerImpl: StepCountModel())
    private let userMock = User(name: "mockname", age: 23, weight: 64, height: 140, gender: .male, target: 1800, targetSteps: 6000, activityLevel: .moderatelyActive)

    var date: Date { mockStorage.date }

    var onSearchFoodSelected: (() -> Void)?
    var onPersonSelected: (() -> Void)?
    var onGraphSelected: (() -> Void)?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(storage: FoodStorage) {
        self.mockStorage = storage
        super.init(nibName: nil, bundle: nil)
    }

    private func setDataForSubviews() {
        try? consumptionEstimator.getCalorieExpandatureForToday(user: userMock) { [weak self] calories in
            DispatchQueue.main.async {
                let consumed = self?.mockStorage.getTotalCalorieIntake() ?? 0
                self?.circleIndicator.setActivity(desired: 1000, actual: 300)
                self?.circleIndicator.setCalories(desired: Double(self?.userMock.target ?? 0), actual: calories)
                self?.summary.setData(burned: calories, consumed: consumed)
                
            }
        }
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(named: "accentGray")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EatenProductsCell.self, forCellReuseIdentifier: EatenProductsCell.identifier)
        
        tableView.layer.borderColor = UIColor(named: "outline")?.cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 16
        tableView.sectionHeaderTopPadding = 5
    }
    
    private func setupConstraints() {
//        caloriesConsumedView.translatesAutoresizingMaskIntoConstraints = false
//        caloriesBurnedView.translatesAutoresizingMaskIntoConstraints = false
        circleIndicator.translatesAutoresizingMaskIntoConstraints = false
        summary.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: circleIndicator.centerXAnchor),
            
            circleIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // привязываем жирометр к верхушке
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: circleIndicator.topAnchor, constant: -40),
            
            circleIndicator.widthAnchor.constraint(equalToConstant: 260),
            circleIndicator.heightAnchor.constraint(equalToConstant: 260)
        ])
        
        NSLayoutConstraint.activate([
            summary.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            summary.heightAnchor.constraint(equalToConstant: 60),
            
            view.centerXAnchor.constraint(equalTo: summary.centerXAnchor),
            circleIndicator.bottomAnchor.constraint(equalTo: summary.topAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: tableView.leftAnchor, constant: -20),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: summary.bottomAnchor, constant: 40),
            tableView.heightAnchor.constraint(equalToConstant: 450)

        ])
    }

    private func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: mockStorage.date)
    }
    
    private func setupDateLabel() {
        todayDateLabel.text = getDateString()
        todayDateLabel.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 30)
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(circleIndicator)
        view.addSubview(summary)
        view.addSubview(tableView)
        setupDateLabel()
        setupTableView()
        setupConstraints()
    }
    
    private func setupBarItems() {
        let person: UIButton = UIButton(type: UIButton.ButtonType.custom)
        let personImage = UIImage(systemName: "person")
        person.setImage(personImage, for: .normal)
        person.addTarget(self, action: #selector(toPerson), for: UIControl.Event.touchUpInside)
        person.tintColor = .white
        let rightbarButtonItem = UIBarButtonItem(customView: person)
        
        let charts: UIButton = UIButton(type: UIButton.ButtonType.custom)
        let chartsImage = UIImage(systemName: "chart.bar")
        charts.setImage(chartsImage, for: .normal)
        charts.addTarget(self, action: #selector(toGraph), for: .touchUpInside)
        charts.tintColor = .white
        let chartsButton = UIBarButtonItem(customView: charts)
        
        navigationItem.rightBarButtonItems = [rightbarButtonItem, chartsButton]
        let search: UIButton = UIButton(type: UIButton.ButtonType.custom)
        let searchImage = UIImage(systemName: "fork.knife")
        searchImage?.withTintColor(.brown)
        search.setImage(searchImage, for: .normal)
        search.tintColor = .white
        search.addTarget(self, action: #selector(toFood), for: UIControl.Event.touchUpInside)
        let leftbarButtonItem = UIBarButtonItem(customView: search)
        navigationItem.leftBarButtonItem?.tintColor = .brown
        navigationItem.leftBarButtonItem = leftbarButtonItem
        navigationItem.title = getDateString()
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundBlack")
        setupBarItems()
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
        onGraphSelected?()
    }
    
}

extension MainScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return translateOrderToDayPart(section: section).rawValue
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
//        header.textLabel?.font = UIFont(name: "Helvetica", size: 14.0)
//        header.textLabel?.textAlignment = NSTextAlignment.left
//    }

}

extension MainScreen: UITableViewDataSource {
    private func translateOrderToDayPart(section: Int) -> Portion.DayPart {
        switch section {
        case 0:
            return .breakfast
        case 1:
            return .lunch
        case 2:
            return .dinner
        case 3:
            return .unspecified
        default:
            print("Появилось новое значение, обнови его обработку тут")
            return .unspecified
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return  Set(mockStorage.allPortions.map { return $0.dayPart }).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentDay = translateOrderToDayPart(section: section)
        let amount = mockStorage.allPortions.filter { $0.dayPart == currentDay }.count

        return amount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EatenProductsCell.identifier) as? EatenProductsCell else {
            return UITableViewCell()
        }
        cell.setData(portion: mockStorage.allPortions[indexPath.row])
        
        return cell
    }
}
