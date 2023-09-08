//
//  LocalNotificationService.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/10/23.
//

import Foundation

import UserNotifications

class LocalNotificationService: NSObject {
    static let shared = LocalNotificationService()

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

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
        let request = UNNotificationRequest(identifier: Notification.Name.dailyChallengeUnlockedNotification.rawValue, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func cancelLocalNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func removeDeliveredNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

// MARK: Daily Challenge Unlocked Notification
extension LocalNotificationService {
    func cancelDailyChallengeNotification() {
        cancelLocalNotification(withIdentifier: Notification.Name.dailyChallengeUnlockedNotification.rawValue)
    }
}

extension Notification.Name {
    static let dailyChallengeUnlockedNotification = Notification.Name("dailyChallengeUnlocked")
}

// MARK: UNUserNotificationCenterDelegate
extension LocalNotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == Notification.Name.dailyChallengeUnlockedNotification.rawValue {
            NotificationCenter.default.post(name: .dailyChallengeUnlockedNotification, object: response.notification.request.content)
        }

        completionHandler()
    }
}
