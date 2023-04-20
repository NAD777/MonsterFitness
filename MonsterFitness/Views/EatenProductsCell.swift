//
//  EatenProductsCell.swift
//  MonsterFitness
//
//  Created by Denis on 15.04.2023.
//

import UIKit

class EatenProductsCell: UITableViewCell {
    private let foodTitle = UILabel()
    private let caloriesLabel = UILabel()
    private var foodImage: UIImageView = {
        UIImageView(image: UIImage(named: "burger"))
    }()
    private let foodWeightLabel = UILabel()
    
    static let identifier = "EatenProductsCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mockData()
        addAllToView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addAllToView() {
        self.addSubview(foodTitle)
        self.addSubview(caloriesLabel)
        self.addSubview(foodImage)
        self.addSubview(foodWeightLabel)
    }
    
    private func mockData() {
        foodTitle.text = "Гречневая каша"
        foodWeightLabel.text = "300г."
        caloriesLabel.text = "400 kcal"
        
    }
    
    public func setData(portion: Portion) {
            
        foodTitle.text = portion.dishConsumed.title
        caloriesLabel.text = "\(Int(portion.weightConsumed * portion.dishConsumed.kcal / 100)) kcal."
        foodWeightLabel.text = "\(Int(portion.weightConsumed)) g."
    }
    
    private func setupConstraints() {
        foodTitle.translatesAutoresizingMaskIntoConstraints = false
        caloriesLabel.translatesAutoresizingMaskIntoConstraints = false
        foodImage.translatesAutoresizingMaskIntoConstraints = false
        foodWeightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            foodImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            foodImage.widthAnchor.constraint(equalToConstant: 60),
            foodImage.heightAnchor.constraint(equalToConstant: 60),
            self.leftAnchor.constraint(equalTo: foodImage.leftAnchor, constant: -10),
            
            foodTitle.leftAnchor.constraint(equalTo: foodImage.rightAnchor, constant: 10),
            self.topAnchor.constraint(equalTo: foodTitle.topAnchor, constant: -10),
            foodTitle.widthAnchor.constraint(equalToConstant: 300),
            
            foodImage.rightAnchor.constraint(equalTo: caloriesLabel.leftAnchor, constant: -10),
            foodImage.rightAnchor.constraint(equalTo: foodWeightLabel.leftAnchor, constant: -10),
            
            foodTitle.bottomAnchor.constraint(equalTo: foodWeightLabel.topAnchor, constant: 0),
            foodWeightLabel.bottomAnchor.constraint(equalTo: caloriesLabel.topAnchor, constant: 0)
        ])
    }
}
