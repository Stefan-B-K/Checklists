
import Foundation

class DataModel {
  
  var lists = [Checklist]()
  
  var indexOfLastChecklist: Int? {
    get {
      return UserDefaults.standard.value(forKey: "ListIndex") as? Int
    }
    set {
      if let newValue = newValue {
        UserDefaults.standard.set(newValue, forKey: "ListIndex")
      } else {
        UserDefaults.standard.removeObject(forKey: "ListIndex")
      }
    }
  }
  
  init() {
    loadLists()
    registerDefaults()
    handleFirstRun()
  }
  
  func documentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  
  func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Checklists.plist")
  }
  
  func saveLists() {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(lists)
      try data.write(to: dataFilePath())
    } catch {
      print("Грешка при кодирането на списъците \(error.localizedDescription)")
    }
  }
  
  func loadLists() {
    if let data = try? Data(contentsOf: dataFilePath()) {
      let decoder = PropertyListDecoder()
      do {
        lists = try decoder.decode([Checklist].self, from: data)
        sortLists()
        for list in lists { list.sortChecklist() }
      } catch {
        print("Грешка при декодиране на списъците \(error.localizedDescription)")
      }
    }
  }
  
  func sortLists() {
    lists.sort { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
  }
  
  func registerDefaults() {
    UserDefaults.standard.register(defaults: ["FirstRun": true])
  }
  
  func handleFirstRun() {
    let firstRun = UserDefaults.standard.bool(forKey: "FirstRun")

    if firstRun {
      let initialList = Checklist(name: "Нов списък")
      lists.append(initialList)

      indexOfLastChecklist = 0
      UserDefaults.standard.set(false, forKey: "FirstRun")
    }
  }
  
  class func nextChecklistItemID() -> Int {
    let userDefaults = UserDefaults.standard
    let itemID = userDefaults.integer(forKey: "ChecklistItemID")
    userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
    return itemID
  }


}
