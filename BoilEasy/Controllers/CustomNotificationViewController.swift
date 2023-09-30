//
//  CustomNotificationViewController.swift
//  BoilEasy
//
//  Created by SHIN MIKHAIL on 30.09.2023.
//

import Foundation
import UIKit

class CustomNotificationViewController: UIViewController {
    
    var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Добавьте метод для закрытия уведомления
    func closeNotification(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func showCustomNotification(message: String) {
        // Создайте экземпляр пользовательского контроллера представлений
        let customNotificationVC = CustomNotificationViewController(nibName: "CustomNotificationViewController", bundle: nil)
        
        // Настройте текст сообщения
        customNotificationVC.messageLabel.text = message
        
        // Отобразите пользовательский контроллер представлений как модальный
        customNotificationVC.modalPresentationStyle = .overFullScreen
        customNotificationVC.modalTransitionStyle = .crossDissolve
        
        // Показать пользовательское уведомление
        present(customNotificationVC, animated: true, completion: nil)
    }

}

//showCustomNotification(message: "Таймер завершен!")
