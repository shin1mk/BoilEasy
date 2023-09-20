
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
