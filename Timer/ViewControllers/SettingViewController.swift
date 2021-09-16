//
//  SettingViewController.swift
//  Timer
//
//  Created by Gin Imor on 9/14/21.
//  
//

import UIKit

class SettingViewController: UIViewController {
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var timePickerView: TimePickerView!
  @IBOutlet weak var screenAlwaysOnSwitch: UISwitch!
  
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  
  @IBOutlet weak var containerView: UIStackView!
  var containerViewAlpha: CGFloat = 0.0 {
    didSet {
      containerView.alpha = containerViewAlpha
    }
  }
  
  var currentUserDefaults: UserDefaults!
  
  var settingDidSaveTimer: ((_ timeInterval: Int, _ isScreenAlwaysOn: Bool) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  private func setupViews() {
    if let navigationBar = self.navigationController?.navigationBar {
      navigationBar.isTranslucent = true
      navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      navigationBar.shadowImage = UIImage()
    }
    
    titleTextField.delegate = self
    timePickerView.delegate = self
    titleTextField.text = currentUserDefaults.string(forKey: TITLE)
    timePickerView.updateViewWithInterval(currentUserDefaults.integer(forKey: TIME))
    screenAlwaysOnSwitch.isOn = currentUserDefaults.bool(forKey: IS_SCREEN_ALWAYS_ON)
  }

  @IBAction func cancel(_ sender: Any) {
    dismiss(animated: true)
  }
  
  @IBAction func save(_ sender: Any) {
    let timeInterval = timePickerView.timeInterval
    currentUserDefaults.setValue(titleTextField.text, forKey: TITLE)
    currentUserDefaults.setValue(timeInterval, forKey: TIME)
    currentUserDefaults.setValue(screenAlwaysOnSwitch.isOn, forKey: IS_SCREEN_ALWAYS_ON)
    settingDidSaveTimer?(timeInterval, screenAlwaysOnSwitch.isOn)
    dismiss(animated: true)
  }
  
  func showBarButtonItems() {
    cancelButton.tintColor = .white
    saveButton.tintColor = .white
  }
  
  func hideBarButtonItems() {
    cancelButton.tintColor = .clear
    saveButton.tintColor = .clear
  }
  
}


extension SettingViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}


extension SettingViewController: UIPickerViewDelegate {
  
  // MARK: - Delegate
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return String(row)
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    if let reusingView = view as? UILabel {
      reusingView.text = "\(row)"
      print("label position in superview \(reusingView.frame)")
      return reusingView
    }
    let label = UILabel()
    label.textColor = .white
    label.textAlignment = .center
    label.text = "\(row)"
    return label
  }
  
  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { 30 }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    timePickerView.didSelectRow(row, inComponent: component)
  }
}

