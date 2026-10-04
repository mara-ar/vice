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
    @UIApplicationDelegateAdaptor(AppData.self) private var appData
    @StateObject var router: Router = Router()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [
                    Reminder.self,
                    Habit.self,
                ])
                .environmentObject(router)
                .environment(appData)
                .task {
                    appData.router = router
                }
        }
    }
}

@Observable
class AppData: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var router: Router!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter, willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.sound, .banner]
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse
    ) async {
        DispatchQueue.main.async {
            if let motivationLink = response.notification.request.content.userInfo["motivationLink"]
                as? String
            {
                if let motivationURL = URL(string: motivationLink) {
                    SheetManager.shared.dismissAllSheets()
                    if self.router.path.last != .motivation(url: motivationURL) {
                        self.router.path = []
                        self.router.path.append(.motivation(url: motivationURL))
                    }
                }
            }
        }
    }
}
