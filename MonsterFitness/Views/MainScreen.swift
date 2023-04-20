//
//  MainScreen.swift
//  MonsterFitness
//
//  Created by Denis on 14.04.2023.
//

import UIKit

final class MainScreen: UIViewController {
    // тут костыль, размер задается через фрейм и констрейнты одновременно
    private let circleIndicator = WheelIndicator(frame: CGRect(x: 0, y: 0, width: 260, height: 260))
    private let summary = CalorieSummaryView(frame: .zero)
    
    private var tableView = UITableView(frame: .zero)
    
    private let mockStorage: FoodStorage
    private let consumptionEstimator = ConsumptionEstimation(pedometerImpl: StepCountModel())

    var date: Date { mockStorage.date }
    
    var defaultsUser: User =  {
        let user = UserProfile().currentUser
        guard let user = user else {
            print("defaults is unavailable")
            return User(name: "mockname", age: 23, weight: 64, height: 140, gender: .male, target: 1800, targetSteps: 6000, activityLevel: .moderatelyActive)
        }
        return user
    }()

    private let stepModel: StepCountModel = {
        let stepModel = StepCountModel()
        stepModel.authorizeHealthKit()
        return stepModel
    }()

    var onSearchFoodSelected: (() -> Void)?
    var onPersonSelected: (() -> Void)?
    var onCalendarSelected: (() -> Void)?
    
    private let headerView = UIView(frame: .zero)

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // дерни эту ссылку чтобы обновить мою таблицу
    public func updateAll() {
        let newUser = UserProfile().currentUser
        guard let newUser = newUser else {
            print("update is unavailable")
            return
        }
        defaultsUser = newUser
        // FIXME: - не обновляется юзер
        print(defaultsUser.targetSteps)
        DispatchQueue.main.async { [weak self] in
            self?.mockStorage.updateStorage()
            self?.tableView.reloadData()
        }
        
        try? stepModel.getStepCountForTodayForAsync() { arg in
            switch arg {
            case .success(let success):
                self.circleIndicator.setActivity(desired: Double(self.defaultsUser.targetSteps ?? 5000), actual: Double(success))
            case .failure(let failure):
                print(failure.localizedDescription)
                return
            }
        }
        
        try? consumptionEstimator.getCalorieExpandatureForToday(user: defaultsUser) { [weak self] calories in
            DispatchQueue.main.async {
                let consumed = self?.mockStorage.getTotalCalorieIntake() ?? 0
                self?.circleIndicator.setCalories(desired: Double(self?.defaultsUser.target ?? 0), actual: consumed / 100)
                self?.summary.setData(burned: calories, consumed: consumed / 100)
            }
        }
    }

    init(storage: FoodStorage) {
        self.mockStorage = storage
        super.init(nibName: nil, bundle: nil)
    }

    private func setDataForSubviews() {
        try? consumptionEstimator.getCalorieExpandatureForToday(user: defaultsUser) { [weak self] calories in
            DispatchQueue.main.async {
                let consumed = self?.mockStorage.getTotalCalorieIntake() ?? 0
                self?.circleIndicator.setCalories(desired: Double(self?.defaultsUser.target ?? 0), actual: consumed / 100)
                self?.summary.setData(burned: calories, consumed: consumed / 100)
                
            }
        }
    }
    
    private func setupHeader() {
        headerView.frame = CGRect(x: 0, y: 0, width: 0, height: 390)
        headerView.addSubview(circleIndicator)
        headerView.addSubview(summary)
        
        circleIndicator.translatesAutoresizingMaskIntoConstraints = false
        summary.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.centerXAnchor.constraint(equalTo: circleIndicator.centerXAnchor),
            headerView.topAnchor.constraint(equalTo: circleIndicator.topAnchor, constant: -20),
            
            circleIndicator.widthAnchor.constraint(equalToConstant: 260),
            circleIndicator.heightAnchor.constraint(equalToConstant: 260),
            
            circleIndicator.bottomAnchor.constraint(equalTo: summary.topAnchor, constant: -40),
            summary.heightAnchor.constraint(equalToConstant: 60),
            headerView.leftAnchor.constraint(equalTo: summary.leftAnchor, constant: -10),
            summary.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -10)
        ])
        
        tableView.tableHeaderView = headerView
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(named: "accentGray")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EatenProductsCell.self, forCellReuseIdentifier: EatenProductsCell.identifier)

        tableView.layer.borderColor = UIColor(named: "outline")?.cgColor
//        tableView.layer.borderWidth = 1
//        tableView.layer.cornerRadius = 16
        tableView.sectionHeaderTopPadding = 5
    }

    private func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formated = dateFormatter.string(from: mockStorage.date)
        return "<    \(formated)    >"
    }
    
    override func loadView() {
        super.loadView()
        view.overrideUserInterfaceStyle = .dark
        view.addSubview(tableView)
        setupHeader()
        tableView.frame = view.frame
        tableView.showsVerticalScrollIndicator = false

        setupTableView()
    }
    
    private func setupBarItems() {
        let person: UIButton = UIButton(type: UIButton.ButtonType.custom)
        let personImage = UIImage(systemName: "person")
        person.setImage(personImage, for: .normal)
        person.addTarget(self, action: #selector(toPerson), for: UIControl.Event.touchUpInside)
        person.tintColor = .systemGreen
        let rightbarButtonItem = UIBarButtonItem(customView: person)
        navigationItem.rightBarButtonItem = rightbarButtonItem

        let search: UIButton = UIButton(type: UIButton.ButtonType.custom)
        let searchImage = UIImage(systemName: "fork.knife")
        searchImage?.withTintColor(.brown)
        search.setImage(searchImage, for: .normal)
        search.tintColor = .systemGreen
        search.addTarget(self, action: #selector(toFood), for: UIControl.Event.touchUpInside)
        let leftbarButtonItem = UIBarButtonItem(customView: search)
        navigationItem.leftBarButtonItem?.tintColor = .brown
        navigationItem.leftBarButtonItem = leftbarButtonItem
    }

    private func setupBarTitle() {
        navigationItem.backButtonTitle = "Back"
        navigationItem.title = getDateString()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toCalender))
        navigationController?.navigationBar.tintColor = BrandConfig.segmentSelectedColor
        navigationController?.navigationBar.addGestureRecognizer(tapGestureRecognizer)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundBlack")
        setupBarItems()
        setupBarTitle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setDataForSubviews()
        setActivityWheel()
    }
    
    private func setActivityWheel() {
        try? stepModel.getStepCountForTodayForAsync { [weak self] arg in
            DispatchQueue.main.async {
                switch arg {
                case .success(let success):
                    self?.circleIndicator.setActivity(desired: Double(self?.defaultsUser.targetSteps ?? 300), actual: Double(success))
                case .failure(let failure):
                    print("failure")
                    return
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateAll()
    }
    
    @objc func toFood() {
        onSearchFoodSelected?()
    }
    
    @objc func toPerson() {
        onPersonSelected?()
    }
    
    @objc func toCalender() {
        onCalendarSelected?()
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            print(indexPath)
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
