
import UIKit

protocol IconPickerViewControllerDelegate: AnyObject {
  func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
  
  weak var delegate: IconPickerViewControllerDelegate?
  let cellIdentifier = "IconCell"
  let icons = [
    "No Icon", "Appointments", "Birthdays", "Chores",
    "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"
  ]

  // MARK: - Table View Data Source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return icons.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    let icon = icons[indexPath.row]
    
    var content = cell.defaultContentConfiguration()
    content.text = icon
    content.image = UIImage(named: icon)
    content.imageProperties.tintColor = .label
    cell.contentConfiguration = content
    return cell
  }
  
  // MARK: - Table View Delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let delegate = delegate {
      delegate.iconPicker(self, didPick: icons[indexPath.row])
    }
  }
}
