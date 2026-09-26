//
//  viceApp.swift
//  vice
//
//  Created by Abhinav Mara on 9/22/26.
//

import SwiftData
import SwiftUI

@main
struct viceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [
                    Reminder.self,
                    Habit.self,
                ])
        }
    }
}
