//
//  ProfileViewController.swift
//  MonsterFitness
//
//  Created by Dmitry on 14.04.2023.
//

import Foundation
import UIKit



struct Stacks {
    var stack = UIStackView()
    var stackForUserInformation1 = UIStackView()
    var stackForUserInformation2 = UIStackView()
    var stackForStep = UIStackView()
    var stackForTarget = UIStackView()
    var stackForType = UIStackView()
}

class BlockWithTarget {
    var minus = UIButton(type: .system)
    var plus = UIButton(type: .system)
    var target = UILabel()
    private var labelTarget = UILabel()
    private var stack = UIStackView()
    private var stackForButton = UIStackView()
    
    init(_ text: String) {
        stackForButton.addArrangedSubview(minus)
        target.textAlignment = .center
        stackForButton.addArrangedSubview(target)
        stackForButton.addArrangedSubview(plus)
        labelTarget.text = text
        labelTarget.font = labelTarget.font.withSize(25)
        labelTarget.textColor = CONFIG.searchFieldTextColor
        labelTarget.textAlignment = .center
        target.font = target.font.withSize(25)
        target.text = "1000"
        settingButton()
        stackForButton.translatesAutoresizingMaskIntoConstraints = false
        stackForButton.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
        stackForButton.isLayoutMarginsRelativeArrangement = true
        
        labelTarget.translatesAutoresizingMaskIntoConstraints = false
        target.translatesAutoresizingMaskIntoConstraints = false
        stackForButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func settingButton() {
        minus.setTitle("-", for: .normal)
        plus.setTitle("+", for: .normal)
        for but in [minus, plus] {
            but.setTitleColor(CONFIG.buttonTextColor, for: .normal)
            but.backgroundColor = CONFIG.buttonBackgroudColor
            but.layer.cornerRadius = CONFIG.buttonCornerRadius
            but.translatesAutoresizingMaskIntoConstraints = false
            but.widthAnchor.constraint(equalToConstant: 80).isActive = true
            but.titleLabel?.font = but.titleLabel?.font.withSize(25)
            
        }
    }
    
    func getStack() -> UIStackView {
        stack.axis = .vertical
        stack.addArrangedSubview(labelTarget)
        stack.addArrangedSubview(stackForButton)
        stackForButton.translatesAutoresizingMaskIntoConstraints = false
        stackForButton.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
        stackForButton.isLayoutMarginsRelativeArrangement = true
        
        labelTarget.translatesAutoresizingMaskIntoConstraints = false
        labelTarget.topAnchor.constraint(equalTo: stack.topAnchor, constant: 8).isActive = true
        return stack
    }
}

class ProfileViewController: UIViewController {
    var onProfieChanged: (() -> Void)?
    
