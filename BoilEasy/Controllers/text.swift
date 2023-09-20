// описание
/*
Мягкие вареные яйца (Soft-Boiled Eggs):
Мягко-вареное яйцо с жидким желтком: 4-5 минут.
Мягко-вареное яйцо с полужидким желтком: 6-7 минут.
Средне-мягкие вареные яйца (Medium-Boiled Eggs):
Средне-мягкое яйцо с немного жидким центром: 8-9 минут.
Твердые вареные яйца (Hard-Boiled Eggs):
Твердое яйцо с полностью застывшим желтком: 10-12 минут.
*/

//вариант с рабочим таймером
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

//вариант без стейта рабочий
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
     private let imagesForDifficulties: [String: UIImage] = [
         "Soft": UIImage(named: "soft.png")!,
         "Medium": UIImage(named: "medium.png")!,
         "Hard": UIImage(named: "hard.png")!
     ]
     
     private var currentIndex = 1 // текущий label
     private var timer: Timer?
     private var secondsRemaining = 8 * 60 // Устанавливаем начальное время в 8 минут (8 * 60 секунд)
     private var isTimerRunning = false // Переменная для отслеживания состояния таймера
     private let timerDurations = [360, 480, 660] // Время в секундах: Soft - 6 минут, Medium - 8 минут, Hard - 11 минут
     
     private let titleLabel: UILabel = {
         let label = UILabel()
         label.text = "How to boil eggs easy?"
         label.font = UIFont.SFUITextHeavy(ofSize: 32)
         label.textAlignment = .center
         label.textColor = .white
         label.numberOfLines = 0
         return label
     }()
     private let timerLabel: UILabel = {
         let label = UILabel()
         label.text = ""
         label.font = UIFont.SFUITextBold(ofSize: 35)
         label.textAlignment = .center
         return label
     }()
     private let startButton: UIButton = {
         let button = UIButton()
         button.setTitle("Start", for: .normal)
         button.titleLabel?.font = UIFont.SFUITextHeavy(ofSize: 30)
         button.setTitleColor(.white, for: .normal)
         return button
     }()
     private let imageView: UIImageView = {
         let imageView = UIImageView(image: UIImage(named: "medium.png"))
         imageView.contentMode = .scaleAspectFill
         return imageView
     }()
     //MARK: Lifecycle
     override func viewDidLoad() {
         super.viewDidLoad()
         addTarget()
         setupGestures()
         setupDifficultyLabels()
         updateImageViewForCurrentDifficulty()
         updateTimerLabelForCurrentDifficulty()
         backgroundImage()
     }
     //MARK: - Methods
     private func backgroundImage() {
         let backgroundImage = UIImage(named: "background.png")
         let backgroundImageView = UIImageView(image: backgroundImage)
         backgroundImageView.contentMode = .scaleAspectFill // Вы можете выбрать нужный режим масштабирования
         backgroundImageView.frame = view.bounds // Установите размеры фоновой картинки равными размерам вашего представления
         backgroundImageView.layer.zPosition = 0
         view.addSubview(backgroundImageView)
     }
     // create Label
     private func createDifficultyLabel(text: String, tag: Int) -> UILabel {
         let label = UILabel()
         label.text = text
         label.font = UIFont.SFUITextBold(ofSize: 22)
         label.textAlignment = .center
         label.tag = tag
         return label
     }
     // create Labels
     private func setupDifficultyLabels() {
         for (index, labelText) in difficultyOptions.enumerated() {
             let label = createDifficultyLabel(text: labelText, tag: index)
             setupConstraints(label, index: index)
             label.textColor = index == currentIndex ? .white : .gray
         }
     }
     // update image view
     private func updateImageViewForCurrentDifficulty() {
         if let imageName = difficultyOptions[safe: currentIndex], let image = imagesForDifficulties[imageName] {
             imageView.image = image
         }
     }
     //MARK: - Constraints
     private func setupConstraints(_ difficultyOptions: UILabel, index: Int) {
         // difficultyOptions
         view.addSubview(difficultyOptions)
         difficultyOptions.layer.zPosition = 1
         difficultyOptions.snp.makeConstraints { make in
             make.width.equalTo(view)
             make.height.equalTo(50)
             make.centerX.equalTo(view).offset(CGFloat(index - currentIndex) * (view.frame.width / 3))
             make.top.equalTo(view).offset(150)
         }
         // title label
         view.addSubview(titleLabel)
         titleLabel.layer.zPosition = 1
         titleLabel.snp.makeConstraints { make in
             make.top.equalTo(view).offset(70)
             make.centerX.equalTo(view)
             make.width.equalTo(300)
         }
         // imageView
         view.addSubview(imageView)
         imageView.layer.zPosition = 1
         imageView.snp.makeConstraints { make in
             make.centerX.equalToSuperview()
             make.centerY.equalToSuperview()
             make.width.equalTo(512)
             make.height.equalTo(512)
         }
         // timerLabel
         view.addSubview(timerLabel)
         timerLabel.layer.zPosition = 1
         timerLabel.snp.makeConstraints { make in
             make.centerX.equalToSuperview()
             make.bottom.equalToSuperview().offset(-150) // Отрицательное значение для закрепления от низа
             make.width.equalTo(150)
         }
         // startButton
         view.addSubview(startButton)
         startButton.layer.zPosition = 1
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
         animateImage()
         animateLabels()
         updateTimerLabelForCurrentDifficulty() // Обновляем timerLabel
     }
     //MARK: - handleTap
     @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
         let tapLocation = gesture.location(in: view)
         
         for (_, subview) in view.subviews.enumerated() {
             guard let label = subview as? UILabel, label.frame.contains(tapLocation), label.tag != currentIndex else {
                 continue
             }
             currentIndex = label.tag
             animateImage()
             animateLabels()
             updateTimerLabelForCurrentDifficulty() // Обновляем timerLabel

             if isTimerRunning {
                 stopTimer()
                 startTimer()
             }
             break
         }
     }
     //MARK: - Animate
     private func animateLabels() {
         UIView.animate(withDuration: 0.7) {
             for (index, label) in self.view.subviews.enumerated() {
                 if let label = label as? UILabel {
                     if label == self.titleLabel {
                         continue
                     }
                     // Обновляем цвет текста
                     if label == self.timerLabel {
                         label.textColor = .white
                     } else {
                         label.textColor = index == self.currentIndex ? .white : .systemGray
                     }
                 }
             }
         }
     }

     private func animateImage() {
         // Устанавливаем начальный альфа-канал равным 0
          imageView.alpha = 0.0
          // Анимация изменения альфа-канала для imageView
          UIView.animate(withDuration: 0.5, animations: {
              // Устанавливаем конечный альфа-канал равным 1 внутри блока анимации
              self.imageView.alpha = 1.0
          }) { _ in
              // По завершении анимации, обновляем изображение
              self.updateImageViewForCurrentDifficulty()
          }
     }
     //MARK: - Timer
     @objc private func startButtonTapped() {
         if isTimerRunning {
             stopTimer()
         } else {
             startTimer()
         }
         // Включение/отключение жестов в зависимости от состояния таймера
         let gesturesEnabled = !isTimerRunning
         view.gestureRecognizers?.forEach { gesture in
             gesture.isEnabled = gesturesEnabled
         }
     }
     // start Timer
     private func startTimer() {
         isTimerRunning = true
         startButton.setTitle("Cancel", for: .normal)
         secondsRemaining = timerDurations[currentIndex] // Используйте продолжительность для текущей сложности
         updateTimerLabel()
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
     }
     // stop Timer
     private func stopTimer() {
         isTimerRunning = false
         startButton.setTitle("Start", for: .normal)
         timer?.invalidate()
         // Сбросить значение таймера на начальное
         secondsRemaining = timerDurations[currentIndex]
         updateTimerLabel()
     }
     // update Timer
     @objc private func updateTimer() {
         if secondsRemaining > 0 {
             secondsRemaining -= 1
             updateTimerLabel()
         } else {
             stopTimer() // Останавливаем таймер, когда время истекло
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
         
         updateImageViewForCurrentDifficulty()
     }
 } // end

 extension Array {
     subscript(safe index: Int) -> Element? {
         return indices.contains(index) ? self[index] : nil
     }
 }

