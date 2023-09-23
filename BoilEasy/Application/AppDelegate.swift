//
//  AppDelegate.swift
//  BoilEasy
//
//  Created by SHIN MIKHAIL on 18.09.2023.
//

import UIKit
import CoreData
import UserNotifications
import BackgroundTasks


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BoilEasy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    //MARK: - didFinishLaunchingWithOptions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Регистрация идентификатора фоновой задачи
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.BoilEasy.timerTask", using: nil) { task in
            self.handleBackgroundTask(task: task as! BGProcessingTask)
        }
        // Запрос разрешения на уведомления
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }
            self.notificationCenter.getNotificationSettings { (settings) in
                print(settings)
                guard settings.authorizationStatus == .authorized else { return }
            }
        }
        // Установка делегата для уведомлений
        notificationCenter.delegate = self
        // Отправка уведомлений (если это необходимо)
        sendNotifications()
        
        return true
    }

    func handleBackgroundTask(task: BGProcessingTask) {
        print("Starting background task...")
        // Ваш код фоновой обработки здесь.
        
        // Успешно завершите фоновую задачу
        task.setTaskCompleted(success: true)
        print("Background task completed.")
    }
    // MARK: - UserNotificationCenter
    let notificationCenter = UNUserNotificationCenter.current()
    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        notificationCenter.requestAuthorization(options: [.alert,.sound, .badge]) { (granted, error) in
//
//            guard granted else { return }
//            self.notificationCenter.getNotificationSettings { (settings) in
//                print(settings)
//                guard settings.authorizationStatus == .authorized else { return }
//            }
//        }
//
//        notificationCenter.delegate = self
//        sendNotifications()
//        return true
//    }
    
//        func sendNotifications() {
//
//            let content = UNMutableNotificationContent()
//            content.title = "First notification"
//            content.body = "My first notification"
//            content.sound = UNNotificationSound.default
//
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
//
//            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
//            notificationCenter.add(request) { (error) in
//            }
//        }
    func sendNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "Таймер завершен"
        content.body = "Пора!"
        content.sound = UNNotificationSound.default

        // Убедитесь, что здесь устанавливается правильное identifier, которое будет соответствовать вашему таймеру.
        let identifier = "TimerCompleteNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Ошибка при добавлении уведомления: \(error)")
            }
        }
    }
}
// MARK: - UserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }
    
}
