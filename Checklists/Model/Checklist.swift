
import UIKit

class Checklist: NSObject, Codable {
  var name = ""
  var iconName = "No Icon"
  var items = [ChecklistItem]()
  var unckeckedItems: Int {
    items.filter{ !$0.checked }.count
  }
  
  init(name: String, iconName: String = "No Icon") {
    self.name = name
    self.iconName = iconName
    super.init()
  }
  
  func sortChecklist() {
      var scheduledItems = items.filter { $0.dueDate != nil }
      scheduledItems.sort {$0.dueDate! < $1.dueDate! }
      let unscheduledItems = items.filter { $0.dueDate == nil }
      items = scheduledItems + unscheduledItems
  }
  
}
