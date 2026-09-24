import SwiftUI

struct Reminder: Identifiable {
    let id = UUID()
    let time: String
    let isActive: Bool
}
