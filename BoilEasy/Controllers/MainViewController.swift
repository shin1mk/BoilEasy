
//
//  MainViewController.swift
//  BoilEasy
//
//  Created by SHIN MIKHAIL on 18.09.2023.
//
import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let difficultyLabels = ["Soft", "Medium", "Hard"]
    private let imagesForDifficulties: [String: UIImage] = [
        "Soft": UIImage(named: "soft.png")!,
        "Medium": UIImage(named: "medium.png")!,
        "Hard": UIImage(named: "hard.png")!
    ]
    private var shapeLayer: CAShapeLayer!
    private var currentProgress: Float = 1.0 // Начнем с полной окружности круга
    private var currentIndex = 1 // текущий label
    private var timer: Timer?
    private var secondsRemaining = 8 * 60 // Устанавливаем начальное время
    private var isTimerRunning = false // Переменная для отслеживания состояния таймера
    private let timerDurations = [360, 480, 660] // Soft - 6 минут, Medium - 8 минут, Hard - 11 минут
    
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
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
        setupGestures()
        setupDifficultyLabels()
        updateImageView()
        updateTimerLabelForCurrentDifficulty()
        backgroundImage()
        setupCircleLayer()
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
        backgroundLayer.lineWidth = 8
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
        shapeLayer.lineWidth = 8
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 1
        view.layer.addSublayer(shapeLayer)
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
        if let imageName = difficultyLabels[safe: currentIndex], let image = imagesForDifficulties[imageName] {
            imageView.image = image
        }
    }
    //MARK: - Constraints
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
            make.bottom.equalToSuperview().offset(-150) // значение для закрепления от низа
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
        enableGestures(!isTimerRunning)
    }
    // start Timer
    private func startTimer() {
        isTimerRunning = true
        startButton.setTitle("CANCEL", for: .normal)
        secondsRemaining = timerDurations[currentIndex] // Используйте продолжительность для текущей сложности
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        updateTimerLabel()
        animateCircle()
    }
    // stop Timer
    private func stopTimer() {
        isTimerRunning = false
        startButton.setTitle("START", for: .normal)
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
            stopTimer()
        }
    }
    // updateTimerLabel
    private func updateTimerLabel() {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        timerLabel.text = timeString
        let totalDuration = Float(timerDurations[currentIndex])
        let remainingTime = Float(secondsRemaining)
        currentProgress = 1.0 - (remainingTime / totalDuration)
        setProgress(1.0 - currentProgress)
    }
    // updateTimerLabelForCurrentDifficulty
    private func updateTimerLabelForCurrentDifficulty() {
        let minutes = timerDurations[currentIndex] / 60
        let seconds = timerDurations[currentIndex] % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        timerLabel.text = timeString
        updateImageView()
    }
    // Устанавливает прогресс анимации окружности
    private func setProgress(_ progress: Float) {
        shapeLayer.strokeEnd = CGFloat(progress)
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
            currentIndex = (currentIndex - 1 + difficultyLabels.count) % difficultyLabels.count
        case .right:
            currentIndex = (currentIndex + 1) % difficultyLabels.count
        default:
            break
        }
        animateImage()
        animateLabels()
        updateTimerLabelForCurrentDifficulty()
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
            updateTimerLabelForCurrentDifficulty()
        }
    }
}
