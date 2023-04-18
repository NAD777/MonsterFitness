//
//  WheelIndicator.swift
//  MonsterFitness
//
//  Created by Denis on 18.04.2023.
//

import UIKit

final class WheelIndicator: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawWheel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let trackLayerOuter = CAShapeLayer()
    private let shapeLayerOuter = CAShapeLayer()
    
    private let trackLayerInner = CAShapeLayer()
    private let shapeLayerInner = CAShapeLayer()
    
    private func drawWheel() {
        let center = self.center
        let circularOuterPath = UIBezierPath(arcCenter: center, radius: frame.width/2,
                                        startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayerOuter.path = circularOuterPath.cgPath
        
        trackLayerOuter.strokeColor = UIColor(named: "circleDarkMagenta")?.cgColor
        trackLayerOuter.lineWidth = 15
        trackLayerOuter.fillColor = UIColor.clear.cgColor
        trackLayerOuter.lineCap = CAShapeLayerLineCap.round
        self.layer.addSublayer(trackLayerOuter)
        
        shapeLayerOuter.path = circularOuterPath.cgPath
        shapeLayerOuter.strokeColor = UIColor(named: "circleMagenta")?.cgColor
        shapeLayerOuter.lineWidth = 13
        shapeLayerOuter.fillColor = UIColor.clear.cgColor
        shapeLayerOuter.lineCap = CAShapeLayerLineCap.round
        
        shapeLayerOuter.strokeEnd = 0
        
        self.layer.addSublayer(shapeLayerOuter)

        let circularInnerPath = UIBezierPath(arcCenter: center, radius: frame.width/2 - 18,
                                        startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayerInner.path = circularInnerPath.cgPath
        
        trackLayerInner.strokeColor = UIColor(named: "circleDarkGreen")?.cgColor
        trackLayerInner.lineWidth = 14
        trackLayerInner.fillColor = UIColor.clear.cgColor
        trackLayerInner.lineCap = CAShapeLayerLineCap.round
        self.layer.addSublayer(trackLayerInner)
        
        shapeLayerInner.path = circularInnerPath.cgPath
        shapeLayerInner.strokeColor = UIColor(named: "circleGreen")?.cgColor
        shapeLayerInner.lineWidth = 12
        shapeLayerInner.fillColor = UIColor.clear.cgColor
        shapeLayerInner.lineCap = CAShapeLayerLineCap.round
        
        shapeLayerInner.strokeEnd = 0
        
        self.layer.addSublayer(shapeLayerInner)
    }
    
    // число в диапазоне [0, 1]
    public func setCalories(fillValue: Double) {
        shapeLayerOuter.add(animationHelper(fillValue: fillValue), forKey: "")
    }
    
    // число в диапазоне [0, 1]
    public func setActivity(fillValue: Double) {
        shapeLayerInner.add(animationHelper(fillValue: fillValue), forKey: "")
    }
    
    private func animationHelper(fillValue: Double) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = fillValue * 0.8
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        return basicAnimation
    }
    
}
