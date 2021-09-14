//
//  TimePickerView.swift
//  Timer
//
//  Created by Gin Imor on 9/14/21.
//  
//

import UIKit

class TimePickerView: UIPickerView, UIPickerViewDataSource {
  
  static func timeUnitLabel(forUnit unit: String) -> UILabel {
    let label = UILabel()
    label.text = NSLocalizedString(unit, comment: "")
    label.textColor = .white
    return label
  }
  
  private let hoursLabel = timeUnitLabel(forUnit: "hours")
  private let minutesLabel = timeUnitLabel(forUnit: "min")
  private let secondsLabel = timeUnitLabel(forUnit: "sec")
  
  var hours = 0
  var minutes = 0
  var seconds = 0
  
  var timeInterval: Int {
    hours * 3600 + minutes * 60 + seconds
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  private func setup() {
    dataSource = self
    addSubview(hoursLabel)
    addSubview(minutesLabel)
    addSubview(secondsLabel)
    
    self.setValue(UIColor.white, forKey: "textColor")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let labelY: CGFloat = bounds.height / 2 - 15
    let labelSize = CGSize(width: 75, height: 30)
    hoursLabel.frame = CGRect(origin: CGPoint(x: (bounds.width / 6) + 14, y: labelY), size: labelSize)
    minutesLabel.frame = CGRect(origin: CGPoint(x: (bounds.width / 2) + 15, y: labelY), size: labelSize)
    secondsLabel.frame = CGRect(origin: CGPoint(x: 5 * (bounds.width / 6) + 16, y: labelY), size: labelSize)
  }
  

  
  // MARK: - Data Source
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch component {
    case 0: return 24
    case 1: return 60
    case 2: return 60
    default: return 0
    }
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int { 3 }
  
  func didSelectRow(_ row: Int, inComponent component: Int) {
    switch component {
    case 0: hours = row
    case 1: minutes = row
    case 2: seconds = row
    default: break
    }
  }
  
  
  func updateViewWithInterval(_ interval: Int) {
    seconds = interval % 60
    minutes = (interval / 60) % 60
    hours = interval / 3600
    selectRow(seconds, inComponent: 2, animated: false)
    selectRow(minutes, inComponent: 1, animated: false)
    selectRow(hours, inComponent: 0, animated: false)
  }

}

