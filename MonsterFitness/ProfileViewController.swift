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
        curStack.backgroundColor = CONFIG.buttonBackgroudColor
        curStack.layer.cornerRadius = 14
        //curStack.widthAnchor.constraint(equalToConstant: 80).isActive = true
        curStack.translatesAutoresizingMaskIntoConstraints = false
        textfiled.leftAnchor.constraint(equalTo: curStack.leftAnchor, constant: 10).isActive = true
        curStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return curStack
    }
    init(count: String, placeholder: String, unit: String) {
        textfiled.text = count
        label.text = unit
        textfiled.placeholder = placeholder
        textfiled.font = textfiled.font?.withSize(25)
        label.font = label.font.withSize(25)
        label.translatesAutoresizingMaskIntoConstraints = false
        textfiled.translatesAutoresizingMaskIntoConstraints = false
        textfiled.widthAnchor.constraint(equalToConstant: 55).isActive = true
        textfiled.textAlignment = .natural
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
    var age: GenetareBlock!
    var weight: GenetareBlock!
    var height: GenetareBlock!
    var gender: GenetareBlock!
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
        userView.name.placeholder = "Your name"
        userView.name.font = userView.name.font?.withSize(50)
        view.addSubview(userView.name)
        userView.name.translatesAutoresizingMaskIntoConstraints = false
        userView.name.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        userView.name.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
    }
    
    func settingsUserInformation() {
        userView.stackForUserInformation1.addArrangedSubview(userView.age.block)
        userView.stackForUserInformation1.addArrangedSubview(userView.weight.block)
        userView.stackForUserInformation2.addArrangedSubview(userView.height.block)
        userView.stackForUserInformation2.addArrangedSubview(userView.gender.block)
        userView.stack.axis = .vertical
        userView.stack.layer.cornerRadius = 16
        userView.stack.addArrangedSubview(userView.stackForUserInformation1)
        userView.stack.addArrangedSubview(userView.stackForUserInformation2)
        view.addSubview(userView.stack)
        userView.stackForUserInformation1.translatesAutoresizingMaskIntoConstraints = false
        userView.stackForUserInformation2.translatesAutoresizingMaskIntoConstraints = false
        userView.stack.translatesAutoresizingMaskIntoConstraints = false
        userView.stack.topAnchor.constraint(equalTo: userView.name.bottomAnchor, constant: 40).isActive = true
        userView.stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        userView.stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        
        userView.stack.backgroundColor = CONFIG.deviderColor
        userView.stackForUserInformation1.distribution = .fillEqually
                userView.stackForUserInformation1.spacing = 8.0
        
        userView.stackForUserInformation2.distribution = .fillEqually
                userView.stackForUserInformation2.spacing = 8.0
        userView.stack.distribution = .fillEqually
        userView.stackForUserInformation1.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 4, right: 8)
        userView.stackForUserInformation1.isLayoutMarginsRelativeArrangement = true
        userView.stackForUserInformation2.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 8, right: 8)
        userView.stackForUserInformation2.isLayoutMarginsRelativeArrangement = true
        
        
    }
    
    func settingsStackForTarget() {
        let labelTarget = UILabel()
        labelTarget.text = "Your target:"
        labelTarget.font = labelTarget.font.withSize(25)
        labelTarget.textColor = CONFIG.searchFieldTextColor
        labelTarget.textAlignment = .center
        
        userView.target.font = userView.target.font.withSize(25)
        userView.stackForTarget.axis = .vertical
        userView.stackForTarget.addArrangedSubview(labelTarget)
        userView.stackForTarget.addArrangedSubview(userView.stackForButton)
        view.addSubview(userView.stackForTarget)
        userView.stackForTarget.translatesAutoresizingMaskIntoConstraints = false
        userView.stackForTarget.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        userView.stackForTarget.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        userView.stackForTarget.topAnchor.constraint(equalTo: userView.stack.bottomAnchor, constant: 40).isActive = true
        userView.stackForTarget.backgroundColor = CONFIG.deviderColor
        userView.stackForTarget.layer.cornerRadius = 16
        userView.stackForButton.translatesAutoresizingMaskIntoConstraints = false
        userView.stackForButton.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
                userView.stackForButton.isLayoutMarginsRelativeArrangement = true
        
        labelTarget.translatesAutoresizingMaskIntoConstraints = false
        labelTarget.topAnchor.constraint(equalTo: userView.stackForTarget.topAnchor, constant: 8).isActive = true
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
            but.widthAnchor.constraint(equalToConstant: 80).isActive = true
            but.titleLabel?.font = but.titleLabel?.font.withSize(25)
            
        }
        
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
