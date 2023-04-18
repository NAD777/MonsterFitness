//
//  FoodEditor.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 15.04.2023.
//

import UIKit

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

class FoodEditor: UIViewController {
    struct Model {
        struct Data {
            var dish: Dish
            var weight: Int?
        }
        var data: Data?
        var weightFieldTap: (String) -> Void
        var onExit: () -> Void
//        var output: OutputData?
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
    private lazy var mealPartSeparetedControl = UISegmentedControl()
    private lazy var weightField = UITextField()
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
    //
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
        print(bus?.data?.dish)
        if bus?.data?.dish.kcal != nil {
            dishDescriptions.append(DishInfo(name: "Kcal", value: (bus?.data?.dish.kcal)!))
        }

        if bus?.data?.dish.prot != nil {
            dishDescriptions.append(DishInfo(name: "Protein", value: (bus?.data?.dish.prot)!))
        }

        if bus?.data?.dish.carb != nil {
            dishDescriptions.append(DishInfo(name: "Carbs", value: (bus?.data?.dish.carb)!))
        }

        if bus?.data?.dish.fat != nil {
            dishDescriptions.append(DishInfo(name: "Protein", value: (bus?.data?.dish.fat)!))
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

        let favButton = UIButton()
        view.addSubview(favButton)
        favButton.translatesAutoresizingMaskIntoConstraints = false
        favButton.topAnchor.constraint(equalTo: tableOfContent.bottomAnchor, constant: 10).isActive = true
        favButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        favButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        favButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        let starFillConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let starFill = UIImage(systemName: "star.fill", withConfiguration:
                                starFillConfig)?.withTintColor(BrandConfig.segmentSelectedColor,
                                                               renderingMode: .alwaysOriginal)

        favButton.setImage(starFill, for: .normal)
//        searchButton.addTarget(self, action: #selector(findForFood), for: .touchUpInside)

        mealPartSeparetedControl.insertSegment(withTitle: "Breakfast", at: 0, animated: false)
        mealPartSeparetedControl.insertSegment(withTitle: "Lunch", at: 1, animated: false)
        mealPartSeparetedControl.insertSegment(withTitle: "Dinner", at: 1, animated: false)
        mealPartSeparetedControl.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        mealPartSeparetedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        mealPartSeparetedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        mealPartSeparetedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        mealPartSeparetedControl.selectedSegmentIndex = 0
        mealPartSeparetedControl.selectedSegmentTintColor = BrandConfig.segmentSelectedColor
        let segmentNotSelected = [NSAttributedString.Key.foregroundColor: BrandConfig.segmentNotSelectedTextColor]
        mealPartSeparetedControl.setTitleTextAttributes(segmentNotSelected, for: .normal)

        let segmentSelected = [NSAttributedString.Key.foregroundColor: BrandConfig.segmentSelectedTextColor]
        mealPartSeparetedControl.setTitleTextAttributes(segmentSelected, for: .selected)
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
        weightField.leadingAnchor.constraint(equalTo: weightFieldHolder.leadingAnchor, constant: 10).isActive = true
        weightField.trailingAnchor.constraint(equalTo: weightFieldHolder.trailingAnchor, constant: -10).isActive = true
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
        // Handle button tap
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
