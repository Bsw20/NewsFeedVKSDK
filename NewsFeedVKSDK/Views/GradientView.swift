//
//  GradientView.swift
//  NewsFeedVKSDK
//
//  Created by Ярослав Карпунькин on 11.12.2020.
//

import Foundation
import UIKit

class GradientView: UIView {
    
    private var startColor: UIColor = #colorLiteral(red: 1, green: 0.5529411765, blue: 0.5529411765, alpha: 1)
    private var endColor: UIColor = #colorLiteral(red: 1, green: 0.831372549, blue: 0.4745098039, alpha: 1)
    
    private let gradientLayer = CAGradientLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        self.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
