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
