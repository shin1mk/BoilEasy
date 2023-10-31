//
//  text.swift
//  BoilEasy
//
//  Created by SHIN MIKHAIL on 19.10.2023.
//
/*
 Boil easy
 Параллельные таймеры
 Виджет на экран блокировки
 
 
 extension CustomTimerController {
     @objc private func startButtonTapped() {
         if isTimerRunning {
             stopButtonTapped()
         } else {
             if !isTimerPaused {
                 // Установите secondsRemaining в выбранное пользователем значение времени
                 secondsRemaining = selectedTime
                 startTimer()
             } else {
                 stopButtonTapped()
             }
         }
         feedbackGenerator.selectionChanged() // виброотклик
     }

     @objc func startTimer() {
         if isTimerRunning {
             return // Если таймер уже запущен, не делаем ничего
         }

         isTimerRunning = true
         startButton.setTitle("STOP", for: .normal)

         selectedTime = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
         remainingTime = selectedTime

         print("Starting timer with \(selectedTime) seconds")

         hidePickerViewAnimation()
         setupCircleLayer()
         animateCircle()

         startDate = Date()
         print(startDate!)

         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
     }

     @objc func timerFired() {
         remainingTime -= 1

         if remainingTime >= 0 {
             let hours = remainingTime / 3600
             let minutes = (remainingTime % 3600) / 60
             let seconds = remainingTime % 60

             timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
             print("Отсчет времени идет... \(hours):\(minutes):\(seconds) секунд")
         } else {
             timer?.invalidate()
             timerLabel.text = "00:00:00"
             isTimerRunning = false
             feedbackGenerator.selectionChanged()
         }
     }

     @objc private func stopButtonTapped() {
         if isTimerRunning {
             timer?.invalidate()
             isTimerRunning = false
         }

         isTimerPaused = false
         pickerView.alpha = 1
         startButton.setTitle("START", for: .normal)
         hideCircleLayer()
         feedbackGenerator.selectionChanged()
     }
 }

 */


