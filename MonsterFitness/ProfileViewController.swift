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
    var stackForUserInformation = UIStackView()
    var stackForButton = UIStackView()
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
    var curUser: User? {
        didSet {
            userView.name.text = curUser?.name
            userView.age = GenetareBlock(count: String(curUser?.age ?? 15), placeholder: "age", unit: "y.o.")
            userView.weight = GenetareBlock(count: String(curUser?.weight ?? 0), placeholder: "weight", unit: "kg")
            userView.height = GenetareBlock(count: String(curUser?.height ?? 0), placeholder: "height", unit: "cm")
            switch curUser?.gender {
            case .male:
                userView.gender = GenetareBlock(count: "male", placeholder: "gender", unit: "")
            case .female:
                userView.gender = GenetareBlock(count: "female", placeholder: "gender", unit: "")
            default:
                userView.gender = GenetareBlock(count: "strange", placeholder: "gender", unit: "")
            }
            userView.target.text = String(curUser?.target ?? 0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the viewa
        curUser = User(name: "Bob", age: 19, weight: 48, height: 198, gender: .male, target: 6600)
        view.backgroundColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1.00)
        userView.stack.axis = .vertical
        userView.stackForUserInformation.addArrangedSubview(userView.age?.block ?? UILabel())
        userView.stackForUserInformation.addArrangedSubview(userView.weight?.block ?? UILabel())
        userView.stackForUserInformation.addArrangedSubview(userView.height?.block ?? UILabel())
        userView.stackForUserInformation.addArrangedSubview(userView.gender?.block ?? UILabel())
        userView.stack.axis = .vertical
        userView.stack.addArrangedSubview(userView.name)
        userView.stack.addArrangedSubview(userView.stackForUserInformation)
        userView.name.font = UIFont(name: ".defaul", size: 50)
        userView.target.font = UIFont(name: ".defaul", size: 50)
        view.addSubview(userView.stack)
        userView.stack.translatesAutoresizingMaskIntoConstraints = false
        userView.stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userView.stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        userView.stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        let labelTarget = UILabel()
        labelTarget.text = "Your target:"
        labelTarget.font = UIFont(name: ".defaul", size: 50)
        userView.stack.addArrangedSubview(labelTarget)
        userView.stackForButton.addArrangedSubview(userView.minus)
        userView.target.textAlignment = .center
        userView.stackForButton.addArrangedSubview(userView.target)
        userView.stackForButton.addArrangedSubview(userView.plus)
        userView.stack.addArrangedSubview(userView.stackForButton)
        userView.stackForButton.centerXAnchor.constraint(equalTo: userView.stack.centerXAnchor).isActive = true
        self.settingsButtons()
    }
    func settingsButtons() {
        userView.minus.setTitle("-", for: .normal)
        userView.plus.setTitle("+", for: .normal)
        userView.minus.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        userView.minus.layer.cornerRadius = 10
        userView.plus.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        userView.plus.layer.cornerRadius = 10
        userView.minus.translatesAutoresizingMaskIntoConstraints = false
        userView.plus.translatesAutoresizingMaskIntoConstraints = false
        userView.plus.widthAnchor.constraint(equalToConstant: 60).isActive = true
        userView.minus.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        userView.minus.addAction(UIAction(title: "-", handler: { _ in
            var cnt = Int(self.userView.target.text ?? "0") ?? 0
            cnt -= 100
            if cnt < 0 {
                cnt = 0
            }
            self.userView.target.text = String(cnt)
                        }), for: .touchUpInside)
        
        userView.plus.addAction(UIAction(title: "-", handler: { _ in
            var cnt = Int(self.userView.target.text ?? "0") ?? 0
            cnt += 100
            if cnt > 50000 {
                cnt = 50000
            }
            self.userView.target.text = String(cnt)
                        }), for: .touchUpInside)
    }
}
