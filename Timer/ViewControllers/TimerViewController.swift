//
//  TimerViewController.swift
//  Timer
//
//  Created by Gin Imor on 9/12/21.
//  
//

import UIKit

class TimerViewController: UIViewController {

  @IBOutlet weak var display: UILabel!
  
  @IBOutlet var editButton: UIButton!
  @IBOutlet var buttons: [UIButton]!
  
  private var selectedTag = -1
  

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  private func setupViews() {
    for i in 0...2 {
      buttons[i].layer.borderColor = UIColor.white.cgColor
    }
  }
    
  @IBAction func reset(_ sender: Any) {
    
  }
  
  @IBAction func tappedTimerButton(_ sender: UIButton) {
    let cachedSelectedTag = selectedTag
    if cachedSelectedTag != -1 {
      // unselect the selected button,
      let button = buttons[selectedTag]
      button.setTitle(UserDefaults.timers[selectedTag].string(forKey: TITLE), for: .normal)
      button.layer.borderWidth = 0.0
      selectedTag = -1
      editButton.isEnabled = false
    }
    if cachedSelectedTag != sender.tag {
      // has new button to select, so select the button
      sender.setTitle(UserDefaults.timers[sender.tag].integer(forKey: TIME).timer, for: .normal)
      sender.layer.borderWidth = 1.0
      selectedTag = sender.tag
      editButton.isEnabled = true
    }
  }
  
  @IBAction func tappedStopWatchButton(_ sender: UIButton) {
    
  }
  

  @IBAction func edit(_ sender: Any) {
    
  }

}
