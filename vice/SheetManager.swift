import SwiftUI

@Observable
class SheetManager {
    static let shared = SheetManager()

    // track sheets
    var createHabitSheet: Bool = false
    var createReminderSheet: Bool = false
    var openHabitSheet: Habit? = nil
    var checkInSheet: Bool = false

    // dismiss all sheets
    func dismissAllSheets() {
        createHabitSheet = false
        createReminderSheet = false
        openHabitSheet = nil
        checkInSheet = false
    }
}
