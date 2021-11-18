//
//  TimerViewController.swift
//  Timer
//
//  Created by Gin Imor on 9/12/21.
//  
//

import UIKit
import UserNotifications

class TimerViewController: UIViewController {

  @IBOutlet weak var display: UILabel!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet var buttons: [UIButton]!
  
  private let titleLabel = UILabel()
  
  private var timerStatus = TimerStatus()
  private var runningTimer: Timer?
  
  private var userNotificationCenter: UNUserNotificationCenter {
    return UNUserNotificationCenter.current()
  }
  
  fileprivate let animator = PopAnimator()
  
  // when reset and stop, screen will dimmed as usual, when run timer,
  // dim or not depend on setting, stop watch always screen on
  var isScreenAlwaysOn: Bool = false {
    didSet { UIApplication.shared.isIdleTimerDisabled = isScreenAlwaysOn }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    restoreState()
  }
  
  private func setupViews() {
    if let navigationBar = self.navigationController?.navigationBar {
      navigationBar.isTranslucent = true
      navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      navigationBar.shadowImage = UIImage()
    }
    
    titleLabel.text = "Timer"
    titleLabel.textColor = .white
    navigationItem.titleView = titleLabel
    
    display.text = ""
    
    for i in 0...2 {
      buttons[i].titleLabel?.adjustsFontSizeToFitWidth = true
      buttons[i].titleLabel?.minimumScaleFactor = 0.5
      buttons[i].titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
      buttons[i].setTitle(UserDefaults.timers[i].string(forKey: TITLE), for: .normal)
    }
    
    editButton.setTitleColor(UIColor(white: 1.0, alpha: 0.4), for: .disabled)
  }
  
