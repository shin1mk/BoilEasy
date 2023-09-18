//
//  MainViewController.swift
//  BoilEasy
//
//  Created by SHIN MIKHAIL on 18.09.2023.
//
import UIKit
import SnapKit

final class MainViewController: UIViewController {
    //MARK: Properties
    private let labels = ["Soft", "Medium", "Hard"]
    private var currentIndex = 1

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        createLabels()
        setupGestures()
    }

    //MARK: Methods

    // Функция для создания лейбла
    private func createLabel(text: String, tag: Int) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.tag = tag
        return label
    }
    
    private func createLabels() {
        for (index, labelText) in labels.enumerated() {
            let label = createLabel(text: labelText, tag: index)
            setupLabelConstraints(label, index: index)
            label.textColor = index == currentIndex ? .white : .gray
        }
    }

    // Функция для создания и установки констрейнтов для лейбла
    private func setupLabelConstraints(_ label: UILabel, index: Int) {
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.width.equalTo(view)
            make.height.equalTo(50)
            make.centerX.equalTo(view).offset(CGFloat(index - currentIndex) * (view.frame.width / 3))
            make.centerY.equalTo(view).offset(100)
        }
    }



    private func setupGestures() {
        // Тап
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)

        // Жесты для свайпа влево
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        // Жесты для свайпа вправо
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
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

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: view)
        for (index, label) in view.subviews.enumerated() {
            if let label = label as? UILabel, label.frame.contains(tapLocation), label.tag != currentIndex {
                currentIndex = label.tag
                animateLabels()
                break
            }
        }
    }

    private func animateLabels() {
        UIView.animate(withDuration: 0.3) {
            for (index, label) in self.view.subviews.enumerated() {
                if let label = label as? UILabel {
                    label.snp.updateConstraints { make in
                        make.centerX.equalTo(self.view).offset(CGFloat(index - self.currentIndex) * (self.view.frame.width / 3))
                    }
                    label.textColor = index == self.currentIndex ? .white : .gray
                }
            }
            self.view.layoutIfNeeded()
        }
    }
}
