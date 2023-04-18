//
//  FoodTableViewCell.swift
//  MonsterFitness
//
//  Created by Антон Нехаев on 17.04.2023.
//

import UIKit

// Custom cell for table
class FoodTableViewCell: UITableViewCell {
    static let identifier = "FoodCell"
    private let title = UILabel()
    private let detailsLabel = UILabel()

    func setDish(dish: Dish) {
        title.text = dish.title
        detailsLabel.text = "\(round(dish.kcal * 100) / 100) kcal per 100 g"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        title.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(title)
        contentView.addSubview(detailsLabel)

        title.numberOfLines = 0
        title.textColor = .white
        title.font = title.font.withSize(BrandConfig.cellTitleFontSize)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: detailsLabel.topAnchor),

            detailsLabel.topAnchor.constraint(equalTo: title.bottomAnchor),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        detailsLabel.textColor = BrandConfig.segmentSelectedColor

        backgroundColor = BrandConfig.secondaryBackgroudColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
