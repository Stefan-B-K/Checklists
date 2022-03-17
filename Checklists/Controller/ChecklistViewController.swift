
import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {

  let cellIdentifier = "ChecklistItem"
  var checklist: Checklist!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = checklist.name
  }
  
  // MARK: - Actions
  func setCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
    let checkLabel = cell.viewWithTag(1002) as! UILabel
    checkLabel.tintColor = item.checked ? UIColor.tintColor : .systemBackground
  }
  
  func setText(for cell: UITableViewCell, with item: ChecklistItem) {
    let itemNameLabel = cell.viewWithTag(1000) as! UILabel
    itemNameLabel.text = item.text
    let dueDateLabel = cell.viewWithTag(1001) as! UILabel
    if let dueDate = item.dueDate {
      dueDateLabel.isHidden = false
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd.MM.YYYY   HH:mm"
      dueDateLabel.text = dateFormatter.string(from: dueDate)
    } else {
      dueDateLabel.isHidden = true
    }
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let controller = segue.destination as? ItemDetailViewController {
      controller.delegate = self
      if segue.identifier == "EditItem", let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
        controller.itemToEdit = checklist.items[indexPath.row]
      }
    }
  }
  
  // MARK: - Table View Data Source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return checklist.items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    let item = checklist.items[indexPath.row]
    setText(for: cell, with: item)
    setCheckmark(for: cell, with: item)
    return cell
  }
  
  // MARK: - Table View Delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      checklist.items[indexPath.row].checked.toggle()
      setCheckmark(for: cell, with: checklist.items[indexPath.row])
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      checklist.items.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  // MARK: - ItemDetail View Controller Delegate
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
    checklist.items.append(item)
    checklist.sortChecklist()
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
    checklist.sortChecklist()
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
}

