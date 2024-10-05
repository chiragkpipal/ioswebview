import UIKit
import Flutter
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase
    FirebaseApp.configure()
    
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    // Set up messaging delegate
    UNUserNotificationCenter.current().delegate = self
    
    // Request notification permissions
    requestNotificationPermissions()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Request permission for notifications
  private func requestNotificationPermissions() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if let error = error {
            print("Error requesting notifications: \(error)")
        }
    }
  }
  
  // Handle incoming messages while the app is in the foreground
  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // Handle the received notification
    print("Received notification: \(userInfo)")
    completionHandler(.newData)
  }
}
