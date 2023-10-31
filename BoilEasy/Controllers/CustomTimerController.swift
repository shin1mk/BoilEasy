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
    private var backgroundLayer: CAShapeLayer! //

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
    
    // Добавьте переменную для хранения времени, оставшегося до паузы
    private var pausedTime: Int?
    private var isTimerPaused: Bool = false
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background.png")
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
        label.text = "00:00"
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
        // background image view
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // title label
        view.addSubview(titleLabel)
        titleLabel.layer.zPosition = 1
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
            make.top.equalTo(pickerView.snp.bottom).offset(120)
            make.width.equalTo(150)
        }
        // start button
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pickerView.snp.bottom).offset(165)
            make.width.equalTo(140)
        }
        // pause button
        view.addSubview(pauseButton)
        pauseButton.layer.zPosition = 1
        pauseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(startButton.snp.bottom).offset(5)
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
    @objc private func startButtonTapped() {
        if isTimerRunning {
            stopButtonTapped()
        } else {
            if !isTimerPaused {
                // Установите secondsRemaining в выбранное пользователем значение времени
                secondsRemaining = selectedTime
                // Запустите таймер
                startTimer()
            } else {
                // Если таймер был приостановлен, то нажатие "Старт" возобновит его
                stopButtonTapped()
            }
        }
        feedbackGenerator.selectionChanged() // виброотклик
    }
    @objc func timerFired() {
        remainingTime -= 1

        if remainingTime > 0 {
            let hours = remainingTime / 3600
            let minutes = (remainingTime % 3600) / 60
            let seconds = remainingTime % 60

            timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            print("Отсчет времени идет... \(hours):\(minutes):\(seconds) секунд") // Вывод сообщения в консоль
        } else {
            // Отсчет завершен
            timer?.invalidate()
            timerLabel.text = "00:00:00"
            isTimerRunning = false
            feedbackGenerator.selectionChanged() // виброотклик

            // Добавьте здесь действия, которые вы хотите выполнить по завершении отсчета.
        }
    }

    @objc func startTimer() {
        isTimerRunning = true
        startButton.setTitle("STOP", for: .normal)
        
        selectedTime = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
        remainingTime = selectedTime
        isTimerRunning = true
        startButton.setTitle("STOP", for: .normal)
        
        let totalSeconds = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
        print("Starting timer with \(totalSeconds) seconds")

        hidePickerViewAnimation()// Скроем UIPickerView
        setupCircleLayer() // Вызовем метод для настройки и показа круговой анимации
        animateCircle() // Запустим анимацию круга
        
        startDate = Date() // Запоминаем текущую дату при старте таймера
        print(startDate!)
        // ... остальной код ...

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }

    // stop Timer reset
    @objc private func stopButtonTapped() {
        isTimerRunning = false
        isTimerPaused = false // Сбрасываем состояние паузы

        pickerView.alpha = 1

        startButton.setTitle("START", for: .normal)
//        timer?.invalidate() // Остановка таймера

        hideCircleLayer()
        feedbackGenerator.selectionChanged() // виброотклик
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
    // Устанавливает прогресс анимации окружности
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
