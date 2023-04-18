//
//  CalorieSummaryView.swift
//  MonsterFitness
//
//  Created by Denis on 14.04.2023.
//

import UIKit

final class CalorieSummaryView: UIView {
    private let burnedLabel = UILabel()
    private let consumedLabel = UILabel()
    
    private var burnedImageView: UIImageView!
    private var consumedImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImages()
        addSubviews()
        setupStyles()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        drawSeparator()
        self.backgroundColor = UIColor(named: "accentGray")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawSeparator() {
        let centerX = frame.width / 2
        let margin: CGFloat = 10
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: centerX, y: margin))
        path.addLine(to: CGPoint(x: centerX, y: self.bounds.height-margin))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor(named: "acidicGreen")?.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = .round
        shapeLayer.shadowRadius = 30
        shapeLayer.shadowOpacity = 0.35
        shapeLayer.shadowColor = UIColor.black.cgColor
        self.layer.addSublayer(shapeLayer)
        
    }
    
    // deprecated
    private func setupFrames() {
        let centerX = frame.width / 2
        let centerY = frame.height / 2
        let horizontalMargin: CGFloat = 10

        burnedImageView.frame = CGRect(x: 10, y: centerY-25, width: 50, height: 50)
        burnedLabel.frame = CGRect(x: 10+50+horizontalMargin, y: centerY-10, width: 60, height: 20)

        consumedImageView.frame = CGRect(x: centerX+10, y: centerY-25, width: 50, height: 50)
        consumedLabel.frame = CGRect(x: centerX+10+50+horizontalMargin, y: centerY-10, width: 60, height: 20)
    }
    
    private func setupConstraints() {
        burnedLabel.translatesAutoresizingMaskIntoConstraints = false
        consumedLabel.translatesAutoresizingMaskIntoConstraints = false
        burnedImageView.translatesAutoresizingMaskIntoConstraints = false
        consumedImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.centerYAnchor.constraint(equalTo: burnedImageView.centerYAnchor),
            burnedImageView.centerYAnchor.constraint(equalTo: burnedLabel.centerYAnchor),
            burnedLabel.centerYAnchor.constraint(equalTo: consumedImageView.centerYAnchor),
            consumedImageView.centerYAnchor.constraint(equalTo: consumedLabel.centerYAnchor),
            consumedLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            consumedImageView.widthAnchor.constraint(equalToConstant: 50),
            burnedImageView.widthAnchor.constraint(equalToConstant: 50),
            consumedImageView.heightAnchor.constraint(equalToConstant: 50),
            burnedImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(greaterThanOrEqualTo: burnedImageView.leftAnchor, constant: -10),
            burnedImageView.rightAnchor.constraint(greaterThanOrEqualTo: burnedLabel.leftAnchor, constant: -10),
            burnedLabel.rightAnchor.constraint(greaterThanOrEqualTo: self.centerXAnchor, constant: -10),
            self.centerXAnchor.constraint(greaterThanOrEqualTo: consumedImageView.leftAnchor, constant: -10),
            consumedImageView.rightAnchor.constraint(greaterThanOrEqualTo: consumedLabel.leftAnchor, constant: -10),
            consumedLabel.rightAnchor.constraint(greaterThanOrEqualTo: self.rightAnchor, constant: -10)
        ])
        
    }
    
    private func setupImages() {
        let burned = UIImage(named: "burnedCalories")
        let consumed = UIImage(named: "burger")
        self.burnedImageView = UIImageView(image: burned)
        self.consumedImageView = UIImageView(image: consumed)
    }
    
    private func addSubviews() {
        self.addSubview(burnedLabel)
        self.addSubview(consumedLabel)
        self.addSubview(burnedImageView)
        self.addSubview(consumedImageView)
    }
    
    private func setupStyles() {
        self.layer.cornerRadius = 16
//        self.layer.shadowRadius = 1
//        self.layer.shadowOpacity = 0.7
//        self.layer.shadowOffset = CGSize(width: 10, height: 10)
//        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.borderColor = UIColor(named: "outline")?.cgColor
        self.layer.borderWidth = 1
        
    }
    
    public func setData(burned: Double, consumed: Double) {
        burnedLabel.text = String(Int(burned))
        consumedLabel.text = String(Int(consumed))
    }
}
