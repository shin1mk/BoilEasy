//
//  TimerCircleView.swift
//  BoilEasy
//
//  Created by SHIN MIKHAIL on 20.09.2023.
//

import Foundation
import UIKit
import SnapKit

class TimerCircleView: UIView {
    private var shapeLayer: CAShapeLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        createCircleLayer()
    }

    private func createCircleLayer() {
        shapeLayer = CAShapeLayer()
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
            radius: min(bounds.width, bounds.height) / 2 - 5,
            startAngle: -.pi / 2,
            endAngle: 2 * .pi - .pi / 2,
            clockwise: true
        )
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.systemBlue.cgColor
        shapeLayer.strokeColor = UIColor.systemRed.cgColor

        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 1
        layer.addSublayer(shapeLayer)
    }

    func setProgress(_ progress: Float) {
        shapeLayer.strokeEnd = CGFloat(progress)
    }
    func setProgressHalf() {
        shapeLayer.strokeEnd = 0.5
    }

}
