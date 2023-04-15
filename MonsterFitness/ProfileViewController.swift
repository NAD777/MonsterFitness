//
//  ProfileViewController.swift
//  MonsterFitness
//
//  Created by Dmitry on 14.04.2023.
//

import Foundation
import UIKit

class GenetareBlock {
    var textfiled = UITextField()
    var label = UILabel()
    var block: UIStackView {
        let curStack = UIStackView()
        curStack.addArrangedSubview(textfiled)
        curStack.addArrangedSubview(label)
        curStack.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        curStack.layer.cornerRadius = 14
        curStack.widthAnchor.constraint(equalToConstant: 80).isActive = true
        curStack.translatesAutoresizingMaskIntoConstraints = false
        return curStack
    }
    init(count: String, placeholder: String, unit: String) {
        textfiled.text = count
        label.text = unit
        textfiled.placeholder = "Your " + placeholder
        textfiled.font = UIFont(name: ".default", size: 25)
        label.font = UIFont(name: ".default", size: 25)
        textfiled.layer.contentsGravity = .center
//        label.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        textfiled.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }
}

class UserView: UIView {
    var stack = UIStackView()
    var stackForUserInformation1 = UIStackView()
    var stackForUserInformation2 = UIStackView()
    var stackForButton = UIStackView()
    var stackForTarget = UIStackView()
    var name = UITextField()
    var age: GenetareBlock?
    var weight: GenetareBlock?
    var height: GenetareBlock?
    var gender: GenetareBlock?
    var minus = UIButton()
    var plus = UIButton()
    var target = UILabel()
}

class ProfileViewController: UIViewController {
    private var userView = UserView()
    var currentUser: User? {
        didSet {
            userView.name.text = currentUser?.name
            userView.age = GenetareBlock(count: String(currentUser?.age ?? 15), placeholder: "age", unit: "y.o.")
            userView.weight = GenetareBlock(count: String(currentUser?.weight ?? 0), placeholder: "weight", unit: "kg")
            userView.height = GenetareBlock(count: String(currentUser?.height ?? 0), placeholder: "height", unit: "cm")
            switch currentUser?.gender {
            case .male:
                userView.gender = GenetareBlock(count: "male", placeholder: "gender", unit: "")
            case .female:
                userView.gender = GenetareBlock(count: "female", placeholder: "gender", unit: "")
            default:
                userView.gender = GenetareBlock(count: "strange", placeholder: "gender", unit: "")
            }
            userView.target.text = String(currentUser?.target ?? 0)
        }
    }
    override func viewDidLoad() {
        //navigationItem.
        
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .dark
        // Do any additional setup after loading the viewa
        currentUser = User(name: "Bob", age: 19, weight: 48, height: 198, gender: .male, target: 6600)
        view.backgroundColor = CONFIG.backgroundColor
        userView.stack.axis = .vertical
    
        userView.stackForButton.addArrangedSubview(userView.minus)
        userView.target.textAlignment = .center
        userView.stackForButton.addArrangedSubview(userView.target)
        userView.stackForButton.addArrangedSubview(userView.plus)
        self.settingsName()
        self.settingsUserInformation()
        self.settingsButtons()
        self.settingsStackForTarget()
    }
    
    func settingsName() {
        userView.name.textColor = CONFIG.searchFieldTextColor
        userView.name.font = UIFont(name: ".default", size: 50)
        view.addSubview(userView.name)
        userView.name.translatesAutoresizingMaskIntoConstraints = false
        userView.name.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        userView.name.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
    }
    
    func settingsUserInformation() {
        userView.stackForUserInformation1.addArrangedSubview(userView.age?.block ?? UILabel())
        userView.stackForUserInformation1.addArrangedSubview(userView.weight?.block ?? UILabel())
        userView.stackForUserInformation2.addArrangedSubview(userView.height?.block ?? UILabel())
        userView.stackForUserInformation2.addArrangedSubview(userView.gender?.block ?? UILabel())
        userView.stack.axis = .vertical
        userView.stack.addArrangedSubview(userView.stackForUserInformation1)
        userView.stack.addArrangedSubview(userView.stackForUserInformation2)
        view.addSubview(userView.stack)
        userView.stack.translatesAutoresizingMaskIntoConstraints = false
        userView.stack.topAnchor.constraint(equalTo: userView.name.bottomAnchor, constant: 100).isActive = true
        userView.stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        userView.stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        
        userView.stack.backgroundColor = CONFIG.deviderColor
        
    }
    
