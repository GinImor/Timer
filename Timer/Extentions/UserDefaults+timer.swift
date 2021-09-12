//
//  UserDefaults+timer.swift
//  Timer
//
//  Created by Gin Imor on 9/12/21.
//  
//

import Foundation

extension UserDefaults {
  
  static var timers: [UserDefaults] = [
    UserDefaults(suiteName: "timer1")!,
    UserDefaults(suiteName: "timer2")!,
    UserDefaults(suiteName: "timer3")!
  ]
}
