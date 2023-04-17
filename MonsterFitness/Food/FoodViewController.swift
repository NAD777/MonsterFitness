//
//  FoodViewController.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 12.04.2023.
//

import UIKit

// Configutaions for colors and text
public struct BrandConfig {
    static let backgroundColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 13 / 255, alpha: 1)

    static let deviderColor = UIColor(red: 40 / 255, green: 40 / 255, blue: 40 / 255, alpha: 1)
    static let secondaryBackgroudColor: UIColor = UIColor(red: 30 / 255,
                                                          green: 30 / 255,
                                                          blue: 30 / 255, alpha: 1)
    static let borderColor = CGColor(gray: 0.3, alpha: 1)
    static let borderWidth: CGFloat = 1
    static let cornerRadius: CGFloat = 16

    static let segmentSelectedColor: UIColor = .systemGreen

    static let searchFieldTextColor: UIColor = .white
    static let segmentNotSelectedTextColor: UIColor = .white
    static let segmentSelectedTextColor: UIColor = .black
    
    static let cellTitleFontSize: CGFloat = 23

    static let titleFirstSegment = "Search"
    static let titleSecondSegment = "Favourites"

    static let navigationTitleText = "Food"

    static let searchPlaceHolderText = "Search"
    static let searchPlaceHolderTextOnEmpty = "Fill the field"
}

// View controller for dish picker table
class FoodViewController: UIViewController {
    // data bus model for FoodViewController
    struct Model {
        struct InputData {
            var derivedString: String
        }
        struct OutputData {
            var userText: String?
        }
        var data: InputData?
        var onExit: () -> Void
        var output: OutputData?
    }
    struct DishesLists {
        var searchDishes: [Dish]?
        var favouritesDishes: [Dish]?
        var canDelete = false
        var content: [Dish]? {
            get {
                (canDelete ? favouritesDishes: searchDishes)
            }
            set {
                if canDelete {
                    favouritesDishes = newValue
                } else {
                    searchDishes = newValue
                }
            }
        }
        var count: Int {
            (canDelete ? favouritesDishes: searchDishes)?.count ?? 0
        }
    }

    var bus: Model?
    private lazy var textField = UITextField()
    private lazy var pickerSegmentedControl = UISegmentedControl()
    private lazy var searchField = UITextField()
    private lazy var tableOfContent = UITableView()
    private lazy var         divider = UIView()
    private lazy var searchPlaceHolder = UIView()
    private lazy var searchButton = UIButton()
    private lazy var dishesList = DishesLists()

    // MARK: sample data
    var dishes = [
        Dish(title: "Egg", kcal: 100, prot: 0, fat: 0, carb: 0),
        Dish(title: "Meat ball", kcal: 300, prot: 0, fat: 0, carb: 0),
        Dish(title: "Porridge", kcal: 100, prot: 0, fat: 0, carb: 0)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
        dishesList.favouritesDishes = dishes
    }
    
    // creates the whole UI
    func setUpUI () {
        view.backgroundColor = BrandConfig.backgroundColor
        navigationItem.title = BrandConfig.navigationTitleText
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        setUpDivider()
        setUpPicker()
        setUpSearchField()
        setUpSearchButton()
        setUpTable()
    }

