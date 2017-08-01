//
//  UI.swift
//  Pomodoro
//
//  Created by Payal Kothari on 5/4/17.
//  Copyright © 2017 Payal Kothari. All rights reserved.
//

import UIKit

class UI: UIView {
    var circleLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        let x = 190
        let y = 190
        let center = CGPoint(x:x , y: y )
        let radius: CGFloat = 130
        let startAngle: CGFloat = CGFloat(-Double.pi/2)
        let endAngle: CGFloat = CGFloat(2 * Double.pi)
       
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        
        if frame.size.width == 5 {  // circle at the beginning
            circleLayer.strokeColor = UIColor.yellow.cgColor
        } else {        // circle as time passes
            circleLayer.strokeColor = UIColor.red.cgColor
        }
        circleLayer.lineWidth = 15.0;
        circleLayer.strokeEnd = 0.0
        
        // adding the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pauseAnimation() {
        let time: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = time
    }
    
    func resumeAnimation() {
        let time: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - time
        layer.beginTime = timeSincePause
    }
    
    func clearLayers() {
        circleLayer.removeFromSuperlayer()
    }
    
    func animateCircle(duration: TimeInterval) {
        // to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        circleLayer.strokeEnd = 1.0
        circleLayer.add(animation, forKey: "animateCircleLayer")
    }
}