    private let distanceBetweenBlocks = 20
    private var dataForPickers = [UIPickerView: [String]]()
    private var currentRow = [UIPickerView: Int]()
    private var name = UITextField()
    private var stacks = Stacks()
    private var stackArr = [UIPickerView]()
    var targetCalories = BlockWithTarget("Daily goal by calories:")
    var targetSteps = BlockWithTarget("Daily goal by steps:")
    let pickerType = UIPickerView()
    var currentUser: User? {
        didSet {
            update()
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark
        // Do any additional setup after loading the viewa
        settingPickersForUserInformation()
        currentUser = UserProfile().currentUser
        view.backgroundColor = CONFIG.backgroundColor
        stacks.stack.axis = .vertical
        
        settingsName()
        //settingPickersForUserInformation()
        settingsUserInformation()
        settingsStackForTarget()
        settingsStackForStep()
        settingType()
        view.backgroundColor = BrandConfig.backgroundColor
        navigationItem.title = "Profile"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = .init(title: "Done", style: .done, target: self, action: #selector(onButtonTapped))
    }

    @objc func onButtonTapped() {
        var cur = UserProfile()
        cur.currentUser  = User(name: name.text ?? "")
        cur.currentUser?.age = (currentRow[stackArr[0]] ?? 0) + 1
        cur.currentUser?.weight = (currentRow[stackArr[1]] ?? 0) + 20
        cur.currentUser?.height = (currentRow[stackArr[2]] ?? 0) + 100
        cur.currentUser?.gender = Genders(rawValue: currentRow[stackArr[3]] ?? 0)
        cur.currentUser?.target = Int(targetCalories.target.text ?? "") ?? 0
        cur.currentUser?.targetSteps = Int(targetSteps.target.text ?? "") ?? 0
        cur.currentUser?.activityLevel = PhysicalActivityLevel(rawValue: currentRow[pickerType] ?? 0)
        onProfieChanged?()
    }
    
    func settingsName() {
        name.textColor = CONFIG.searchFieldTextColor
        name.placeholder = "Your name"
        name.font = name.font?.withSize(30)
        view.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        name.topAnchor.constraint(equalTo: view.topAnchor, constant: 110).isActive = true
        name.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func settingPickersForUserInformation() {
        let pickerAge = UIPickerView()
        var dataAge = [String]()
        for i in 1...120 {
            dataAge.append(String(i) + " y.o.")
        }
        pickerAge.delegate = self
        pickerAge.dataSource = self
        dataForPickers[pickerAge] = dataAge
        pickerAge.translatesAutoresizingMaskIntoConstraints = false
        pickerAge.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        let pickerWeight = UIPickerView()
        var dataWeight = [String]()
        for i in 20...320 {
            dataWeight.append(String(i) + " kg")
        }
        pickerWeight.delegate = self
        pickerWeight.dataSource = self
        dataForPickers[pickerWeight] = dataWeight
        pickerWeight.translatesAutoresizingMaskIntoConstraints = false
        pickerWeight.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        let pickerHeight = UIPickerView()
        var dataHeight = [String]()
        for i in 100...210 {
            dataHeight.append(String(i) + " cm")
        }
        pickerHeight.delegate = self
        pickerHeight.dataSource = self
        dataForPickers[pickerHeight] = dataHeight
        pickerHeight.translatesAutoresizingMaskIntoConstraints = false
        pickerHeight.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        let pickerGender = UIPickerView()
        let dataGender = ["male", "female", "other"]
        pickerGender.delegate = self
        pickerGender.dataSource = self
        dataForPickers[pickerGender] = dataGender
        pickerGender.translatesAutoresizingMaskIntoConstraints = false
        pickerGender.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        stacks.stackForUserInformation1.addArrangedSubview(pickerAge)
        stacks.stackForUserInformation1.addArrangedSubview(pickerWeight)
        stacks.stackForUserInformation2.addArrangedSubview(pickerHeight)
        stacks.stackForUserInformation2.addArrangedSubview(pickerGender)
        
        stackArr.append(pickerAge)
        stackArr.append(pickerWeight)
        stackArr.append(pickerHeight)
        stackArr.append(pickerGender)
    }
    
    func settingsUserInformation() {
        stacks.stack.axis = .vertical
        stacks.stack.layer.cornerRadius = 16
        stacks.stack.addArrangedSubview(stacks.stackForUserInformation1)
        stacks.stack.addArrangedSubview(stacks.stackForUserInformation2)
        view.addSubview(stacks.stack)
        stacks.stackForUserInformation1.translatesAutoresizingMaskIntoConstraints = false
        stacks.stackForUserInformation2.translatesAutoresizingMaskIntoConstraints = false
        stacks.stack.translatesAutoresizingMaskIntoConstraints = false
        stacks.stack.topAnchor.constraint(equalTo: name.bottomAnchor, constant: CGFloat(distanceBetweenBlocks)).isActive = true
        stacks.stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        stacks.stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        stacks.stack.backgroundColor = CONFIG.deviderColor
        stacks.stackForUserInformation1.distribution = .fillEqually
        stacks.stackForUserInformation1.spacing = 8.0
        
        stacks.stackForUserInformation2.distribution = .fillEqually
        stacks.stackForUserInformation2.spacing = 8.0
        stacks.stack.distribution = .fillEqually
        stacks.stackForUserInformation1.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 4, right: 8)
        stacks.stackForUserInformation1.isLayoutMarginsRelativeArrangement = true
        stacks.stackForUserInformation2.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 8, right: 8)
        stacks.stackForUserInformation2.isLayoutMarginsRelativeArrangement = true
        
        
    }
    
    func settingsStackForTarget() {
        stacks.stackForTarget = targetCalories.getStack()
        view.addSubview(stacks.stackForTarget)
        stacks.stackForTarget.translatesAutoresizingMaskIntoConstraints = false
        stacks.stackForTarget.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        stacks.stackForTarget.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        stacks.stackForTarget.topAnchor.constraint(equalTo: stacks.stack.bottomAnchor, constant: CGFloat(distanceBetweenBlocks)).isActive = true
        stacks.stackForTarget.backgroundColor = CONFIG.deviderColor
        stacks.stackForTarget.layer.cornerRadius = 16
        stacks.stackForTarget.heightAnchor.constraint(equalToConstant: 100).isActive = true
        targetCalories.minus.addAction(UIAction(title: "-", handler: { [weak self] _ in
            var cnt = Int(self?.targetCalories.target.text ?? "0") ?? 0
            cnt = max(cnt - 100, 0)
            self?.targetCalories.target.text = String(cnt)
                        }), for: .touchUpInside)
        
        targetCalories.plus.addAction(UIAction(title: "-", handler: { [weak self] _ in
            var cnt = Int(self?.targetCalories.target.text ?? "0") ?? 0
            cnt = min(cnt + 100, 50000)
            self?.targetCalories.target.text = String(cnt)
                        }), for: .touchUpInside)
    }
    
    func settingsStackForStep() {
        stacks.stackForStep = targetSteps.getStack()
        view.addSubview(stacks.stackForStep)
        stacks.stackForStep.translatesAutoresizingMaskIntoConstraints = false
        stacks.stackForStep.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        stacks.stackForStep.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        stacks.stackForStep.topAnchor.constraint(equalTo: stacks.stackForTarget.bottomAnchor, constant: CGFloat(distanceBetweenBlocks)).isActive = true
        stacks.stackForStep.backgroundColor = CONFIG.deviderColor
        stacks.stackForStep.layer.cornerRadius = 16
        stacks.stackForStep.heightAnchor.constraint(equalToConstant: 100).isActive = true
        targetSteps.minus.addAction(UIAction(title: "-", handler: { [weak self] _ in
            var cnt = Int(self?.targetSteps.target.text ?? "0") ?? 0
            cnt = max(cnt - 100, 0)
            self?.targetSteps.target.text = String(cnt)
                        }), for: .touchUpInside)
        
        targetSteps.plus.addAction(UIAction(title: "-", handler: { [weak self] _ in
            var cnt = Int(self?.targetSteps.target.text ?? "0") ?? 0
            cnt = min(cnt + 100, 50000)
            self?.targetSteps.target.text = String(cnt)
                        }), for: .touchUpInside)
    }
    
    func settingType() {
        let labelTarget = UILabel()
        labelTarget.text = "Your type:"
        labelTarget.font = labelTarget.font.withSize(25)
        labelTarget.textColor = CONFIG.searchFieldTextColor
        labelTarget.textAlignment = .center
    
        pickerType.dataSource = self
        pickerType.delegate = self
        let data = ["Passive type", "Minimally active type", "Moderately active type", "Active type", "Overly active type"]
        dataForPickers[pickerType] = data
        pickerType.translatesAutoresizingMaskIntoConstraints = false
        pickerType.heightAnchor.constraint(equalToConstant: 90).isActive = true
        stacks.stackForType.axis = .vertical
        stacks.stackForType.addArrangedSubview(labelTarget)
        stacks.stackForType.addArrangedSubview(pickerType)
        view.addSubview(stacks.stackForType)
        stacks.stackForType.backgroundColor = CONFIG.deviderColor
        stacks.stackForType.layer.cornerRadius = 16
        stacks.stackForType.translatesAutoresizingMaskIntoConstraints = false
        stacks.stackForType.topAnchor.constraint(equalTo: stacks.stackForStep.bottomAnchor, constant: CGFloat(distanceBetweenBlocks)).isActive = true
        stacks.stackForType.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stacks.stackForType.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        labelTarget.translatesAutoresizingMaskIntoConstraints = false
        labelTarget.topAnchor.constraint(equalTo: stacks.stackForType.topAnchor, constant: 10).isActive = true
    }
    
    func update() {
        // TODO
        name.text = currentUser?.name
        targetCalories.target.text = String(currentUser?.target ?? 0)
        targetSteps.target.text = String(currentUser?.targetSteps ?? 0)
        stackArr[0].selectRow((currentUser?.age ?? 1) - 1, inComponent: 0, animated: true)
        stackArr[1].selectRow((currentUser?.weight ?? 20) - 20, inComponent: 0, animated: true)
        stackArr[2].selectRow((currentUser?.height ?? 100) - 100, inComponent: 0, animated: true)
        stackArr[3].selectRow(currentUser?.gender?.rawValue ?? 0, inComponent: 0, animated: true)
        pickerType.selectRow(currentUser?.activityLevel?.rawValue ?? 0, inComponent: 0, animated: true)
    }
}

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataForPickers[pickerView]?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currentRow[pickerView] = row
        return dataForPickers[pickerView]?[row]
    }
}