    // devider under the navigation bar text
    func setUpDivider() {
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

    // buttons for pick categories
    func setUpPicker() {
        pickerSegmentedControl = UISegmentedControl()
        view.addSubview(pickerSegmentedControl)
        pickerSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        pickerSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
        pickerSegmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        pickerSegmentedControl.topAnchor.constraint(equalTo:         divider.bottomAnchor, constant: 20).isActive = true
        pickerSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true

        pickerSegmentedControl.insertSegment(withTitle: BrandConfig.titleFirstSegment, at: 0, animated: false)
        pickerSegmentedControl.insertSegment(withTitle: BrandConfig.titleSecondSegment, at: 1, animated: false)
        pickerSegmentedControl.selectedSegmentIndex = 0
        pickerSegmentedControl.selectedSegmentTintColor = BrandConfig.segmentSelectedColor
        let segmentNotSelected = [NSAttributedString.Key.foregroundColor: BrandConfig.segmentNotSelectedTextColor]
        pickerSegmentedControl.setTitleTextAttributes(segmentNotSelected, for: .normal)

        let segmentSelected = [NSAttributedString.Key.foregroundColor: BrandConfig.segmentSelectedTextColor]
        pickerSegmentedControl.setTitleTextAttributes(segmentSelected, for: .selected)

        pickerSegmentedControl.addTarget(self, action: #selector(changeDishesList), for: .valueChanged)
    }

    // search field adder
    func setUpSearchField() {
        searchPlaceHolder = UIView()
        view.addSubview(searchPlaceHolder)
        searchPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        searchPlaceHolder.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
        searchPlaceHolder.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchPlaceHolder.topAnchor.constraint(equalTo: pickerSegmentedControl.bottomAnchor, constant: 15).isActive = true
        searchPlaceHolder.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        searchPlaceHolder.backgroundColor = BrandConfig.secondaryBackgroudColor
        searchPlaceHolder.layer.borderWidth = BrandConfig.borderWidth
        searchPlaceHolder.layer.borderColor = BrandConfig.borderColor
        searchPlaceHolder.layer.cornerRadius = BrandConfig.cornerRadius

        searchField = UITextField()
        searchPlaceHolder.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.leadingAnchor.constraint(equalTo: searchPlaceHolder.leadingAnchor, constant: 10).isActive = true
        searchField.trailingAnchor.constraint(equalTo: searchPlaceHolder.trailingAnchor, constant: -10).isActive = true
        searchField.topAnchor.constraint(equalTo: searchPlaceHolder.topAnchor).isActive = true
        searchField.bottomAnchor.constraint(equalTo: searchPlaceHolder.bottomAnchor).isActive = true
        searchField.textColor = BrandConfig.searchFieldTextColor
        searchField.placeholder = "IOS "
        searchField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
    }

    // creates search button
    func setUpSearchButton() {
        searchButton = UIButton()
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.leadingAnchor.constraint(equalTo: searchPlaceHolder.trailingAnchor, constant: 10).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        searchButton.topAnchor.constraint(equalTo: pickerSegmentedControl.bottomAnchor, constant: 15).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchButton.layer.borderWidth = BrandConfig.borderWidth
        searchButton.backgroundColor = BrandConfig.secondaryBackgroudColor
        searchButton.layer.borderColor = BrandConfig.borderColor
        searchButton.layer.cornerRadius = BrandConfig.cornerRadius - 5
        let searchIcon = UIImage(systemName: "magnifyingglass", compatibleWith: .current)?.withTintColor(BrandConfig.segmentSelectedColor, renderingMode: .alwaysOriginal)
        searchButton.setImage(searchIcon, for: .normal)
        searchButton.addTarget(self, action: #selector(findForFood), for: .touchUpInside)
    }

    // creates table for dishes
    func setUpTable() {
        tableOfContent = UITableView()

        tableOfContent.register(FoodTableViewCell.self, forCellReuseIdentifier: "FoodCell")
        tableOfContent.dataSource = self
        tableOfContent.delegate = self

        view.addSubview(tableOfContent)
        tableOfContent.translatesAutoresizingMaskIntoConstraints = false
        tableOfContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        tableOfContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        tableOfContent.topAnchor.constraint(equalTo: searchPlaceHolder.bottomAnchor, constant: 15).isActive = true
        tableOfContent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15).isActive = true
        tableOfContent.backgroundColor = BrandConfig.secondaryBackgroudColor
        tableOfContent.layer.cornerRadius = BrandConfig.cornerRadius
        tableOfContent.estimatedRowHeight = 80
        tableOfContent.rowHeight = UITableView.automaticDimension
    }

    // function that executes on search button click
    @objc func findForFood() {
        guard let text = searchField.text else {
            return
        }
//        if text.isEmpty {
//
////            searchField.placeholder
//            searchField.attributedPlaceholder = NSAttributedString(
//                string: BrandConfig.searchPlaceHolderTextOnEmpty,
//                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
//            )
//            return
//        }

        Edamam.shared.retriveDishes(name: text) { [weak self] dishes in
            self?.dishesList.content = dishes
            DispatchQueue.main.async {
                self?.tableOfContent.reloadData()
            }
        }

    }

    @objc func changeDishesList(sender: UISegmentedControl) {
        self.dishesList.canDelete.toggle()
        self.tableOfContent.reloadData()
    }
}

extension FoodViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        false
//    }
}

extension FoodViewController: UITableViewDataSource {
    func tableView (
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        dishesList.count
    }

    func tableView (
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FoodTableViewCell.identifier, for: indexPath) as! FoodTableViewCell
        cell.setDish(dish: dishesList.content![indexPath.row])
        
        return cell
    }

    func tableView (
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let foodEditor = FoodEditor()
        foodEditor.bus = FoodEditor.Model(data: .init(dish: dishesList.content![indexPath.row])) {
            print(1)
        }
        print(1)
        navigationController?.pushViewController(foodEditor, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        canEditRowAt indexPath: IndexPath
    ) -> Bool {
        return dishesList.canDelete
    }
    
    func tableView (
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
          print("Deleted")
        }
    }
}
