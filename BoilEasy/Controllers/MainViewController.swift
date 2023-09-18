//
//  MainViewController.swift
//  BoilEasy
//
//  Created by SHIN MIKHAIL on 18.09.2023.
//

import Foundation
import UIKit

final class MainViewController: UIViewController {
    
    var labels = [UILabel]()
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLabels()
        
        // Добавьте жесты для свайпа влево и вправо
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    func createLabels() {
        for i in 0..<3 {
            let label = UILabel()
            label.text = "Label \(i + 1)"
            label.textAlignment = .center
            label.frame = CGRect(x: CGFloat(i) * view.frame.width, y: 100, width: view.frame.width, height: 50)
            view.addSubview(label)
            labels.append(label)
        }
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            currentIndex = (currentIndex + 1) % labels.count
        case .right:
            currentIndex = (currentIndex - 1 + labels.count) % labels.count
        default:
            break
        }
        
        animateLabels()
    }
    
    func animateLabels() {
        let xOffset = CGFloat(currentIndex) * view.frame.width
        UIView.animate(withDuration: 0.3) {
            for (index, label) in self.labels.enumerated() {
                label.frame.origin.x = CGFloat(index - self.currentIndex) * self.view.frame.width
            }
        }
    }
}

