//
//  FoodEditor.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 15.04.2023.
//

import UIKit
import CoreData

class SelfSizingTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    override var intrinsicContentSize: CGSize {
        let height = min(.infinity, contentSize.height)
        return CGSize(width: contentSize.width, height: height)
    }
}

struct UIPortion {
    enum Preference {
        case unmarkedDish
        case favourite
        
        mutating func flip() -> Preference {
            switch self {
            case .favourite:
                self = .unmarkedDish
            case .unmarkedDish:
                self = .favourite
            }
            
            return self
        }
    }
    
    enum MealTime: Int, Codable {
        case breakfast = 0
        case lunch
        case dinner
        case other
    }
    
    let preference: Preference
    let weight: Int
    let dish: Dish?
    let mealTime: MealTime
}

class FoodEditor: UIViewController {
    struct Model {
        struct Data {
            var dish: Dish
            var weight: Int?
            var preference: FoodViewController.DishesLists.ListType
        }
        var data: Data?
        var weightFieldTap: (String) -> Void
        var onExit: (UIPortion) -> Void
        var onFavouriteAdd: (Dish) -> Void
        var onFavouriteDelete: (Dish) -> Void
    }
    var bus: FoodEditor.Model? {
        didSet {
            weightField.text = "\(bus?.data?.weight ?? 0)"
        }
    }

    struct DishInfo {
        var name: String
        var value: Double
    }

    private lazy var dishDescriptions = [DishInfo]()
    private lazy var divider = UIView()
    private lazy var tableOfContent = UITableView()
    private lazy var favButton = UIButton()
    private lazy var mealPartSeparetedControl = UISegmentedControl()
    private lazy var weightField = UITextField()
    private lazy var mealTime: UIPortion.MealTime = .breakfast
    lazy var preference: UIPortion.Preference = (bus?.data?.preference == .favourite ? UIPortion.Preference.favourite : UIPortion.Preference.unmarkedDish)

    func setUpDevider() {
        divider = UIView()
        divider.backgroundColor = BrandConfig.deviderColor
        view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 2).isActive = true
        divider.layer.cornerRadius = 2
        divider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        divider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
    }

    func setUpTable() {
        tableOfContent = SelfSizingTableView()

        tableOfContent.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")
        tableOfContent.dataSource = self
        tableOfContent.delegate = self

        view.addSubview(tableOfContent)
        tableOfContent.translatesAutoresizingMaskIntoConstraints = false
        tableOfContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        tableOfContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        tableOfContent.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 15).isActive = true
