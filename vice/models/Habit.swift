import SwiftUI

struct Reminder: Codable, Identifiable {
    let id: UUID
    let hour: Int
    let minute: Int
    var isActive: Bool
}

struct Habit: Codable, Identifiable {
    let id: UUID
    var habit: String
    var motivation: URL
    var reminders: [Reminder]
}
