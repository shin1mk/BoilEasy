//
//  CustomTimerController.swift
//  BoilEasy
//
//  Created by SHIN MIKHAIL on 29.10.2023.
//

import UIKit
import SnapKit
import UserNotifications

final class CustomTimerController: UIViewController {
    private let pickerView = UIPickerView()
    private var shapeLayer: CAShapeLayer!
    private var backgroundLayer: CAShapeLayer!
    private let feedbackGenerator = UISelectionFeedbackGenerator()

    private let hours = Array(0...23)
    private let minutes = Array(0...59)
    private let seconds = Array(0...59)
    
    private var selectedHours = 0
    private var selectedMinutes = 0
    private var selectedSeconds = 0
    
    private var currentProgress: Float = 1.0 //  полная окружность круга
    private var startDate: Date?

    private var timer: Timer?
    private var remainingTime: Int = 0
    private var selectedTime: Int = 0
    private var secondsRemaining: Int = 0

    private var isTimerRunning = false // состояниe таймера
    // переменная для хранения времени, оставшегося до паузы
    private var pausedTime: Int?
    private var isTimerPaused: Bool = false
    //MARK: Properties
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background6.png")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create custom timer"
        label.font = UIFont.SFUITextHeavy(ofSize: 35)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "--:--:--"
        label.font = UIFont.SFUITextBold(ofSize: 35)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    private let startButton: UIButton = {
        let startButton = UIButton()
        startButton.setTitle("START", for: .normal)
        startButton.titleLabel?.font = UIFont.SFUITextHeavy(ofSize: 30)
        return startButton
    }()
    private let pauseButton: UIButton = {
        let button = UIButton()
        button.setTitle("PAUSE", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextHeavy(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("STOP", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextHeavy(ofSize: 30)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerUI()
        setupConstraints()
        setupTarget()
        notificationObserver()
    }
    // удаляем наблюдатель
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // clock
    private func setupPickerUI() {
        pickerView.delegate = self
        pickerView.dataSource = self
        selectedHours = hours[0]
        selectedMinutes = minutes[0]
        selectedSeconds = seconds[0]
    }
    // Constraints
    private func setupConstraints() {
        view.backgroundColor = .systemOrange
        timerLabel.isHidden = true
        // background image view
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // title label
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(30)
            make.centerX.equalTo(view)
            make.width.equalTo(300)
        }
        // Добавьте пикер в представление
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        // timer label
        view.addSubview(timerLabel)
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(250)
        }
        // pause button
        view.addSubview(pauseButton)
        pauseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
        // start button
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pauseButton.snp.top).offset(-5)
            make.width.equalTo(140)
        }
    }
    // circle
    private func setupCircleLayer() {
        shapeLayer = CAShapeLayer()
        backgroundLayer = CAShapeLayer()
        // фон
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
    // target
    private func setupTarget() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
    }
} // end
//MARK: PickerView
extension CustomTimerController: UIPickerViewDelegate, UIPickerViewDataSource{
    // numberOfComponents
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3 // Минуты и секунды
    }
    // numberOfRowsInComponent
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return minutes.count
        case 2:
            return seconds.count
        default:
            return 0
        }
    }
    // titleForRow
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(hours[row]) hours"
        case 1:
            return "\(minutes[row]) min"
        case 2:
            return "\(seconds[row]) sec"
        default:
            return nil
        }
    }
    // didSelectRow
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedHours = hours[row]
        case 1:
            selectedMinutes = minutes[row]
        case 2:
            selectedSeconds = seconds[row]
        default:
            break
        }
    }
}
//MARK: Timer
extension CustomTimerController {
    // start button tapped
    @objc private func startButtonTapped() {
        guard selectedHours != 0 || selectedMinutes != 0 || selectedSeconds != 0 else {
            return
        }
        if isTimerRunning {
            stopButtonTapped()
        } else {
            if !isTimerPaused {
                startTimer()
            } else {
                stopButtonTapped()
            }
        }
        feedbackGenerator.selectionChanged() // виброотклик
    }
    // start timer func
    @objc private func startTimer() {
        isTimerRunning = true
        timerLabel.isHidden = false // Отображать таймер
        isModalInPresentation = true
        // Рассчитываем выбранное время в секундах
        selectedTime = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
        remainingTime = selectedTime
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        startButton.setTitle("STOP", for: .normal)
        startDate = Date() // Запоминаем дату и время старта таймера
        
        updateTimerLabel()
        setupCircleLayer()
        animateCircle()
        hidePickerViewAnimation()
        scheduleNotification() // Создать уведомление при запуске таймера
        
        print(startDate!)
        print("Starting timer with \(selectedTime) seconds")
    }