    func settingsStackForTarget() {
        let labelTarget = UILabel()
        labelTarget.text = "Your target:"
        labelTarget.font = UIFont(name: ".default", size: 40)
        labelTarget.textColor = CONFIG.searchFieldTextColor
        labelTarget.textAlignment = .center
        userView.target.font = UIFont(name: "default", size: 40)
        userView.stackForTarget.axis = .vertical
        userView.stackForTarget.addArrangedSubview(labelTarget)
        userView.stackForTarget.addArrangedSubview(userView.stackForButton)
        view.addSubview(userView.stackForTarget)
        userView.stackForTarget.translatesAutoresizingMaskIntoConstraints = false
        userView.stackForTarget.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        userView.stackForTarget.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        userView.stackForTarget.topAnchor.constraint(equalTo: userView.stack.bottomAnchor, constant: 90).isActive = true
        userView.stackForTarget.backgroundColor = CONFIG.deviderColor
        userView.stackForTarget.layer.cornerRadius = 16
        userView.stackForButton.translatesAutoresizingMaskIntoConstraints = false
        
        userView.stackForButton.leftAnchor.constraint(equalTo: userView.stackForTarget.leftAnchor, constant: 30).isActive = true
        userView.stackForButton.rightAnchor.constraint(equalTo: userView.stackForTarget.rightAnchor, constant: -30).isActive = true
        userView.stackForButton.bottomAnchor.constraint(equalTo: userView.stackForTarget.bottomAnchor, constant: 30).isActive = true
        
        labelTarget.translatesAutoresizingMaskIntoConstraints = false
        labelTarget.leftAnchor.constraint(equalTo: userView.stack.leftAnchor, constant: 0).isActive = true
        labelTarget.rightAnchor.constraint(equalTo: userView.stack.rightAnchor, constant: 0).isActive = true
    }
    
    func settingsButtons() {
        userView.minus.setTitle("-", for: .normal)
        userView.plus.setTitle("+", for: .normal)
        
        
        userView.minus.addAction(UIAction(title: "-", handler: { [weak self] _ in
            var cnt = Int(self?.userView.target.text ?? "0") ?? 0
            cnt = max(cnt - 100, 0)
            self?.userView.target.text = String(cnt)
                        }), for: .touchUpInside)
        
        userView.plus.addAction(UIAction(title: "-", handler: { [weak self] _ in
            var cnt = Int(self?.userView.target.text ?? "0") ?? 0
            cnt = min(cnt + 100, 50000)
            self?.userView.target.text = String(cnt)
                        }), for: .touchUpInside)
        
        let buttons = [userView.minus, userView.plus]
        for but in buttons {
            but.setTitleColor(CONFIG.buttonTextColor, for: .normal)
            but.backgroundColor = CONFIG.buttonBackgroudColor
            but.layer.cornerRadius = CONFIG.buttonCornerRadius
            but.translatesAutoresizingMaskIntoConstraints = false
            but.widthAnchor.constraint(equalToConstant: 60).isActive = true
            
        }
//
//        userView.minus.backgroundColor = CONFIG.buttonBackgroudColor
//        userView.plus.backgroundColor = CONFIG.buttonBackgroudColor
//        userView.minus.layer.borderColor = CONFIG.buttonBorderColor
//        userView.minus.setTitleColor(CONFIG.buttonTextColor, for: .normal)
//        userView.plus.setTitleColor(CONFIG.buttonTextColor, for: .normal)
//        userView.plus.layer.borderColor = CONFIG.buttonBorderColor
//        userView.minus.layer.cornerRadius = CONFIG.buttonCornerRadius
//        userView.plus.layer.cornerRadius = CONFIG.buttonCornerRadius
        
    }
}
