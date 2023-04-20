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
        var favouriteDishes: [Dish]
        var data: InputData?
        var onExit: () -> Void
        var onFoodSelected: (Dish, DishesLists.ListType) -> Void
        var onDeleteFromFavourite: (Dish) -> Void
        var output: OutputData?
        var refreshFavouriteDishes: () -> [Dish]
    }
    struct DishesLists {
        var searchDishes: [Dish]?
        var favouritesDishes: [Dish]?
        enum ListType: Int {
            case search = 0
            case favourite
        }
        
        var type: DishesLists.ListType = .favourite
        var content: [Dish]? {
            get {
                (type == .favourite ? favouritesDishes: searchDishes)
            }
            set {
                if type == .favourite {
                    favouritesDishes = newValue
                } else {
                    searchDishes = newValue
                }
            }
        }
        var count: Int {
            (type == .favourite ? favouritesDishes: searchDishes)?.count ?? 0
        }
    }

    var bus: Model?
//    private lazy var textField = UITextField()
    private lazy var pickerSegmentedControl = UISegmentedControl()
    private lazy var searchField = UITextField()
    private lazy var tableOfContent = UITableView()
    private lazy var divider = UIView()
    private lazy var searchPlaceHolder = UIView()
    private lazy var searchButton = UIButton()
    private lazy var dishesList = DishesLists()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
        dishesList.favouritesDishes = bus?.favouriteDishes
    }
    
    // creates the whole UI
    func setUpUI () {
        view.backgroundColor = BrandConfig.backgroundColor
        navigationItem.title = BrandConfig.navigationTitleText
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        setUpDivider()
        setUpPicker()
        setUpSearchField()
//        setUpSearchButton()
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
        pickerSegmentedControl.topAnchor.constraint(
            equalTo: divider.bottomAnchor, constant: 20
        ).isActive = true
        pickerSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true

        pickerSegmentedControl.insertSegment(withTitle: BrandConfig.titleFirstSegment, at: 0, animated: false)
        pickerSegmentedControl.insertSegment(withTitle: BrandConfig.titleSecondSegment, at: 1, animated: false)
        pickerSegmentedControl.selectedSegmentIndex = DishesLists.ListType.favourite.rawValue
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
//        searchPlaceHolder.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
        searchPlaceHolder.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
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
        searchField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        searchField.delegate = self
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    @objc func managedObjectContextObjectsDidChange() {
        dishesList.favouritesDishes = bus?.refreshFavouriteDishes()
        tableOfContent.reloadData()
    }

    // function that executes on search button click
    @objc func findForFood() {
        guard let text = searchField.text else {
            return
        }

        Edamam.shared.retriveDishes(name: text) { [weak self] dishes in
            self?.dishesList.content = dishes
            DispatchQueue.main.async {
                self?.tableOfContent.reloadData()
            }
        }
    }

    @objc func changeDishesList(sender: UISegmentedControl) {
        searchField.text = ""
        self.dishesList.type = (dishesList.type == .favourite ? .search : .favourite)
//        print(searchField.text)
        if let textFieldText = searchField.text {
            if dishesList.type == .favourite {
                dishesList.content = applyFilter(filerText: textFieldText, dishes: dishesList.content ?? [])
                tableOfContent.reloadData()
            } else if dishesList.type == .search {
                APICallAndUpdate(requestedText: textFieldText)
//                tableOfContent.reloadData()
            }
        }
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
        if let selectedDish = dishesList.content?[indexPath.row] {
            bus?.onFoodSelected(selectedDish, dishesList.type)
        }
    }

    func tableView(
        _ tableView: UITableView,
        canEditRowAt indexPath: IndexPath
    ) -> Bool {
        return dishesList.type == .favourite
    }
    
    func tableView (
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            if let deletedDish = dishesList.content?[indexPath.row] {
                bus?.onDeleteFromFavourite(deletedDish)
                dishesList.content = bus?.refreshFavouriteDishes()
                tableOfContent.reloadData()
            }
        }
    }
}

extension FoodViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        if dishesList.type == .search {
            APICallAndUpdate(requestedText: newText)
        } else if dishesList.type == .favourite {
            dishesList.favouritesDishes = bus?.refreshFavouriteDishes()
            dishesList.favouritesDishes = applyFilter(filerText: newText, dishes: dishesList.content ?? [])
            tableOfContent.reloadData()
        }
        return true
    }
    
    func applyFilter(filerText: String, dishes: [Dish]) -> [Dish] {
        var newList: [Dish] = .init()
        for currentDish in dishes {
            let currentDishTitleLower = currentDish.title.lowercased()
            let filterTextLower = filerText.lowercased()
            if currentDishTitleLower.hasPrefix(filterTextLower) {
                newList.append(currentDish)
            }
        }
        return newList
    }
    
    func APICallAndUpdate(requestedText: String) {
        Edamam.shared.retriveDishes(name: requestedText) { [weak self] dishes in
            DispatchQueue.main.async {
//                if self?.searchField.text != requestedText {
                self?.pickerSegmentedControl.selectedSegmentIndex = 0
                self?.dishesList.content = dishes
                self?.tableOfContent.reloadData()
//                }
            }
        }
    }
//
//    func textFieldShouldBeginEditing(
//        _ textField: UITextField
//    ) -> Bool {
//        if textField === searchField {
//            dishesList.canDelete = false
//            pickerSegmentedControl.selectedSegmentIndex = 0
//            tableOfContent.reloadData()
//        }
//        return true
//    }
}
