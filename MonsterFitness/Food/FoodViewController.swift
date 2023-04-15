//
//  FoodViewController.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 12.04.2023.
//

import UIKit

// Configutaions for colors and text
private struct CONFIG {
    static let backgroundColor: UIColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 13 / 255, alpha: 1)
    static let deviderColor: UIColor = UIColor(red: 40 / 255, green: 40 / 255, blue: 40 / 255, alpha: 1)
    static let secondaryBackgroudColor: UIColor = UIColor(red: 30 / 255,
                                                          green: 30 / 255,
                                                          blue: 30 / 255, alpha: 1)
    static let borderColor: CGColor = CGColor(gray: 0.3, alpha: 1)
    static let borderWidth: CGFloat = 1
    static let cornerRadius: CGFloat = 16

    static let segmentSelectedColor: UIColor = .systemGreen

    static let searchFieldTextColor: UIColor = .white
    static let segmentNotSelectedTextColor: UIColor = .white
    static let segmentSelectedTextColor: UIColor = .black

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

    var bus: Model?
    var textField: UITextField!
    var pickerSegmentedControl: UISegmentedControl!
    var searchField: UITextField!
    var tableOfContent: UITableView!
    var devider: UIView!
    var searchPlaceHolder: UIView!
    var searchButton: UIButton!

    // MARK: sample data
    var dishes = [
        Dish(title: "Egg", kcal: 100),
        Dish(title: "Meat ball", kcal: 300),
        Dish(title: "Porridge", kcal: 100)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }

    // devider under the navigation bar text
    func setUpDevider() {
        devider = UIView()
        devider.backgroundColor = CONFIG.deviderColor
        view.addSubview(devider)
        devider.translatesAutoresizingMaskIntoConstraints = false
        devider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
        devider.heightAnchor.constraint(equalToConstant: 2).isActive = true
        devider.layer.cornerRadius = 2
        devider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        devider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
    }

    // buttons for pick categories
    func setUpPicker() {
        pickerSegmentedControl = UISegmentedControl()
        view.addSubview(pickerSegmentedControl)
        pickerSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        pickerSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
        pickerSegmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        pickerSegmentedControl.topAnchor.constraint(equalTo: devider.bottomAnchor, constant: 20).isActive = true
        pickerSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true

        pickerSegmentedControl.insertSegment(withTitle: CONFIG.titleFirstSegment, at: 0, animated: false)
        pickerSegmentedControl.insertSegment(withTitle: CONFIG.titleSecondSegment, at: 1, animated: false)
        pickerSegmentedControl.selectedSegmentIndex = 0
        pickerSegmentedControl.selectedSegmentTintColor = CONFIG.segmentSelectedColor
        let segmentNotSelected = [NSAttributedString.Key.foregroundColor: CONFIG.segmentNotSelectedTextColor]
        pickerSegmentedControl.setTitleTextAttributes(segmentNotSelected, for: .normal)

        let segmentSelected = [NSAttributedString.Key.foregroundColor: CONFIG.segmentSelectedTextColor]
        pickerSegmentedControl.setTitleTextAttributes(segmentSelected, for: .selected)

        pickerSegmentedControl.addTarget(self, action: #selector(changeColor), for: .valueChanged)
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
        searchPlaceHolder.backgroundColor = CONFIG.secondaryBackgroudColor
        searchPlaceHolder.layer.borderWidth = CONFIG.borderWidth
        searchPlaceHolder.layer.borderColor = CONFIG.borderColor
        searchPlaceHolder.layer.cornerRadius = CONFIG.cornerRadius

        searchField = UITextField()
        searchPlaceHolder.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.leadingAnchor.constraint(equalTo: searchPlaceHolder.leadingAnchor, constant: 10).isActive = true
        searchField.trailingAnchor.constraint(equalTo: searchPlaceHolder.trailingAnchor, constant: -10).isActive = true
        searchField.topAnchor.constraint(equalTo: searchPlaceHolder.topAnchor).isActive = true
        searchField.bottomAnchor.constraint(equalTo: searchPlaceHolder.bottomAnchor).isActive = true
        searchField.textColor = CONFIG.searchFieldTextColor
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
        searchButton.layer.borderWidth = CONFIG.borderWidth
        searchButton.backgroundColor = CONFIG.secondaryBackgroudColor
        searchButton.layer.borderColor = CONFIG.borderColor
        searchButton.layer.cornerRadius = CONFIG.cornerRadius - 5
        let searchIcon = UIImage(systemName: "magnifyingglass", compatibleWith: .current)?.withTintColor(CONFIG.segmentSelectedColor, renderingMode: .alwaysOriginal)
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
        tableOfContent.backgroundColor = CONFIG.secondaryBackgroudColor
        tableOfContent.layer.cornerRadius = CONFIG.cornerRadius
        tableOfContent.estimatedRowHeight = 80
        tableOfContent.rowHeight = UITableView.automaticDimension
    }

    // creates the whole UI
    func setUpUI () {
        view.backgroundColor = CONFIG.backgroundColor
        navigationItem.title = CONFIG.navigationTitleText
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        setUpDevider()
        setUpPicker()
        setUpSearchField()
        setUpSearchButton()
        setUpTable()
    }

    // function that executes on search button click
    @objc func findForFood(_ sender: UIButton) {
        guard let text = searchField.text else {
            return
        }
        if text.isEmpty {
            searchField.attributedPlaceholder = NSAttributedString(
                string: CONFIG.searchPlaceHolderTextOnEmpty,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
            return
        }

    }

    @objc func changeColor(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }

    @objc func buttonAction() {
        bus?.output = FoodViewController.Model.OutputData(userText: textField.text)
        bus?.onExit()
    }
}

// Custom cell for table
class FoodTableViewCell: UITableViewCell {
    let title = UILabel()
    let detailsLabel = UILabel()

    func setDish(dish: Dish) {
        title.text = dish.title
        detailsLabel.text = "\(dish.kcal) kcal per 100 g"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        title.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(title)
        contentView.addSubview(detailsLabel)

        title.numberOfLines = 0
        title.textColor = .white
        title.font = title.font.withSize(23)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: detailsLabel.topAnchor),

            detailsLabel.topAnchor.constraint(equalTo: title.bottomAnchor),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        detailsLabel.textColor = CONFIG.segmentSelectedColor

        self.backgroundColor = CONFIG.secondaryBackgroudColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension FoodViewController: UITableViewDelegate {

}

extension FoodViewController: UITableViewDataSource {
    func tableView (
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        dishes.count
    }

    func tableView (
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodTableViewCell

        cell.setDish(dish: dishes[indexPath.row])

        return cell
    }

    func tableView (
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
}
