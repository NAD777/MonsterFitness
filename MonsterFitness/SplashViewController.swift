//
//  SplashViewController.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 21.04.2023.
//

import UIKit

class SplashViewController: UIViewController {
    
    lazy var label = UILabel()
    lazy var lower = UIView()
    lazy var upper = UIView()
    
    lazy var palka = UIView()
    
    private var topUpper: NSLayoutConstraint!
    private var bottomLower: NSLayoutConstraint!
    
    let width: CGFloat = 6
    
    var callBack: (() -> Void)?
    
    func upperBracket() {
        upper = UIView()
        view.addSubview(upper)
        upper.translatesAutoresizingMaskIntoConstraints = false
        upper.backgroundColor = BrandConfig.segmentSelectedColor
        upper.widthAnchor.constraint(equalTo: label.widthAnchor).isActive = true
        upper.heightAnchor.constraint(equalToConstant: width).isActive = true
        upper.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topUpper = upper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        topUpper.isActive = true
    }
    
    func lowerBracket() {
        lower = UIView()
        view.addSubview(lower)
        lower.translatesAutoresizingMaskIntoConstraints = false
        lower.backgroundColor = BrandConfig.segmentSelectedColor
        lower.widthAnchor.constraint(equalTo: label.widthAnchor).isActive = true
        lower.heightAnchor.constraint(equalToConstant: width).isActive = true
        lower.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomLower = lower.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomLower.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label = UILabel()
        view.addSubview(label)
        view.backgroundColor = BrandConfig.backgroundColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Monster Fitness"
        label.textColor = .white
        
        guard let customFont = UIFont(name: "Helvetica", size: 28) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
//
        label.font = customFont
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        upperBracket()
        lowerBracket()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.animate()
        }
        
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.topUpper.isActive = false
            self?.bottomLower.isActive = false
            
            self?.upper.bottomAnchor.constraint(equalTo: self!.label.topAnchor, constant: -10).isActive = true
            self?.lower.topAnchor.constraint(equalTo: self!.label.bottomAnchor, constant: 10).isActive = true
            self?.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.callBack!()
        }
    }
}
