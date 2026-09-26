import SwiftData
import SwiftUI

@Model
class Reminder: Identifiable {
    var id: UUID
    var hour: Int
    var minute: Int
    var isActive: Bool

    init(id: UUID = UUID(), hour: Int, minute: Int, isActive: Bool = true) {
        self.id = id
        self.hour = hour
        self.minute = minute
        self.isActive = isActive
    }
}

@Model
class Habit: Identifiable {
    var id: UUID
    var habit: String
    var motivation: URL
    var reminders: [Reminder]

    init(id: UUID = UUID(), habit: String, motivation: URL, reminders: [Reminder] = []) {
        self.id = id
        self.habit = habit
        self.motivation = motivation
        self.reminders = reminders
    }
}
