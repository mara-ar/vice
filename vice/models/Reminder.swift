import SwiftUI

struct Reminder: Identifiable {
    let id = UUID()
    let hour: Int
    let minute: Int
    var isActive: Bool
}
