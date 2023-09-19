/* вариант с рабочим таймером
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
     
     
     var timer: Timer?
     var secondsRemaining = 5 * 60 // Устанавливаем начальное время в 5 минут (5 * 60 секунд)
     var isTimerRunning = false // Переменная для отслеживания состояния таймера

     let timerLabel: UILabel = {
         let label = UILabel()
         label.text = "05:00"
         label.font = UIFont.systemFont(ofSize: 24)
         label.textAlignment = .center
         return label
     }()
     let startButton: UIButton = {
         let button = UIButton()
         button.setTitle("Старт", for: .normal)
         button.setTitleColor(.blue, for: .normal)
         return button
     }()
     //MARK: Lifecycle
     override func viewDidLoad() {
         super.viewDidLoad()
         createLabels()
         setupGestures()
         
         target()
     }
     //MARK: - Methods
     // созданиe лейбла
     private func createLabel(text: String, tag: Int) -> UILabel {
         let label = UILabel()
         label.text = text
         label.font = UIFont.systemFont(ofSize: 24)
         label.textAlignment = .center
         label.tag = tag
         return label
     }
     
     private func createLabels() {
         for (index, labelText) in labels.enumerated() {
             let label = createLabel(text: labelText, tag: index)
             setupConstraints(label, index: index)
             label.textColor = index == currentIndex ? .white : .gray
         }
     }
     //MARK: - Constraints
     private func setupConstraints(_ label: UILabel, index: Int) {
         view.backgroundColor = .darkGray
         
         view.addSubview(label)
         label.snp.makeConstraints { make in
             make.width.equalTo(view)
             make.height.equalTo(50)
             make.centerX.equalTo(view).offset(CGFloat(index - currentIndex) * (view.frame.width / 3))
             make.top.equalTo(view).offset(100)
         }
         view.addSubview(timerLabel)
         timerLabel.snp.makeConstraints { (make) in
             make.centerX.equalToSuperview()
             make.centerY.equalToSuperview()
             make.width.equalTo(view).multipliedBy(0.8)
         }
         view.addSubview(startButton)
         startButton.snp.makeConstraints { (make) in
             make.centerX.equalToSuperview()
             make.top.equalTo(timerLabel.snp.bottom).offset(20) // Размещаем кнопку под меткой таймера
         }
     }
     //MARK: - Gestures
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
     //MARK: - handleSwipe
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
     //MARK: - handleTap
     @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
         let tapLocation = gesture.location(in: view)
         for (_, label) in view.subviews.enumerated() {
             if let label = label as? UILabel, label.frame.contains(tapLocation), label.tag != currentIndex {
                 currentIndex = label.tag
                 animateLabels()
                 break
             }
         }
     }
     //MARK: - Animate
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
     //MARK: - timer
     @objc func startButtonTapped() {
         if isTimerRunning {
             pauseTimer()
         } else {
             startTimer()
         }
     }
     
     func startTimer() {
         isTimerRunning = true
         startButton.setTitle("Пауза", for: .normal) // Меняем текст кнопки на "Пауза"
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
     }
     
     func pauseTimer() {
          isTimerRunning = false
          startButton.setTitle("Продолжить", for: .normal) // Меняем текст кнопки на "Продолжить"
          timer?.invalidate() // Останавливаем таймер
      }
     
     @objc func updateTimer() {
         if secondsRemaining > 0 {
             secondsRemaining -= 1
             updateTimerLabel()
         } else {
             pauseTimer() // Останавливаем таймер, когда время истекло
         }
     }
     
     func updateTimerLabel() {
         let minutes = secondsRemaining / 60
         let seconds = secondsRemaining % 60
         let timeString = String(format: "%02d:%02d", minutes, seconds)
         timerLabel.text = timeString
     }
     
     private func target() {
         startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)

     }


 } // end

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


/* вариант без стейта рабочий
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
     private let difficultyOptions = ["Soft", "Medium", "Hard"]
     private var currentIndex = 1
     
     private var timer: Timer?
     private var secondsRemaining = 8 * 60 // Устанавливаем начальное время в 8 минут (8 * 60 секунд)
     private var isTimerRunning = false // Переменная для отслеживания состояния таймера
     private let timerDurations = [300, 480, 660] // Время в секундах: Soft - 5 минут, Medium - 8 минут, Hard - 11 минут
     
     //    private let titleLabel: UILabel = {
     //        let label = UILabel()
     //        label.text = "What kind of egg do you want to boil?"
     //        label.font = UIFont.systemFont(ofSize: 22)
     //        label.textAlignment = .center
     //        label.textColor = .systemOrange
     //        return label
     //    }()
     private let timerLabel: UILabel = {
         let label = UILabel()
         label.text = ""
         label.font = UIFont.systemFont(ofSize: 30)
         label.textAlignment = .center
         return label
     }()
     private let startButton: UIButton = {
         let button = UIButton()
         button.setTitle("START", for: .normal)
         button.setTitleColor(.white, for: .normal)
         return button
     }()
     //MARK: Lifecycle
     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .darkGray
         setupUI()
     }
     // MARK: - UI Setup
     private func setupUI() {
         setupLabels()
         setupGestures()
         addTarget()
         updateTimerLabelForCurrentDifficulty()
     }
     //MARK: - Methods
     // create Label
     private func createLabel(text: String, tag: Int) -> UILabel {
         let label = UILabel()
         label.text = text
         label.font = UIFont.systemFont(ofSize: 24)
         label.textAlignment = .center
         label.tag = tag
         return label
     }
     // create Labels
     private func setupLabels() {
         for (index, labelText) in difficultyOptions.enumerated() {
             let label = createLabel(text: labelText, tag: index)
             setupConstraints(label, index: index)
             label.textColor = index == currentIndex ? .white : .gray
         }
     }
     //MARK: - Constraints
     private func setupConstraints(_ difficultyOptions: UILabel, index: Int) {
         // difficultyOptions
         view.addSubview(difficultyOptions)
         difficultyOptions.snp.makeConstraints { make in
             make.width.equalTo(view)
             make.height.equalTo(50)
             make.centerX.equalTo(view).offset(CGFloat(index - currentIndex) * (view.frame.width / 3))
             make.top.equalTo(view).offset(100)
         }
         // timerLabel
         view.addSubview(timerLabel)
         timerLabel.snp.makeConstraints { make in
             make.centerX.equalToSuperview()
             make.centerY.equalToSuperview()
             make.width.equalTo(view).multipliedBy(0.8)
         }
         // startButton
         view.addSubview(startButton)
         startButton.snp.makeConstraints { make in
             make.centerX.equalToSuperview()
             make.top.equalTo(timerLabel.snp.bottom).offset(20)
         }
     }
     //MARK: - Target
     private func addTarget() {
         startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
     }
     //MARK: - Gestures
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
     //MARK: - handleSwipe
     @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
         switch gesture.direction {
         case .left:
             currentIndex = (currentIndex + 1) % difficultyOptions.count
         case .right:
             currentIndex = (currentIndex - 1 + difficultyOptions.count) % difficultyOptions.count
         default:
             break
         }
         animateLabels()
         updateTimerLabelForCurrentDifficulty() // Обновляем timerLabel
     }
     //MARK: - handleTap
     @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
         let tapLocation = gesture.location(in: view)
         for (_, label) in view.subviews.enumerated() {
             if let label = label as? UILabel, label.frame.contains(tapLocation), label.tag != currentIndex {
                 currentIndex = label.tag
                 animateLabels()
                 // При выборе сложности также обновите продолжительность таймера
                 if isTimerRunning {
                     pauseTimer()
                     startTimer()
                 }
                 break
             }
         }
     }
     //MARK: - Animate
     private func animateLabels() {
         UIView.animate(withDuration: 0.3) {
             for (index, label) in self.view.subviews.enumerated() {
                 if let label = label as? UILabel {
                     label.snp.updateConstraints { make in
                         make.centerX.equalTo(self.view).offset(CGFloat(index - self.currentIndex) * (self.view.frame.width / 3))
                     }
                     if label == self.timerLabel {
                         label.textColor = .white // Сохраняем цвет timerLabel белым
                     } else {
                         label.textColor = index == self.currentIndex ? .white : .gray
                     }
                 }
             }
             self.view.layoutIfNeeded()
         }
     }
     //MARK: - Timer
     @objc private func startButtonTapped() {
         if isTimerRunning {
             pauseTimer()
         } else {
             startTimer()
         }
     }
     // start Timer
     private func startTimer() {
         isTimerRunning = true
         startButton.setTitle("Pause", for: .normal)
         secondsRemaining = timerDurations[currentIndex] // Используйте продолжительность для текущей сложности
         updateTimerLabel()
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
     }
     // pause Timer
     private func pauseTimer() {
         isTimerRunning = false
         startButton.setTitle("Continue", for: .normal) // Меняем текст кнопки на "Продолжить"
         timer?.invalidate() // Останавливаем таймер
     }
     // update Timer
     @objc private func updateTimer() {
         if secondsRemaining > 0 {
             secondsRemaining -= 1
             updateTimerLabel()
         } else {
             pauseTimer() // Останавливаем таймер, когда время истекло
         }
     }
     // update Timer Label
     private func updateTimerLabel() {
         let minutes = secondsRemaining / 60
         let seconds = secondsRemaining % 60
         let timeString = String(format: "%02d:%02d", minutes, seconds)
         timerLabel.text = timeString
     }
     // Обновить timerLabel для текущей сложности
     private func updateTimerLabelForCurrentDifficulty() {
         let minutes = timerDurations[currentIndex] / 60
         let seconds = timerDurations[currentIndex] % 60
         let timeString = String(format: "%02d:%02d", minutes, seconds)
         timerLabel.text = timeString
     }
 } // end

*/
