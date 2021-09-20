//
//  AppDelegate.swift
//  Timer
//
//  Created by Gin Imor on 9/12/21.
//  
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


  
  func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    return true
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    setupUserDefaultsIfNecessary()
    setupUserNotificationCenter()
    return true
  }
  
  private func setupUserDefaultsIfNecessary() {
    if UserDefaults.standard.bool(forKey: DEFAULT_SETTING) == false {
      UserDefaults.standard.set(true, forKey: DEFAULT_SETTING)
      let times = [10, 40, 60]
      let titles = ["Think", "Cook", "Fish"]
      
      for i in 0...2 {
        let userDefaults = UserDefaults.timers[i]
        userDefaults.setValue(true, forKey: IS_SCREEN_ALWAYS_ON)
        userDefaults.setValue(times[i], forKey: TIME)
        userDefaults.setValue(titles[i], forKey: TITLE)
      }
    }
  }
  
  private func setupUserNotificationCenter() {
    // user notification setting
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
    }
    let timerCategory = UNNotificationCategory(identifier: CATEGORY_IDENTIFIER, actions: [], intentIdentifiers: [], options: .customDismissAction)
    UNUserNotificationCenter.current().setNotificationCategories([timerCategory])
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner, .sound])
  }
  
}

