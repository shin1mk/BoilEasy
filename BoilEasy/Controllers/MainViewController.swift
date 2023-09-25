
//
//  MainViewController.swift
//  BoilEasy
//
//  Created by SHIN MIKHAIL on 18.09.2023.
//
// сделать другую кнопку

import UIKit
import SnapKit
import UserNotifications

final class MainViewController: UIViewController, UNUserNotificationCenterDelegate {
    private let difficultyLabels = ["Soft", "Medium", "Hard"]
    private let imagesForDifficulties: [String: UIImage] = [
        "Soft": UIImage(named: "soft.png")!,
        "Medium": UIImage(named: "medium.png")!,
        "Hard": UIImage(named: "hard.png")!
    ]
    private var shapeLayer: CAShapeLayer!
    private var currentProgress: Float = 1.0 //  полная окружность круга
    private var currentIndex = 1 // текущий label
    private var startDate: Date?
    private var timer: Timer?
    private var isTimerRunning = false // Переменная для отслеживания состояния таймера

    private var secondsRemaining = 8 * 60 // Устанавливаем начальное время
    // private let timerDurations = [360, 480, 660] // Soft - 6 минут, Medium - 8 минут, Hard - 11 минут
    private let timerDurations = [60, 5, 10] // Soft - 6 минут, Medium - 8 минут, Hard - 11 минут
    private let feedbackGenerator = UISelectionFeedbackGenerator()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "How to boil eggs easy?"
        label.font = UIFont.SFUITextHeavy(ofSize: 35)
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
        label.textColor = .white
        return label
    }()
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("START", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextHeavy(ofSize: 30)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "medium.png"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background.png") // Set the image here
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
        setupGestures()
        setupDifficultyLabels()
        updateImageView()
        updateTimerLabelForCurrentDifficulty()
        setupCircleLayer()
        notificationObserver()
    }
    // удаляем наблюдатель
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // setup circle Layer
    private func setupCircleLayer() {
        shapeLayer = CAShapeLayer()
        // фон
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = UIBezierPath(
            arcCenter: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2),
            radius: min(view.bounds.width, view.bounds.height) / 2 - 40, // Небольшой отступ
            startAngle: -.pi / 2,
            endAngle: 2 * .pi - .pi / 2,
            clockwise: true
        ).cgPath
        backgroundLayer.strokeColor = UIColor.systemGray.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 7
        backgroundLayer.lineCap = .round
        backgroundLayer.strokeEnd = 1
        view.layer.addSublayer(backgroundLayer)
        // белая линия наполнения
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2),
            radius: min(view.bounds.width, view.bounds.height) / 2 - 40,
            startAngle: -.pi / 2,
            endAngle: 2 * .pi - .pi / 2,
            clockwise: true
        )
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 7
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 1
        view.layer.addSublayer(shapeLayer)
    }
    //MARK: - Methods
    // create Label
    private func createDifficultyLabel(text: String, tag: Int) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.SFUITextBold(ofSize: 22)
        label.textAlignment = .center
        label.tag = tag
        return label
    }
    // create labels
    private func setupDifficultyLabels() {
        for (index, labelText) in difficultyLabels.enumerated() {
            let label = createDifficultyLabel(text: labelText, tag: index)
            setupConstraints(label, index: index)
            label.textColor = index == currentIndex ? .white : .systemGray
        }
    }
    // update image view
    private func updateImageView() {
        if let imageName = difficultyLabels[safe: currentIndex],
           let image = imagesForDifficulties[imageName] {
            imageView.image = image
        }
    }
    // Constraints
    private func setupConstraints(_ difficultyLabels: UILabel, index: Int) {
        // difficulty labels
        view.addSubview(difficultyLabels)
        difficultyLabels.layer.zPosition = 1
        difficultyLabels.snp.makeConstraints { make in
            make.centerX.equalTo(view).offset(CGFloat(index - currentIndex) * (view.frame.width / 3))
            make.top.equalTo(view).offset(180)
            make.width.equalTo(view)
            make.height.equalTo(50)
        }
        // background image view
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // title label
        view.addSubview(titleLabel)
        titleLabel.layer.zPosition = 1
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(75)
            make.centerX.equalTo(view)
            make.width.equalTo(300)
        }
        // image view
        view.addSubview(imageView)
        imageView.layer.zPosition = 1
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(512)
            make.height.equalTo(512)
        }
        // timer label
        view.addSubview(timerLabel)
        timerLabel.layer.zPosition = 1
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-150)
            make.width.equalTo(150)
        }
        // start button
        view.addSubview(startButton)
        startButton.layer.zPosition = 1
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timerLabel.snp.bottom).offset(25)
        }
    }
} // end
//MARK: - Array
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
//MARK: - Timer
extension MainViewController {
    //MARK: - Timer
    @objc private func startButtonTapped() {
        if isTimerRunning {
            stopTimer()
        } else {
            startTimer()
        }
        enableGestures(!isTimerRunning) // откл жесты
    }
    // start Timer
    private func startTimer() {
        isTimerRunning = true
        startButton.setTitle("CANCEL", for: .normal)
        secondsRemaining = timerDurations[currentIndex] // Используйте продолжительность для текущей сложности
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        startDate = Date() // Запоминаем текущую дату при старте таймера
        updateTimerLabel()
        animateCircle()
        scheduleNotification() // Создать уведомление при запуске таймера
    }
    // stop Timer
    private func stopTimer() {
        isTimerRunning = false
        startButton.setTitle("START", for: .normal)
        timer?.invalidate()
        // Сбросить значение таймера на начальное
        secondsRemaining = timerDurations[currentIndex]
        updateTimerLabel()
        enableGestures(!isTimerRunning)
        cancelNotification() // удаляем уведомление если таймер остановили вручную
    }
    // update Timer
    @objc private func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            updateTimerLabel()
        } else {
            stopTimer()
            setupCircleLayer()
            animateCircle()
            updateTimerLabelForCurrentDifficulty()
        }
    }
    // updateTimerLabel
    private func updateTimerLabel() {
        if let startDate = startDate {
            let currentTime = Date()
            let timeDifference = Int(currentTime.timeIntervalSince(startDate))
            secondsRemaining = max(timerDurations[currentIndex] - timeDifference, 0)
        }
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        timerLabel.text = timeString
        let totalDuration = Float(timerDurations[currentIndex])
        let remainingTime = Float(secondsRemaining)
        currentProgress = 1.0 - (remainingTime / totalDuration)
        animateProgress(1.0 - currentProgress)
    }
    // updateTimerLabelForCurrentDifficulty
    private func updateTimerLabelForCurrentDifficulty() {
        let minutes = timerDurations[currentIndex] / 60
        let seconds = timerDurations[currentIndex] % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        timerLabel.text = timeString
        updateImageView()
    }
}
//MARK: - Animation
extension MainViewController {
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
    // animateImage
    private func animateImage() {
        imageView.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 1.0
        }) { _ in
            self.updateImageView()
        }
    }
    // animatenCircle
    private func animateCircle() {
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0 // Начальное значение
        strokeAnimation.toValue = 1 // Конечное значение (заполненный круг)
        strokeAnimation.duration = 0.8 // Продолжительность анимации
        shapeLayer.add(strokeAnimation, forKey: "strokeAnimation")
        // change color
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.fromValue = UIColor.gray.cgColor // Начальный цвет
        colorAnimation.duration = 0.5 // Продолжительность анимации
        shapeLayer.add(colorAnimation, forKey: "colorAnimation")
        shapeLayer.strokeColor = UIColor.white.cgColor
    }
    // Устанавливает прогресс анимации окружности
    private func animateProgress(_ progress: Float) {
        shapeLayer.strokeEnd = CGFloat(progress)
    }
}
//MARK: - Gestures
extension MainViewController {
    //MARK: - Target
    private func addTarget() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    // enableGestures
    private func enableGestures(_ enabled: Bool) {
        view.gestureRecognizers?.forEach { gesture in
            gesture.isEnabled = enabled
        }
    }
    //MARK: - Gestures
    private func setupGestures() {
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
            currentIndex = (currentIndex - 1 + difficultyLabels.count) % difficultyLabels.count
        case .right:
            currentIndex = (currentIndex + 1) % difficultyLabels.count
        default:
            break
        }
        animateImage()
        animateLabels()
        updateTimerLabelForCurrentDifficulty()
        feedbackGenerator.selectionChanged() // Добавьте виброотклик
    }
}
//MARK: - Notifications
extension MainViewController {
    // notification Observer
    private func notificationObserver() {
        // Добавляем наблюдателя за событием didBecomeActive приложения, приложение становится активным.
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    // Обработчик события UIApplication.didBecomeActiveNotification
    @objc private func appDidBecomeActive() {
        if isTimerRunning {
            updateTimerLabel()
        }
    }
    // schedule notification
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "BoilEasy"
        content.body = "Таймер завершен"
        content.sound = UNNotificationSound.default
        // Вычисляем время выполнения уведомления на основе продолжительности таймера и текущего времени.
        let triggerDate = Date(timeIntervalSinceNow: TimeInterval(timerDurations[currentIndex]))
        let identifier = "TimerNotification"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerDate.timeIntervalSinceNow, repeats: false)
        // Создаем запрос на уведомление с указанными параметрами.
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Ошибка при создании уведомления: \(error)")
            } else {
                print("Уведомление успешно создано.")
            }
        }
    }
    // cancel notification
    private func cancelNotification() {
        let identifier = "TimerNotification"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Уведомление с идентификатором '\(identifier)' было отменено.")
    }
}
