//
//  AppDelegate.swift
//  Timer
//
//  Created by Gin Imor on 9/12/21.
//  
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    setupUserDefaultsIfNecessary()
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

