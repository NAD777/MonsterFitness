//
//  CalorieIndicatorView.swift
//  MonsterFitness
//
//  Created by Denis on 14.04.2023.
//

import UIKit

protocol Updatable {
    func getNewCalorieValue(calories: Double)
}

final class CalorieIndicatorView: UIView, Updatable {
    private let calorieLabel = UILabel()
    
    public func getNewCalorieValue(calories: Double) {
        self.calorieLabel.text = String(calories)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(calorieLabel)
        setupConstraints()
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        calorieLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: calorieLabel.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: calorieLabel.centerYAnchor)
        ])
    }
    
    private func setupStyles() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 3
        self.calorieLabel.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 20)
    }
}