//        tableOfContent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15).isActive = true
        tableOfContent.backgroundColor = BrandConfig.secondaryBackgroudColor
        tableOfContent.layer.cornerRadius = BrandConfig.cornerRadius
        tableOfContent.estimatedRowHeight = 80
        tableOfContent.rowHeight = UITableView.automaticDimension
        tableOfContent.isScrollEnabled = false
    }
    
    func initializeDescriptions() {
        if bus?.data?.dish.kcal != nil {
            let roundedValue = round(100 * (bus?.data?.dish.kcal)!) / 100
            dishDescriptions.append(DishInfo(name: "Kcal", value: roundedValue))
        }

        if bus?.data?.dish.prot != nil {
            let roundedValue = round(100 * (bus?.data?.dish.prot)!) / 100
            dishDescriptions.append(DishInfo(name: "Protein", value: roundedValue))
        }

        if bus?.data?.dish.carb != nil {
            let roundedValue = round(100 * (bus?.data?.dish.carb)!) / 100
            dishDescriptions.append(DishInfo(name: "Carbs", value: roundedValue))
        }

        if bus?.data?.dish.fat != nil {
            let roundedValue = round(100 * (bus?.data?.dish.fat)!) / 100
            dishDescriptions.append(DishInfo(name: "Fat", value: roundedValue))
        }
    }

    func setUpMealPart() {
        let label = UILabel()
        mealPartSeparetedControl = UISegmentedControl()

        label.translatesAutoresizingMaskIntoConstraints = false
        mealPartSeparetedControl.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        view.addSubview(mealPartSeparetedControl)

        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        label.topAnchor.constraint(equalTo: tableOfContent.bottomAnchor, constant: 10).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.text = "Meal"
        label.font = label.font.withSize(20)

        favButton = UIButton()
        view.addSubview(favButton)
        favButton.translatesAutoresizingMaskIntoConstraints = false
        favButton.topAnchor.constraint(equalTo: tableOfContent.bottomAnchor, constant: 10).isActive = true
        favButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        favButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        favButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        favButton.addTarget(self, action: #selector(changePreference), for: .touchUpInside)

        let imagePreference = getImagePreference(preference: preference)
        favButton.setImage(imagePreference, for: .normal)
        
        mealPartSeparetedControl.insertSegment(withTitle: "Breakfast",
                                               at: UIPortion.MealTime.breakfast.rawValue,
                                               animated: false)
        mealPartSeparetedControl.insertSegment(withTitle: "Dinner",
                                               at: UIPortion.MealTime.dinner.rawValue,
                                               animated: false)
        mealPartSeparetedControl.insertSegment(withTitle: "Lunch",
                                               at: UIPortion.MealTime.lunch.rawValue,
                                               animated: false)
        mealPartSeparetedControl.insertSegment(withTitle: "Other",
                                               at: UIPortion.MealTime.other.rawValue,
                                               animated: false)
        mealPartSeparetedControl.topAnchor.constraint(
            equalTo: label.bottomAnchor, constant: 5
        ).isActive = true
        mealPartSeparetedControl.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 10
        ).isActive = true
        mealPartSeparetedControl.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -10
        ).isActive = true
        mealPartSeparetedControl.heightAnchor.constraint(
            equalToConstant: 35
        ).isActive = true
        mealPartSeparetedControl.selectedSegmentIndex = mealTime.rawValue
        mealPartSeparetedControl.selectedSegmentTintColor = BrandConfig.segmentSelectedColor
        let segmentNotSelected = [NSAttributedString.Key.foregroundColor: BrandConfig.segmentNotSelectedTextColor]
        mealPartSeparetedControl.setTitleTextAttributes(segmentNotSelected, for: .normal)

        let segmentSelected = [NSAttributedString.Key.foregroundColor: BrandConfig.segmentSelectedTextColor]
        mealPartSeparetedControl.setTitleTextAttributes(segmentSelected, for: .selected)
        
        mealPartSeparetedControl.addTarget(self, action: #selector(changeMealTime), for: .valueChanged)
    }
    
    @objc func changeMealTime(sender: UISegmentedControl) {
        mealTime = UIPortion.MealTime(rawValue: sender.selectedSegmentIndex)!
    }
    
    @objc func changePreference(sender: UIButton) {
        let image = getImagePreference(preference: preference.flip())
        favButton.setImage(image, for: .normal)
        if let dish = bus?.data?.dish {
            switch preference {
            case .favourite:
                bus?.onFavouriteAdd(dish)
            case .unmarkedDish:
                bus?.onFavouriteDelete(dish)
            }
        }
    }
    
    func getImagePreference(preference: UIPortion.Preference) -> UIImage {
        let image: UIImage!
        let starFillConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        switch preference {
        case .unmarkedDish:
            image = UIImage(systemName: "star", withConfiguration:
                                starFillConfig)?.withTintColor(BrandConfig.segmentSelectedColor,
                                                               renderingMode: .alwaysOriginal)
        case .favourite:
            image = UIImage(systemName: "star.fill", withConfiguration:
                                starFillConfig)?.withTintColor(BrandConfig.segmentSelectedColor,
                                                               renderingMode: .alwaysOriginal)
        }
        return image
    }

    // search field adder
    func setUpWeightPicker() {
        let weightFieldHolder = UIView()
        view.addSubview(weightFieldHolder)
        weightFieldHolder.translatesAutoresizingMaskIntoConstraints = false
        weightFieldHolder.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
        weightFieldHolder.heightAnchor.constraint(equalToConstant: 40).isActive = true
        weightFieldHolder.topAnchor.constraint(equalTo: mealPartSeparetedControl.bottomAnchor,
                                               constant: 15).isActive = true
        weightFieldHolder.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        weightFieldHolder.backgroundColor = BrandConfig.secondaryBackgroudColor
        weightFieldHolder.layer.borderWidth = BrandConfig.borderWidth
        weightFieldHolder.layer.borderColor = BrandConfig.borderColor
        weightFieldHolder.layer.cornerRadius = BrandConfig.cornerRadius

        weightField = UITextField()
        weightFieldHolder.addSubview(weightField)
        weightField.translatesAutoresizingMaskIntoConstraints = false
        weightField.leadingAnchor.constraint(
            equalTo: weightFieldHolder.leadingAnchor, constant: 10
        ).isActive = true
        weightField.trailingAnchor.constraint(equalTo: weightFieldHolder.trailingAnchor,
                                              constant: -10).isActive = true
        weightField.topAnchor.constraint(equalTo: weightFieldHolder.topAnchor).isActive = true
        weightField.bottomAnchor.constraint(equalTo: weightFieldHolder.bottomAnchor).isActive = true
        weightField.textColor = BrandConfig.searchFieldTextColor
        weightField.attributedPlaceholder = NSAttributedString(
            string: "Weight",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        weightField.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDescriptions()
        view.overrideUserInterfaceStyle = .dark
        view.backgroundColor = BrandConfig.backgroundColor
        navigationItem.title = bus?.data?.dish.title
        navigationController?.navigationBar.tintColor = BrandConfig.segmentSelectedColor

        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 20)!]

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItem?.tintColor = BrandConfig.segmentSelectedColor
        setUpDevider()

        setUpTable()

        setUpMealPart()

        setUpWeightPicker()

    }

    @objc func addButtonTapped() {
        let weight = Int("0" + (weightField.text ?? "0")) ?? 0
        let portion: UIPortion = .init(preference: preference,
                                       weight: weight,
                                       dish: bus?.data?.dish,
                                       mealTime: mealTime
                                    )
        bus?.onExit(portion)
    }
}

extension FoodEditor: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dishDescriptions.count
    }
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
        cell.setDishInfo(dishDescriptions[indexPath.row])
        return cell
    }
}
extension FoodEditor: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
}

extension FoodEditor: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(1)
        if textField === weightField {
            bus?.weightFieldTap(textField.text ?? "0")
            return false
        }
        return true
    }
}

class InfoCell: UITableViewCell {
    lazy var title = UILabel()
    lazy var detailsLabel = UILabel()

    func setDish(dish: Dish) {
        title.text = dish.title
        detailsLabel.text = "\(dish.kcal) kcal per 100 g"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stackHolder = UIStackView()
        stackHolder.distribution = .equalSpacing
        stackHolder.axis = .horizontal
        stackHolder.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackHolder)

        NSLayoutConstraint.activate([
            stackHolder.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackHolder.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackHolder.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackHolder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        title.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textColor = .white
        title.font = title.font.withSize(23)
        detailsLabel.textColor = BrandConfig.segmentSelectedColor
        //
        stackHolder.addArrangedSubview(title)
        stackHolder.addArrangedSubview(detailsLabel)
        self.backgroundColor = BrandConfig.secondaryBackgroudColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setDishInfo (_ dishInfo: FoodEditor.DishInfo) {
        title.text = dishInfo.name
        detailsLabel.text = "\(dishInfo.value)"
    }
}