*/

//state work + словарь
/* state work + словарь
 //
 //  MainViewController.swift
 //  BoilEasy
 //
 //  Created by SHIN MIKHAIL on 18.09.2023.
 //
 import UIKit
 import SnapKit

 enum CookingState {
     case soft
     case medium
     case hard

     var durationInSeconds: Int {
         switch self {
         case .soft:
             return 6 * 60 // 6 минут в секундах
         case .medium:
             return 8 * 60 // 8 минут в секундах
         case .hard:
             return 11 * 60 // 11 минут в секундах
         }
     }

     var imageName: String {
         switch self {
         case .soft:
             return "soft.png"
         case .medium:
             return "medium.png"
         case .hard:
             return "hard.png"
         }
     }
 }


 final class MainViewController: UIViewController {
     //MARK: Properties
     private let difficultyOptions = ["Soft", "Medium", "Hard"]
     private let imagesForDifficulties: [String: UIImage] = [
         "Soft": UIImage(named: "soft.png")!,
         "Medium": UIImage(named: "medium.png")!,
         "Hard": UIImage(named: "hard.png")!
     ]
     
     private var currentIndex = 1 // текущий label
     private var timer: Timer?
     private var secondsRemaining = 8 * 60 // Устанавливаем начальное время в 8 минут (8 * 60 секунд)
     private var isTimerRunning = false // Переменная для отслеживания состояния таймера
     private let timerDurations = [360, 480, 660] // Время в секундах: Soft - 6 минут, Medium - 8 минут, Hard - 11 минут
     
     private let titleLabel: UILabel = {
         let label = UILabel()
         label.text = "How to boil eggs easy?"
         label.font = UIFont.SFUITextHeavy(ofSize: 32)
         label.textAlignment = .center
         label.textColor = .white
         label.numberOfLines = 0
         return label
     }()
     private let timerLabel: UILabel = {
         let label = UILabel()
         label.text = ""
         label.font = UIFont.SFUITextBold(ofSize: 35)
         label.textAlignment = .center
         return label
     }()
     private let startButton: UIButton = {
         let button = UIButton()
         button.setTitle("Start", for: .normal)
         button.titleLabel?.font = UIFont.SFUITextHeavy(ofSize: 30)
         button.setTitleColor(.white, for: .normal)
         return button
     }()
     private let imageView: UIImageView = {
         let imageView = UIImageView(image: UIImage(named: "medium.png"))
         imageView.contentMode = .scaleAspectFill
         return imageView
     }()
     //MARK: Lifecycle
     override func viewDidLoad() {
         super.viewDidLoad()
         addTarget()
         setupGestures()
         setupDifficultyLabels()
         updateImageViewForCurrentDifficulty()
         updateTimerLabelForCurrentDifficulty()
         backgroundImage()
     }
     func getCurrentCookingState() -> CookingState {
         switch currentIndex {
         case 0:
             return .soft
         case 1:
             return .medium
         case 2:
             return .hard
         default:
             return .medium // По умолчанию выбираем среднюю сложность
         }
     }
     //MARK: - Methods
     private func backgroundImage() {
         let backgroundImage = UIImage(named: "background.png")
         let backgroundImageView = UIImageView(image: backgroundImage)
         backgroundImageView.contentMode = .scaleAspectFill // Вы можете выбрать нужный режим масштабирования
         backgroundImageView.frame = view.bounds // Установите размеры фоновой картинки равными размерам вашего представления
         backgroundImageView.layer.zPosition = 0
         view.addSubview(backgroundImageView)
     }
     // create Label
     private func createDifficultyLabel(text: String, tag: Int) -> UILabel {
         let label = UILabel()
         label.text = text
         label.font = UIFont.SFUITextBold(ofSize: 22)
         label.textAlignment = .center
         label.tag = tag
         return label
     }
     // create Labels
     private func setupDifficultyLabels() {
         for (index, labelText) in difficultyOptions.enumerated() {
             let label = createDifficultyLabel(text: labelText, tag: index)
             setupConstraints(label, index: index)
             label.textColor = index == currentIndex ? .white : .gray
         }
     }
     // update image view
     private func updateImageViewForCurrentDifficulty() {
         if let imageName = difficultyOptions[safe: currentIndex], let image = imagesForDifficulties[imageName] {
             imageView.image = image
         }
     }
     //MARK: - Constraints
     private func setupConstraints(_ difficultyOptions: UILabel, index: Int) {
         // difficultyOptions
         view.addSubview(difficultyOptions)
         difficultyOptions.layer.zPosition = 1
         difficultyOptions.snp.makeConstraints { make in
             make.width.equalTo(view)
             make.height.equalTo(50)
             make.centerX.equalTo(view).offset(CGFloat(index - currentIndex) * (view.frame.width / 3))
             make.top.equalTo(view).offset(150)
         }
         // title label
         view.addSubview(titleLabel)
         titleLabel.layer.zPosition = 1
         titleLabel.snp.makeConstraints { make in
             make.top.equalTo(view).offset(70)
             make.centerX.equalTo(view)
             make.width.equalTo(300)
         }
         // imageView
         view.addSubview(imageView)
         imageView.layer.zPosition = 1
         imageView.snp.makeConstraints { make in
             make.centerX.equalToSuperview()
             make.centerY.equalToSuperview()
             make.width.equalTo(512)
             make.height.equalTo(512)
         }
         // timerLabel
         view.addSubview(timerLabel)
         timerLabel.layer.zPosition = 1
         timerLabel.snp.makeConstraints { make in
             make.centerX.equalToSuperview()
             make.bottom.equalToSuperview().offset(-150) // Отрицательное значение для закрепления от низа
             make.width.equalTo(150)
         }
         // startButton
         view.addSubview(startButton)
         startButton.layer.zPosition = 1
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
     // Обработчик свайпов
     @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
         switch gesture.direction {
         case .left:
             currentIndex = (currentIndex - 1 + difficultyOptions.count) % difficultyOptions.count
         case .right:
             currentIndex = (currentIndex + 1) % difficultyOptions.count
         default:
             break
         }
         
         let currentCookingState = getCurrentCookingState()
         
         // Выводим информацию в консоль
         print("Swiped to \(currentCookingState) state")
         
         // Далее вы можете использовать currentCookingState для обновления интерфейса или выполнения других операций
         updateImageViewForCurrentDifficulty()
         updateTimerLabelForCurrentDifficulty()
         //        animateImage()
                 animateLabels()
         //        updateTimerLabelForCurrentDifficulty() // Обновляем timerLabel
     }
     //MARK: - handleTap
     @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
         let tapLocation = gesture.location(in: view)
         
         for (_, subview) in view.subviews.enumerated() {
             guard let label = subview as? UILabel, label.frame.contains(tapLocation), label.tag != currentIndex else {
                 continue
             }
             currentIndex = label.tag
             animateImage()
             animateLabels()
             updateTimerLabelForCurrentDifficulty() // Обновляем timerLabel

             if isTimerRunning {
                 stopTimer()
                 startTimer()
             }
             break
         }
     }
     //MARK: - Animate
     private func animateLabels() {
         UIView.animate(withDuration: 0.7) {
             for (index, label) in self.view.subviews.enumerated() {
                 if let label = label as? UILabel {
                     if label == self.titleLabel {
                         continue
                     }
                     // Обновляем цвет текста
                     if label == self.timerLabel {
                         label.textColor = .white
                     } else {
                         label.textColor = index == self.currentIndex ? .white : .systemGray
                     }
                 }
             }
         }
     }

     private func animateImage() {
         // Устанавливаем начальный альфа-канал равным 0
          imageView.alpha = 0.0
          // Анимация изменения альфа-канала для imageView
          UIView.animate(withDuration: 0.5, animations: {
              // Устанавливаем конечный альфа-канал равным 1 внутри блока анимации
              self.imageView.alpha = 1.0
          }) { _ in
              // По завершении анимации, обновляем изображение
              self.updateImageViewForCurrentDifficulty()
          }
     }
     //MARK: - Timer
     @objc private func startButtonTapped() {
         if isTimerRunning {
             stopTimer()
         } else {
             startTimer()
         }
         // Включение/отключение жестов в зависимости от состояния таймера
         let gesturesEnabled = !isTimerRunning
         view.gestureRecognizers?.forEach { gesture in
             gesture.isEnabled = gesturesEnabled
         }
     }
     // start Timer
     private func startTimer() {
         isTimerRunning = true
         startButton.setTitle("Cancel", for: .normal)
         secondsRemaining = timerDurations[currentIndex] // Используйте продолжительность для текущей сложности
         updateTimerLabel()
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
     }
     // stop Timer
     private func stopTimer() {
         isTimerRunning = false
         startButton.setTitle("Start", for: .normal)
         timer?.invalidate()
         // Сбросить значение таймера на начальное
         secondsRemaining = timerDurations[currentIndex]
         updateTimerLabel()
     }
     // update Timer
     @objc private func updateTimer() {
         if secondsRemaining > 0 {
             secondsRemaining -= 1
             updateTimerLabel()
         } else {
             stopTimer() // Останавливаем таймер, когда время истекло
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
         
         updateImageViewForCurrentDifficulty()
     }
 } // end

 extension Array {
     subscript(safe index: Int) -> Element? {
         return indices.contains(index) ? self[index] : nil
     }
 }
*/