struct CONFIG {
    static let backgroundColor: UIColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 13 / 255, alpha: 1)
    static let deviderColor: UIColor = UIColor(red: 40 / 255, green: 40 / 255, blue: 40 / 255, alpha: 1)
    static let buttonBackgroudColor: UIColor = UIColor(red: 30 / 255,
                                                       green: 30 / 255,
                                                       blue: 30 / 255, alpha: 1)
    static let buttonTextColor: UIColor = .white
    static let buttonBorderColor: CGColor = CGColor(gray: 0.3, alpha: 1)
    static let buttonBorderWidth: CGFloat = 1
    static let buttonCornerRadius: CGFloat = 16
    static let colorInactiveButton: CGFloat = 16

    static let spacingBetweenElementsInPicker: CGFloat = 5
    static let pikerButtonsShadowOpacity: Float = 0.6
    static let pikerButtonsColor: CGColor = CGColor(red: 137 / 255,
                                                    green: 143 / 255,
                                                    blue: 85 / 255, alpha: 1)
    static let pikerButtonTextColorInactive: UIColor = UIColor(red: 90 / 255,
                                                    green: 90 / 255,
                                                    blue: 90 / 255, alpha: 1)

    static let segmentSelectedColor: UIColor = .systemGreen

    static let searchFieldTextColor: UIColor = .white

}
