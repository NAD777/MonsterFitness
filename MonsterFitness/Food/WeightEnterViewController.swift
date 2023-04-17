//
//  WeightEnterViewController.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 16.04.2023.
//

import UIKit

class WeightEnterViewController: UIViewController {
    struct Model {
        var weight: String?
        var onExit: (String) -> Void
    }

    var bus: WeightEnterViewController.Model?

    private lazy var enterWeight = UITextField()
    private var topEnterWeightConstraint: NSLayoutConstraint!
    func setUpViews() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton

        enterWeight = UITextField()
        enterWeight.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(enterWeight)

        enterWeight.textAlignment = .center
        enterWeight.backgroundColor = BrandConfig.secondaryBackgroudColor
        enterWeight.heightAnchor.constraint(equalToConstant: 60).isActive = true
        enterWeight.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        enterWeight.keyboardType = .decimalPad
        enterWeight.text = bus?.weight

        topEnterWeightConstraint = enterWeight.topAnchor.constraint(
            equalTo: view.topAnchor, constant: view.frame.height / 3)
        topEnterWeightConstraint.isActive = true
        //        topEnterWeightConstraint.
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.topEnterWeightConstraint.isActive = false
            self?.topEnterWeightConstraint = self!.enterWeight.topAnchor.constraint(
                equalTo: self!.view.safeAreaLayoutGuide.topAnchor, constant: 0)
            self?.topEnterWeightConstraint.isActive = true
            self?.view.layoutIfNeeded()
        }
//        enterWeight.becomeFirstResponder()
    }

    @objc func doneButtonTapped(_ actor: UIButton) {
        let value = enterWeight.text ?? "0"
        bus?.onExit(value)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BrandConfig.backgroundColor
        setUpViews()
        // Do any additional setup after loading the view.
    }
}
