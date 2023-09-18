/*
import UIKit
import SnapKit

final class MainViewController: UIViewController {
    var labels = ["Soft", "Medium", "Hard"]
    var currentIndex = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        createLabels()
        swipeGesture()
    }

    private func swipeGesture() {
        // Добавьте жесты для свайпа влево и вправо
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }

    private func createLabels() {
        for (index, labelText) in labels.enumerated() {
            let label = UILabel()
            label.text = labelText
            label.textAlignment = .center
            view.addSubview(label)

            label.snp.makeConstraints { make in
                make.width.equalTo(view)
                make.height.equalTo(50)
                make.centerX.equalTo(view).offset(CGFloat(index - currentIndex) * (view.frame.width / 3))
                make.centerY.equalTo(view).offset(100)
            }
        }
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

    private func animateLabels() {
        UIView.animate(withDuration: 0.3) {
            for (index, label) in self.view.subviews.enumerated() {
                if let label = label as? UILabel {
                    label.snp.updateConstraints { make in
                        make.centerX.equalTo(self.view).offset(CGFloat(index - self.currentIndex) * (self.view.frame.width / 3))
                    }
                }
            }
            self.view.layoutIfNeeded()
        }
    }
}
*/



/*
Мягкие вареные яйца (Soft-Boiled Eggs):
Мягко-вареное яйцо с жидким желтком: 4-5 минут.
Мягко-вареное яйцо с полужидким желтком: 6-7 минут.
Средне-мягкие вареные яйца (Medium-Boiled Eggs):
Средне-мягкое яйцо с немного жидким центром: 8-9 минут.
Твердые вареные яйца (Hard-Boiled Eggs):
Твердое яйцо с полностью застывшим желтком: 10-12 минут.
*/
