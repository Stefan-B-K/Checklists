
import UIKit

class ChecklistItem: NSObject, Codable {
  
  var text = ""
  var checked = false
  var dueDate: Date?
  var withReminder = false
  var itemID: Int!
  
  init(text: String) {
    self.text = text
    itemID = DataModel.nextChecklistItemID()
  }
  
  deinit {
    removeNotification()
  }
  
  func scheduleNotification() {
    removeNotification()
    guard withReminder, let dueDate = dueDate, dueDate > Date() else { return }
    
    let content = UNMutableNotificationContent()
    content.body = text
    content.sound = UNNotificationSound.default
    
    let calendar = Calendar(identifier: .gregorian)
    let dateComponenets = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponenets, repeats: false)
    
    let request = UNNotificationRequest(identifier: "\(itemID!)", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
  }
  
  func removeNotification() {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(itemID!)"])
  }
  
}

