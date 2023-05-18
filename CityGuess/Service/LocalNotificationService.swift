//
//  LocalNotificationService.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/10/23.
//

import Foundation

import UserNotifications

class LocalNotificationService {
    static let shared = LocalNotificationService()
    private init() { }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Permission Granted!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func scheduleLocalNotification(with title: String, scheduledIn timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func cancelLocalNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func removeDeliveredNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
