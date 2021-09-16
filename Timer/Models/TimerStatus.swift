//
//  TimerStatus.swift
//  Timer
//
//  Created by Gin Imor on 9/12/21.
//  
//

import Foundation

struct TimerStatus {
  
  // five states:
  // timer button selected and running(isRunning), just selected(startDate == nil) or stopped
  // timer button not selected but stop watch is on, or is off(stopWatchTime has value > 0)
  // null state
  
  var selectedTag: Int? {
    get { UserDefaults.standard.value(forKey: SELECTED_TAG) as? Int }
    set { UserDefaults.standard.setValue(newValue, forKey: SELECTED_TAG)}
  }
  
  var startDate: Date? {
    get { (UserDefaults.standard.object(forKey: START_DATE) as? Date) }
    set { UserDefaults.standard.setValue(newValue, forKey: START_DATE) }
  }
  
  // running target time, it change when you stop the timer
  var targetTime: Int! {
    get { UserDefaults.standard.value(forKey: TARGET_TIME) as? Int }
    set { UserDefaults.standard.setValue(newValue, forKey: TARGET_TIME) }
  }
  
  // last selected original target time, when select the timer button it record the target time
  var originalTime: Int? {
    get { UserDefaults.standard.value(forKey: ORIGINAL_TIME) as? Int }
    set { UserDefaults.standard.setValue(newValue, forKey: ORIGINAL_TIME) }
  }
  
  var stopWatchTime: Double {
    get { UserDefaults.standard.double(forKey: STOP_WATCH_TIME) }
    set { UserDefaults.standard.setValue(newValue, forKey: STOP_WATCH_TIME) }
  }
  
  var isRunning: Bool {
    get { UserDefaults.standard.bool(forKey: IS_RUNNING) }
    set { UserDefaults.standard.setValue(newValue, forKey: IS_RUNNING) }
  }
  
}
