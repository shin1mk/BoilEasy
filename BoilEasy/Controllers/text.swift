////
////  text.swift
////  BoilEasy
////
////  Created by SHIN MIKHAIL on 18.09.2023.
////
//
//import Foundation
////
////  MainViewController.swift
////  BoilEasy
////
////  Created by SHIN MIKHAIL on 18.09.2023.
////
//
//import Foundation
//import UIKit
//import SnapKit
//
//final class MainViewController: UIViewController {
//
//    var labels = [UILabel]()
//    var currentIndex = 1
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        createLabels()
//
//        // Добавьте жесты для свайпа влево и вправо
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
//        swipeLeft.direction = .left
//        view.addGestureRecognizer(swipeLeft)
//
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
//        swipeRight.direction = .right
//        view.addGestureRecognizer(swipeRight)
//    }
//
//    func createLabels() {
//        for i in 0..<3 {
//            let label = UILabel()
//            label.text = "Label \(i + 1)"
//            label.textAlignment = .center
//            view.addSubview(label)
//            labels.append(label)
//
//            // Используйте SnapKit для размещения лейблов
//            label.snp.makeConstraints { make in
//                make.width.equalTo(view)
//                make.height.equalTo(50)
////                make.centerX.equalTo(view).offset(CGFloat(i - currentIndex) * view.frame.width)
//                make.centerX.equalTo(view).offset(CGFloat(i - currentIndex) * (view.frame.width / 3)) // Уменьшаем смещение в 2 раза
//
//                make.centerY.equalTo(view).offset(100)
//            }
//        }
//    }
//
//    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
//        switch gesture.direction {
//        case .left:
//            currentIndex = (currentIndex + 1) % labels.count
//        case .right:
//            currentIndex = (currentIndex - 1 + labels.count) % labels.count
//        default:
//            break
//        }
//
//        animateLabels()
//    }
//
//    func animateLabels() {
//        UIView.animate(withDuration: 0.3) {
//            for (index, label) in self.labels.enumerated() {
//                label.snp.updateConstraints { make in
//                    make.centerX.equalTo(self.view).offset(CGFloat(index - self.currentIndex) * self.view.frame.width)
//                }
//            }
//            self.view.layoutIfNeeded()
//        }
//    }
//}
