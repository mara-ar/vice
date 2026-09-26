import SwiftUI

struct Reminder: Identifiable {
    let id = UUID()
    let hour: Int
    let minute: Int
    let isActive: Bool
}
