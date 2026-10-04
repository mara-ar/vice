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

    func updateNotification(reminder: Reminder, isActive: Bool, motivationURL: URL) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests {
            allNotificationRequests in
            let request = allNotificationRequests.contains {
                $0.identifier == reminder.id.uuidString
            }
            if request {
                if !isActive {
                    self.deleteNotification(id: reminder.id)
                }
            } else {
                if isActive {
                    self.scheduleNotification(
                        title: "Updated", body: "updated body", reminder: reminder,
                        motivationURL: motivationURL)
                }
            }
        }
    }

    func deleteNotification(id: UUID) {
        let center = UNUserNotificationCenter.current()

        center.removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }

    func scheduleNotification(title: String, body: String, reminder: Reminder, motivationURL: URL) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = [
            "motivationLink": motivationURL.absoluteString
        ]

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
