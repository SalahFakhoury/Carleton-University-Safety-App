//
//  uwbappApp.swift
//  uwbapp
//
//

import SwiftUI
import EstimoteProximitySDK
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      NotificationService.shared.reguestForAuthorization()

    return true
  }
}

@main
struct uwbappApp: App {
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    let list: BeaconList = BeaconList(items: [])
    var body: some Scene {
        WindowGroup {
            ContentView(beaconList: list)
        }
    }
}
