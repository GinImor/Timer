//
//  Int+timer.swift
//  Timer
//
//  Created by Gin Imor on 9/12/21.
//  
//

import Foundation

extension Int {
  var timer: String {
    var text: String
    let seconds = self % 60
    let minutes = (self / 60) % 60
    let hours = (self / 3600)
    
    if hours != 0 {
      text = String(hours) + "h"
      if minutes != 0 && seconds != 0 {
        text += "+"
      }
    } else if minutes != 0 {
      text = String(minutes) + ":" + String(format: "%.2d", seconds)
    } else {
      text = String(seconds) + "s"
    }
    
    return text
  }
}
