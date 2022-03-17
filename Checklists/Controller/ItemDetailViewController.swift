
import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

  weak var delegate: ItemDetailViewControllerDelegate?
  var itemToEdit: ChecklistItem?
  
  @IBOutlet weak var doneButton: UIBarButtonItem!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var reminderSwitch: UISwitch!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var dateLabel: UILabel!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorStyle = .none
    
    if let item = itemToEdit {
      doneButton.isEnabled = true
      title = "Промени елемент"
      textField.text = item.text
      reminderSwitch.isOn = item.withReminder
      if reminderSwitch.isOn {
        datePicker.date = item.dueDate!
      }
    }
    if !reminderSwitch.isOn {
      dateLabel.isHidden = true
      datePicker.isHidden = true
    }
  }
  
  @IBAction func cancel() {
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let item = itemToEdit {
      item.text = textField.text!
      item.withReminder = reminderSwitch.isOn
      item.dueDate = reminderSwitch.isOn ? datePicker.date : nil
      item.scheduleNotification()
      delegate?.itemDetailViewController(self, didFinishEditing: item)
    } else {
      let newItem = ChecklistItem(text: textField.text!)
      newItem.withReminder = reminderSwitch.isOn
      newItem.dueDate = reminderSwitch.isOn ? datePicker.date : nil
      newItem.scheduleNotification()
      delegate?.itemDetailViewController(self, didFinishAdding: newItem)
    }
  }
  
  @IBAction func switchReminder(_ sender: UISwitch) {
    dateLabel.isHidden.toggle()
    if !datePicker.isHidden {
      datePicker.date = Date()
    }
    datePicker.isHidden.toggle()
    textField.resignFirstResponder()
    if sender.isOn {
      let notificationCenter = UNUserNotificationCenter.current()
      notificationCenter.requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
  }
  
  // MARK: - Table View Delegate
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
  // MARK: - Text Field Delegate
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText = textField.text!
    let stringRange = Range(range, in: oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)

    doneButton.isEnabled = !newText.isEmpty

    return true
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    doneButton.isEnabled = false
    return true
  }
  
  // MARK: - User Notification Delegates
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
   
  }
}
