//
//  FatMeterView.swift
//  MonsterFitness
//
//  Created by Denis on 14.04.2023.
//

import UIKit

final class FatMeterView: UIView {
    var radialGradient: UIImageView!
    
    lazy var arrow: UIImageView = {
        let image = UIImage(named: "arrow")
        self.arrow = UIImageView(image: image)
        arrow.frame = CGRect(origin: CGPoint(x: 14, y: 14), size: CGSize(width: 70, height: 70))
        return arrow
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWheel()
        self.addSubview(radialGradient)
        self.addSubview(arrow)
    }

    private func setupWheel() {
        let image = UIImage(named: "radialWheel")
        radialGradient = UIImageView(image: image)
        radialGradient.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }
    
    private func degToRad(deg: Double) -> CGFloat {
        return CGFloat(deg * 0.0174533)
    }
    
    private func updateFrame() {
        let divisor = 1.4
        let diffWidth = bounds.width - bounds.width/divisor
        let diffHeight = bounds.height - bounds.height/divisor
        let newBounds = CGRect(origin: CGPoint(x: diffWidth/2, y: diffHeight/2),
                               size: CGSize(width: bounds.width/divisor, height: bounds.height/divisor))
        
        arrow.frame = newBounds

        arrow.layer.setAffineTransform(CGAffineTransform(rotationAngle: degToRad(deg: -90)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func setData(caloriesDiff: Double) {
        // нормируем разницу калорий
        var coeff = caloriesDiff / 500
        if coeff > 1 {
            coeff = 1
        } else if coeff < -1 {
            coeff = -1
        }
        UIView.animate(withDuration: 2, delay: 6, usingSpringWithDamping: 0.3, initialSpringVelocity: 4) { [weak self] in
            DispatchQueue.main.async {
                self?.arrow.layer.setAffineTransform(CGAffineTransform(rotationAngle: (self?.degToRad(deg: (coeff*130)-90))!))
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
