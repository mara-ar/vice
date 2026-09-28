import SwiftUI

class NotificationManager {
    static let instance = NotificationManager()

    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (_, error) in
            if let error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }

    func deleteNotification(id: UUID) {
        let center = UNUserNotificationCenter.current()

        center.removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }

    func scheduleNotification(title: String, body: String, reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "This is the body"
        content.sound = .default

        // time
        // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)

        // calendar
        var dateComponents = DateComponents()
        dateComponents.hour = reminder.hour
        dateComponents.minute = reminder.minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: reminder.id.uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }
}
