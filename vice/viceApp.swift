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

extension Font {
    static func appFont(_ style: Font.TextStyle) -> Font {
        let fontName: String
        let fontSize: CGFloat

        switch style {
        case .largeTitle:
            fontName = "IBMPlexMono-Bold"
            fontSize = 34
        case .title:
            fontName = "IBMPlexMono-Bold"
            fontSize = 28
        case .title2:
            fontName = "IBMPlexMono-SemiBold"
            fontSize = 22
        case .title3:
            fontName = "IBMPlexMono-SemiBold"
            fontSize = 20
        case .headline:
            fontName = "IBMPlexMono-SemiBold"
            fontSize = 17
        case .subheadline:
            fontName = "IBMPlexMono-Regular"
            fontSize = 15
        case .body:
            fontName = "IBMPlexMono-Regular"
            fontSize = 17
        case .callout:
            fontName = "IBMPlexMono-Regular"
            fontSize = 16
        case .footnote:
            fontName = "IBMPlexMono-Regular"
            fontSize = 13
        case .caption:
            fontName = "IBMPlexMono-Regular"
            fontSize = 12
        case .caption2:
            fontName = "IBMPlexMono-Regular"
            fontSize = 11
        @unknown default:
            fontName = "IBMPlexMono-Regular"
            fontSize = 17
        }

        return Font.custom(fontName, size: fontSize, relativeTo: style)
    }
}