  private func restoreState() {
    if let cachedSelectedTag = timerStatus.selectedTag {
      view.backgroundColor = .systemOrange
      let button = buttons[cachedSelectedTag]
      button.setTitle(timerStatus.originalTime?.timer, for: .normal)
      button.transform = CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95)
      button.layer.cornerRadius = 8
      editButton.isEnabled = true
      // if has selectedTag, and there should have targetTime, but for UserDefaults write issues
      // should have protect here in case they are inconsistent
      if let targetTime = timerStatus.targetTime {
        if targetTime < 1 { view.backgroundColor = .systemGreen }
        displayInterval(Double(targetTime))
      }

      if timerStatus.targetTime != nil, timerStatus.isRunning {
        // fire timer if previously running
        runningTimer = scheduleTimerWithTimeInterval(0.05)
      }
      // selected but never run and stopped has the different of targetTime
    } else {
      view.backgroundColor = .systemGreen
      if timerStatus.isRunning {
        runningTimer = scheduleTimerWithTimeInterval(0.01)
      } else if timerStatus.stopWatchTime > 0 {
        displayInterval(timerStatus.stopWatchTime)
      } else {
        view.backgroundColor = .systemOrange
      }
    }
  }
  
  @objc private func runTimer() {
    if timerStatus.selectedTag != nil {
      let targetTime = Int(timerStatus.startDate!.timeIntervalSinceNow) + timerStatus.targetTime!
      if targetTime < 1 { createBackgroundColorAnimation(changeTo: .systemGreen) }
      displayInterval(Double(targetTime))
    } else {
      displayInterval(Date().timeIntervalSince(timerStatus.startDate!) + timerStatus.stopWatchTime)
    }
  }
  
  private func displayInterval(_ interval: Double) {
    let absInterval = abs(Int(interval))
    let seconds = absInterval % 60
    let minutes = (absInterval / 60) % 60
    let hours = (absInterval / 3600)

    if timerStatus.targetTime == nil {
      let msec = interval.truncatingRemainder(dividingBy: 1)
      let minSecMsecString = String(format: "%.2d", minutes) + ":" + String(format: "%.2d", seconds) + "." + String(format: "%.2d", Int(msec * 100))
      display.text = hours == 0 ? minSecMsecString : String(hours) + ":" + minSecMsecString
    } else {
      if hours != 0 {
        display.text = String(hours) + ":" + String(format: "%.2d", minutes) + ":" + String(format: "%.2d", seconds)
      } else if minutes != 0 {
        display.text = String(minutes) + ":" + String(format: "%.2d", seconds)
      } else {
        display.text = String(seconds)
      }
    }
  }
    
  @IBAction func reset() {
    runningTimer?.invalidate()
    isScreenAlwaysOn = false
    display.text = ""
    startButton.setTitle(NSLocalizedString("Start", comment: ""), for: .normal)
    createStartButtonAnimation(isStarting: false)
    timerStatus.isRunning = false
    timerStatus.stopWatchTime = 0
    timerStatus.targetTime = nil
    timerStatus.originalTime = nil
    timerStatus.startDate = nil
    if let cachedSelectedTag = timerStatus.selectedTag {
      timerStatus.selectedTag = nil
      // unselect the selected button
      let button = buttons[cachedSelectedTag]
      button.setTitle(UserDefaults.timers[cachedSelectedTag].string(forKey: TITLE), for: .normal)
      editButton.isEnabled = false
      createAnimation(forButton: button, isSelecting: false)
    }
    cancelUserNotification()
    createBackgroundColorAnimation(changeTo: .systemOrange)
  }
  
  @IBAction func tappedTimerButton(_ sender: UIButton) {
    let cachedSelectedTag = timerStatus.selectedTag
    // reset any running timer or stop watch to initial state, cache the tag
    // before calling reset(), cause reset() will rewrite the tag
    reset()
    if cachedSelectedTag != sender.tag {
      // has new button to select, so select the button
      sender.setTitle(UserDefaults.timers[sender.tag].integer(forKey: TIME).timer, for: .normal)
      timerStatus.selectedTag = sender.tag
      let targetTime = UserDefaults.timers[sender.tag].integer(forKey: TIME)
      timerStatus.targetTime = targetTime
      timerStatus.originalTime = targetTime
      displayInterval(Double(targetTime))
      editButton.isEnabled = true
      createAnimation(forButton: sender, isSelecting: true)
    }
  }
  
  private func createAnimation(forButton button: UIButton, isSelecting: Bool) {
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: []) {
      button.transform = isSelecting ? CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95) : .identity
      button.layer.cornerRadius = isSelecting ? 8 : 0
      self.view.backgroundColor = .systemOrange
    }
  }
  
  private func createStartButtonAnimation(isStarting: Bool) {
    UIView.transition(with: self.startButton, duration: 0.1, options: [.transitionCrossDissolve, .allowUserInteraction]) {
      self.startButton.backgroundColor = isStarting ? .systemPink : .systemYellow
    }
  }
  
  private func createBackgroundColorAnimation(changeTo newColor: UIColor) {
    UIView.animate(withDuration: 0.4) {
      self.view.backgroundColor = newColor
    }
  }
  
  
  @IBAction func tappedStartButton(_ sender: UIButton) {
    let isStopWatch = timerStatus.selectedTag == nil
    if timerStatus.isRunning {
      timerStatus.isRunning = false
      runningTimer?.invalidate()
      isScreenAlwaysOn = false
      startButton.setTitle(NSLocalizedString("Start", comment: ""), for: .normal)
      createStartButtonAnimation(isStarting: false)
      if isStopWatch {
        timerStatus.stopWatchTime += Date().timeIntervalSince(timerStatus.startDate!)
        // display the last time, more accurate
        displayInterval(timerStatus.stopWatchTime)
      } else {
        timerStatus.targetTime = Int(timerStatus.startDate!.timeIntervalSinceNow) + timerStatus.targetTime!
        cancelUserNotification()
      }
    } else {
      if isStopWatch {
        createBackgroundColorAnimation(changeTo: .systemGreen)
      } else {
        sendUserNotification()
      }
      timerStatus.isRunning = true
      timerStatus.startDate = Date()
      runningTimer = scheduleTimerWithTimeInterval(isStopWatch ? 0.01 : 0.05)
    }
  }

  @IBAction func edit(_ sender: UIButton) {
    animator.originFrame = sender.superview!.convert(sender.frame, to: nil)
    let settingNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SettingNav") as! UINavigationController
    let settingViewController = settingNav.topViewController as! SettingViewController
    settingNav.transitioningDelegate = self
    settingNav.modalPresentationStyle = .fullScreen
    settingNav.navigationBar.alpha = 0.0
    settingViewController.currentUserDefaults = UserDefaults.timers[timerStatus.selectedTag!]
    
    settingViewController.settingDidSaveTimer = { [unowned self] (timerInterval, isScreenAlwaysOn) in
      // three states, only selected, selected and is running, selected and stop
      // if only selected, then change button title, target time and original time
      // otherwise, continue the last previous target time, when restoring, use the
      // original time to set the button title
      if self.timerStatus.startDate == nil {
        // only selected state, doesn't even have a start date
        self.buttons[self.timerStatus.selectedTag!].setTitle(timerInterval.timer, for: .normal)
        self.timerStatus.targetTime = timerInterval
        self.timerStatus.originalTime = timerInterval
        displayInterval(Double(timerInterval))
      }
      
      self.isScreenAlwaysOn = isScreenAlwaysOn
    }
    
    present(settingNav, animated: true) {
      sender.alpha = 0.0
    }
  }
  
  private func scheduleTimerWithTimeInterval(_ interval: TimeInterval) -> Timer {
    isScreenAlwaysOn = true
    if let cachedSelectedTag = timerStatus.selectedTag {
      isScreenAlwaysOn = UserDefaults.timers[cachedSelectedTag].bool(forKey: IS_SCREEN_ALWAYS_ON)
    }
    startButton.setTitle(NSLocalizedString("Stop", comment: ""), for: .normal)
    createStartButtonAnimation(isStarting: true)
    return Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
  }
  
  private func sendUserNotification() {
    let targetTime = timerStatus.targetTime!
    if targetTime > 0 {
      let content = UNMutableNotificationContent()
      // if not allowed to show alert or play sounds, then the corresponding propertie is ignored
      // so don't need to check it
      content.title = "Timer"
      content.sound = .default
      content.categoryIdentifier = CATEGORY_IDENTIFIER
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timerStatus.targetTime), repeats: false)
      let request = UNNotificationRequest(identifier: REQUEST_IDENTIFIER, content: content, trigger: trigger)
      userNotificationCenter.add(request, withCompletionHandler: nil)
    }
  }
  
  private func cancelUserNotification() {
    userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [REQUEST_IDENTIFIER])
  }
  
}


extension TimerViewController: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    animator.isPresenting = true
    return animator
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    animator.isPresenting = false
    animator.didDismiss = { [weak self] in
      self?.editButton.alpha = 1.0
    }
    return animator
  }
}
