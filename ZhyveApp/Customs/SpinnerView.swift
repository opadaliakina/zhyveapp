//
//  SpinnerView.swift
//  ZhyveApp
//
//  Created by Anton Charny on 8/19/20.
//  Copyright © 2020 NavekSoft. All rights reserved.
//

import UIKit

class SpinnerView: UIView {

    let spinningCircle = CAShapeLayer()
    var isAnimation = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print ("spinner deinit")
    }
    
    private func configure(frame: CGRect) {
        
        self.frame = frame
        
        let rect = self.bounds
        let circularPath = UIBezierPath(ovalIn: rect)
        
        spinningCircle.path = circularPath.cgPath
        spinningCircle.fillColor = UIColor.clear.cgColor
        spinningCircle.strokeColor = UIColor.init(hex: 0xE81E1E).cgColor
        spinningCircle.lineWidth = 5
        spinningCircle.strokeEnd = 0.1
        spinningCircle.lineCap = .round
        
        self.layer.addSublayer(spinningCircle)
    }
    
    func animate() {
        isAnimation = true
        animateDraw()
        animateSpin()
    }
    
    func removeAnimation() {
        isAnimation = false
        spinningCircle.removeAllAnimations()
    }
    
    func completeCircle(forTime time: CFTimeInterval) {
        let animation = spinningCircle.animation(forKey: "MyAnimation")?.mutableCopy() as? CABasicAnimation
        spinningCircle.strokeStart = 0
        spinningCircle.strokeEnd = 0.9
        animation?.toValue = 1
        animation?.fillMode = .removed
        animation?.duration = time
        animation?.autoreverses = false
        animation?.repeatCount = 0
        animation?.speed = 0.5
        animation?.repeatDuration = 0
        if let anim = animation {
            self.spinningCircle.add(anim, forKey: "MyAnimation")
        }
    }
    
    private func animateDraw() {
        spinningCircle.strokeStart = 0
        spinningCircle.strokeEnd = 0
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0.55
        animation.duration = 1.5
        animation.fillMode = .forwards
        animation.autoreverses = true
        animation.repeatCount = .greatestFiniteMagnitude
        self.spinningCircle.add(animation, forKey: "MyAnimation")
    }
    
    private func animateSpin() {
        if isAnimation {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.transform = CGAffineTransform(rotationAngle: .pi)
            }) { (competed) in
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                    self.transform = CGAffineTransform(rotationAngle: 0)
                }) { (completed) in
                    self.animateSpin()
                }
            }
        }
    }
}