//вариант стейт рабочий
/*
 //
 //  MainViewController.swift
 //  BoilEasy
 //
 //  Created by SHIN MIKHAIL on 18.09.2023.
 //
 import UIKit
 import SnapKit

 enum CookingState {
     case soft
     case medium
     case hard
     
     var durationInSeconds: Int {
         switch self {
         case .soft:
             return 6 * 60 // 6 минут в секундах
         case .medium:
             return 8 * 60 // 8 минут в секундах
         case .hard:
             return 11 * 60 // 11 минут в секундах
         }
     }
     
     var imageName: String {
         switch self {
         case .soft:
             return "soft.png"
         case .medium:
             return "medium.png"
         case .hard:
             return "hard.png"
         }
     }
 }

 final class MainViewController: UIViewController {
     private let difficultyOptions = ["Soft", "Medium", "Hard"]
     private var currentIndex = 1 // текущий label
     private var timer: Timer?
     private var isTimerRunning = false // Переменная для отслеживания состояния таймера
     
     private let titleLabel: UILabel = {
         let label = UILabel()
         label.text = "How to boil eggs easy?"
         label.font = UIFont.SFUITextHeavy(ofSize: 32)
         label.textAlignment = .center
         label.textColor = .white
         label.numberOfLines = 0
         return label
     }()
     private let timerLabel: UILabel = {
         let label = UILabel()
         label.text = ""
         label.font = UIFont.SFUITextBold(ofSize: 35)
         label.textAlignment = .center
         return label
     }()
     private let startButton: UIButton = {
         let button = UIButton()
         button.setTitle("Start", for: .normal)
         button.titleLabel?.font = UIFont.SFUITextHeavy(ofSize: 30)
         button.setTitleColor(.white, for: .normal)
         return button
     }()
     private let imageView: UIImageView = {
         let imageView = UIImageView(image: UIImage(named: "medium.png"))
         imageView.contentMode = .scaleAspectFill
         return imageView
     }()
     //MARK: Lifecycle
     override func viewDidLoad() {
         super.viewDidLoad()
         addTarget()
         setupGestures()
         setupDifficultyLabels()
         updateImageViewForCurrentDifficulty()
         updateTimerLabelForCurrentDifficulty()
         backgroundImage()
     }
     //MARK: - Methods
     private func backgroundImage() {
         let backgroundImage = UIImage(named: "background.png")
         let backgroundImageView = UIImageView(image: backgroundImage)
         backgroundImageView.contentMode = .scaleAspectFill // Вы можете выбрать нужный режим масштабирования
         backgroundImageView.frame = view.bounds // Установите размеры фоновой картинки равными размерам вашего представления
         backgroundImageView.layer.zPosition = 0
         view.addSubview(backgroundImageView)
     }
     // create Label
     private func createDifficultyLabel(text: String, tag: Int) -> UILabel {
         let label = UILabel()
         label.text = text
         label.font = UIFont.SFUITextBold(ofSize: 22)
         label.textAlignment = .center
         label.tag = tag
         return label
     }
     
     private func setupDifficultyLabels() {
         for (index, labelText) in difficultyOptions.enumerated() {
             let label = createDifficultyLabel(text: labelText, tag: index)
             setupConstraints(label, index: index)
             label.textColor = index == currentIndex ? .white : .gray
         }
     }
     // update image view
     private func updateImageViewForCurrentDifficulty() {
         let currentCookingState = getCurrentCookingState()
         imageView.image = UIImage(named: currentCookingState.imageName)
     }
     //MARK: - Constraints
     private func setupConstraints(_ difficultyOptions: UILabel, index: Int) {
         // difficultyOptions
         view.addSubview(difficultyOptions)
         difficultyOptions.layer.zPosition = 1
         difficultyOptions.snp.makeConstraints { make in
             make.width.equalTo(view)
             make.height.equalTo(50)
             make.centerX.equalTo(view).offset(CGFloat(index - currentIndex) * (view.frame.width / 3))
             make.top.equalTo(view).offset(150)
         }
         // title label
         view.addSubview(titleLabel)
         titleLabel.layer.zPosition = 1
         titleLabel.snp.makeConstraints { make in
             make.top.equalTo(view).offset(70)
             make.centerX.equalTo(view)
             make.width.equalTo(300)
         }
         // imageView
         view.addSubview(imageView)
         imageView.layer.zPosition = 1
         imageView.snp.makeConstraints { make in
             make.centerX.equalToSuperview()
             make.centerY.equalToSuperview()
             make.width.equalTo(512)
             make.height.equalTo(512)
         }
         // timerLabel
         view.addSubview(timerLabel)
         timerLabel.layer.zPosition = 1
         timerLabel.snp.makeConstraints { make in
             make.centerX.equalToSuperview()
             make.bottom.equalToSuperview().offset(-150) // Отрицательное значение для закрепления от низа
             make.width.equalTo(150)
         }
         // startButton
         view.addSubview(startButton)
         startButton.layer.zPosition = 1
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
             currentIndex = (currentIndex - 1 + difficultyOptions.count) % difficultyOptions.count
         case .right:
             currentIndex = (currentIndex + 1) % difficultyOptions.count
         default:
             break
         }

         if currentIndex < 0 {
             currentIndex = difficultyOptions.count - 1
         }

         let currentCookingState = getCurrentCookingState()
         // Выводим информацию в консоль
         print("Swiped to \(currentCookingState) state")
         // Далее вы можете использовать currentCookingState для обновления интерфейса или выполнения других операций
         updateImageViewForCurrentDifficulty()
         updateTimerLabelForCurrentDifficulty()
         animateLabels()
     }

     //MARK: - handleTap
     @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
         let tapLocation = gesture.location(in: view)
         
         for (_, subview) in view.subviews.enumerated() {
             guard let label = subview as? UILabel, label.frame.contains(tapLocation), label.tag != currentIndex else {
                 continue
             }
             currentIndex = label.tag
             animateImage()
             animateLabels()
             updateTimerLabelForCurrentDifficulty() // Обновляем timerLabel
             
             if isTimerRunning {
                 stopTimer()
                 startTimer()
             }
             break
         }
     }
     //MARK: - Animate
     private func animateLabels() {
         UIView.animate(withDuration: 0.7) {
             for (index, label) in self.view.subviews.enumerated() {
                 if let label = label as? UILabel {
                     if label == self.titleLabel {
                         continue
                     }
                     // Обновляем цвет текста
                     if label == self.timerLabel {
                         label.textColor = .white
                     } else {
                         label.textColor = index == self.currentIndex ? .white : .systemGray
                     }
                 }
             }
         }
     }
     
     private func animateImage() {
         // Устанавливаем начальный альфа-канал равным 0
         imageView.alpha = 0.0
         // Анимация изменения альфа-канала для imageView
         UIView.animate(withDuration: 0.5, animations: {
             // Устанавливаем конечный альфа-канал равным 1 внутри блока анимации
             self.imageView.alpha = 1.0
         }) { _ in
             // По завершении анимации, обновляем изображение
             self.updateImageViewForCurrentDifficulty()
         }
     }
     //MARK: - Timer
     @objc private func startButtonTapped() {
         if isTimerRunning {
             stopTimer()
         } else {
             startTimer()
         }
         // Включение/отключение жестов в зависимости от состояния таймера
         let gesturesEnabled = !isTimerRunning
         view.gestureRecognizers?.forEach { gesture in
             gesture.isEnabled = gesturesEnabled
         }
     }
     // start Timer
     private func startTimer() {
         isTimerRunning = true
         startButton.setTitle("Cancel", for: .normal)
         
         let currentCookingState = getCurrentCookingState()
         let timerDuration = currentCookingState.durationInSeconds
         updateTimerLabel(with: timerDuration)
         
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
     }
     // stop Timer
     private func stopTimer() {
         isTimerRunning = false
         startButton.setTitle("Start", for: .normal)
         timer?.invalidate()
         let currentCookingState = getCurrentCookingState()
         updateTimerLabel(with: currentCookingState.durationInSeconds)
     }
     // update Timer
     @objc private func updateTimer() {
         let currentCookingState = getCurrentCookingState()
         var remainingTime = currentCookingState.durationInSeconds
         
         if remainingTime > 0 {
             remainingTime -= 1
             updateTimerLabel(with: remainingTime)
         } else {
             stopTimer() // Останавливаем таймер, когда время истекло
         }
     }
     // update Timer Label
     private func updateTimerLabel(with durationInSeconds: Int) {
         let minutes = durationInSeconds / 60
         let seconds = durationInSeconds % 60
         let timeString = String(format: "%02d:%02d", minutes, seconds)
         timerLabel.text = timeString
     }
     // Обновить timerLabel для текущей сложности
     private func updateTimerLabelForCurrentDifficulty() {
         let currentCookingState = getCurrentCookingState()
         let timerDuration = currentCookingState.durationInSeconds
         
         updateTimerLabel(with: timerDuration)
         updateImageViewForCurrentDifficulty()
     }

     func getCurrentCookingState() -> CookingState {
         switch currentIndex {
         case 0:
             return .soft
         case 1:
             return .medium
         case 2:
             return .hard
         default:
             return .medium // По умолчанию выбираем среднюю сложность
         }
     }
 } // end

*/