    // stop Timer and reset
    @objc private func stopButtonTapped() {
        isTimerRunning = false
        isTimerPaused = false // Сбрасываем состояние паузы
        timerLabel.isHidden = true // Отображать таймер
        isModalInPresentation = false
        pickerView.alpha = 1
        timer?.invalidate() // Остановка таймера
        
        startButton.setTitle("START", for: .normal)

        hideCircleLayer()
        // если завершился таймер самостоятельно
        if remainingTime <= 0 {
            feedbackGenerator.selectionChanged() // виброотклик
        } else {
            cancelNotification() // Удалить уведомление, если таймер остановлен вручную
        }
    }
//    // pause button tapped
//    @objc private func pauseButtonTapped() {
//        if isTimerRunning && !isTimerPaused {
//            // Если таймер запущен и не находится в состоянии паузы, тогда ставим паузу
//            isTimerRunning = false
//            isTimerPaused = true
//
//            pausedTime = remainingTime // Сохраняем текущее оставшееся время
//            pauseButton.setTitle("RESUME", for: .normal)
//            timer?.invalidate() // Останавливаем таймер
//
//            cancelNotification() // Отменить уведомление
//        } else if isTimerPaused {
//            // Если таймер находится в состоянии паузы, то продолжить
//            isTimerRunning = true
//            isTimerPaused = false
//            pauseButton.setTitle("PAUSE", for: .normal) // Изменяем текст кнопки на "Пауза"
//
//            startTimer(withRemainingTime: pausedTime) // Восстанавливаем таймер с сохраненным временем
//            // Рассчитываем разницу между текущим временем и временем паузы, чтобы обновить startDate
////            if let pausedTime = pausedTime {
////                let currentTime = Date()
////                let timeDifference = pausedTime - remainingTime
////                startDate = currentTime.addingTimeInterval(-TimeInterval(timeDifference))
////            }
//
//            scheduleNotificationWithRemainingTime(remainingTime: pausedTime!) // Уведомление с оставшимся временем
//
//            print("Таймер приостановлен на \(remainingTime) секунд") // Принт паузы
//            print("Таймер возобновлен с \(remainingTime) оставшимися секундами") // Принт возобновления
//        }
//        feedbackGenerator.selectionChanged() // Виброотклик
//    }
    @objc private func pauseButtonTapped() {
        if isTimerRunning && !isTimerPaused {
            isTimerRunning = false
            isTimerPaused = true
            pausedTime = remainingTime // Сохраняем текущее оставшееся время
            pauseButton.setTitle("RESUME", for: .normal)
            timer?.invalidate() // Останавливаем таймер
            cancelNotification() // Отменить уведомление
        } else if isTimerPaused {
            // Если таймер находится в состоянии паузы, то продолжить
            isTimerRunning = true
            isTimerPaused = false
            pauseButton.setTitle("PAUSE", for: .normal) // Изменяем текст кнопки на "Пауза"
            startTimer(withRemainingTime: pausedTime) // Восстанавливаем таймер с сохраненным временем
            // Рассчитываем разницу между текущим временем и временем паузы, чтобы обновить startDate
            scheduleNotificationWithRemainingTime(remainingTime: pausedTime!) // Уведомление с оставшимся временем
            print("Таймер приостановлен на \(remainingTime) секунд") // Принт паузы
            print("Таймер возобновлен с \(remainingTime) оставшимися секундами") // Принт возобновления
        }
        feedbackGenerator.selectionChanged() // Виброотклик
    }
    // start timer with remaining time
    private func startTimer(withRemainingTime remainingTime: Int?) {
        if let pausedTime = pausedTime {
            self.remainingTime = pausedTime
            startDate = Date().addingTimeInterval(-Double(selectedTime - pausedTime))
            // Продолжите таймер
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    // update timer label
    private func updateTimerLabel() {
        var updatedSecondsRemaining = 0
        
        if let startDate = startDate {
            let currentTime = Date()
            let timeDifference = Int(currentTime.timeIntervalSince(startDate))
            
            if isTimerRunning {
                updatedSecondsRemaining = max(selectedTime - timeDifference, 0)
            } else {
                updatedSecondsRemaining = max(remainingTime - timeDifference, 0)
            }
            
            print("Time Difference: \(timeDifference)")
            print("Seconds Remaining: \(updatedSecondsRemaining)")
        }
        
        let hours = updatedSecondsRemaining / 3600
        let minutes = (updatedSecondsRemaining % 3600) / 60
        let seconds = updatedSecondsRemaining % 60
        let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        DispatchQueue.main.async {
            self.timerLabel.text = formattedTime
            let progress = Float(updatedSecondsRemaining) / Float(self.selectedTime)
            // Update the circle animation
            self.animateProgress(progress)
            // Check if the timer has completed
            if updatedSecondsRemaining == 0 {
                self.stopButtonTapped()
            }
        }
    }
    // update timer
    @objc private func updateTimer() {
        // Уменьшаем время на 1 секунду
        remainingTime -= 1
        secondsRemaining = max(remainingTime, 0)
        // Если время вышло, останавливаем таймер
        if remainingTime <= 0 {
            stopButtonTapped()
        }
        // Рассчитываем прогресс таймера
        let progress = Float(remainingTime) / Float(selectedTime)
        animateProgress(progress)
        
        updateTimerLabel()
    }
}
//MARK: Animations
extension CustomTimerController {
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
    // прогресс анимации окружности
    private func animateProgress(_ progress: Float) {
        shapeLayer.strokeEnd = CGFloat(progress)
    }
    // анимация скрытия пикер вью
    private func hidePickerViewAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.pickerView.alpha = 0
        }
    }
    // скрыть кольцо
    private func hideCircleLayer() {
        // Анимация скрытия обоих shapeLayer
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3) // Длительность анимации
        CATransaction.setCompletionBlock {
            self.shapeLayer.removeFromSuperlayer() // Убираем shapeLayer из слоя view
        }
        shapeLayer.opacity = 0
        CATransaction.commit()
        // Анимация скрытия backgroundLayer
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3) // Длительность анимации
        CATransaction.setCompletionBlock {
            self.backgroundLayer.removeFromSuperlayer() // Убираем backgroundLayer из слоя view
        }
        backgroundLayer.opacity = 0
        CATransaction.commit()
    }
}
//MARK: - Notifications
extension CustomTimerController {
    // notification Observer
    private func notificationObserver() {
        // Добавляем наблюдателя за событием didBecomeActive приложения, приложение становится активным.
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    // Обработчик события UIApplication.didBecomeActiveNotification
    @objc private func appDidBecomeActive() {
        if isTimerRunning {
            // Проверяем, что есть `startDate`
            if var startDate = self.startDate {
                let currentTime = Date()
                let timeDifference = Int(currentTime.timeIntervalSince(startDate))
                // Обновляем `remainingTime` на основе времени, прошедшего с момента восстановления
                remainingTime = max(selectedTime - timeDifference, 0)
                // Обновляем `startDate` на текущее время, чтобы продолжить отсчет с правильного момента
                startDate = currentTime

                print("App became active. Time Difference: \(timeDifference)")
                print("Remaining Time after app activation: \(remainingTime)")

            }
            updateTimerLabel()
        }
    }
    // запланированное уведомление
    private func scheduleNotification() {
        // Создание категории уведомления
        let stopAction = UNNotificationAction(identifier: "StopAction", title: "Остановить", options: [])
        let timerCategory = UNNotificationCategory(identifier: "TimerCategory", actions: [stopAction], intentIdentifiers: [], options: [])
        // Зарегистрируйте категории уведомления
        UNUserNotificationCenter.current().setNotificationCategories([timerCategory])
        // Создание контента уведомления
        let content = UNMutableNotificationContent()
        content.title = "BoilEasy"
        content.body = "Timer"
        content.categoryIdentifier = "TimerCategory" // Использование созданной категории
        // Устанавливаем звук таймера из файла "timer_sound.mp3"
        if Bundle.main.url(forResource: "timer_sound", withExtension: "mp3") != nil {
            let soundAttachment = UNNotificationSound(named: UNNotificationSoundName(rawValue: "timer_sound.mp3"))
            content.sound = soundAttachment
        } else {
            print("Файл звука не найден.")
        }
        // Запланируйте и отобразите уведомление
        let triggerDate = Date(timeIntervalSinceNow: TimeInterval(selectedTime))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerDate.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: "TimerNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Ошибка при создании уведомления: \(error)")
            } else {
                print("Кастомное уведомление успешно создано.")
            }
        }
    }
    // cancel notification
    private func cancelNotification() {
        let identifier = "TimerNotification"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Кастомное уведомление с идентификатором '\(identifier)' было отменено.")
    }
    // scheduleNotificationWithRemainingTime
    private func scheduleNotificationWithRemainingTime(remainingTime: Int) {
        print("Кастомное запланировано уведомление с оставшимся временем: \(remainingTime) секунд")
        
        let content = UNMutableNotificationContent()
        content.title = "BoilEasy"
        content.body = "Timer"
        content.categoryIdentifier = "TimerCategory"
        
        if Bundle.main.url(forResource: "timer_sound", withExtension: "mp3") != nil {
            let soundAttachment = UNNotificationSound(named: UNNotificationSoundName(rawValue: "timer_sound.mp3"))
            content.sound = soundAttachment
        } else {
            print("Файл звука не найден.")
        }
        
        let triggerDate = Date(timeIntervalSinceNow: TimeInterval(remainingTime))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerDate.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: "TimerNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Ошибка при создании уведомления: \(error)")
            } else {
                print("Уведомление успешно создано.")
            }
        }
    }
    // Функция для отображения предупреждающего алерта
    private func showTimerFinishedAlert() {
        let alertController = UIAlertController(
            title: "Timer",
            message: "Время таймера истекло.",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}