//timerCircle
/*
 timerCircle
 import UIKit

 class MainViewController: UIViewController {

     let timerLabel = UILabel()
     let timerCircle = CAShapeLayer()

     var timer: Timer?
     var totalTime = 60 // Время в секундах

     override func viewDidLoad() {
         super.viewDidLoad()

         // Создаем и настраиваем круглую анимацию
         let circlePath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: -(.pi / 2), endAngle: .pi * 2 - (.pi / 2), clockwise: true)
         timerCircle.path = circlePath.cgPath
         timerCircle.strokeColor = UIColor.blue.cgColor
         timerCircle.fillColor = UIColor.clear.cgColor
         timerCircle.lineWidth = 10.0
         timerCircle.strokeEnd = 0.0
         view.layer.addSublayer(timerCircle)

         // Создаем и настраиваем метку для отображения времени
         timerLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
         timerLabel.center = view.center
         timerLabel.textAlignment = .center
         timerLabel.font = UIFont.systemFont(ofSize: 36)
         view.addSubview(timerLabel)

         // Начинаем анимацию
         startTimer()
     }

     func startTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
     }

     @objc func updateTimer() {
         if totalTime > 0 {
             totalTime -= 1
             let percentage = CGFloat(totalTime) / 60.0 // 60 секунд в минуте
             timerCircle.strokeEnd = percentage
             timerLabel.text = "\(totalTime)"
         } else {
             timer?.invalidate()
             timer = nil
             // Таймер завершен, выполните здесь нужные действия
         }
     }
 }
*/
