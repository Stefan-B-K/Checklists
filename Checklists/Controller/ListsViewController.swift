
import UIKit

class ListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
  
  let cellIdentifier = "List"
  var dataModel: DataModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let index = dataModel.indexOfLastChecklist,
       index < dataModel.lists.count {                           // BUG : add list - add item - stop Xcode - not saved
      performSegue(withIdentifier: "ShowChecklist", sender: dataModel.lists[index])
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.delegate = self
  }
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataModel.lists.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let checklist = dataModel.lists[indexPath.row]
    
    let cell: UITableViewCell!
    if let tmp = tableView.dequeueReusableCell(
      withIdentifier: cellIdentifier) {
      cell = tmp
    } else {
      cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
    }
    
    cell.accessoryType = .detailDisclosureButton
    
    var content = cell.defaultContentConfiguration()
    content.text = checklist.name
    if checklist.items.count == 0 {
      content.secondaryText = "(Празен)"
    } else if checklist.unckeckedItems == 0 {
      content.secondaryText = "Всичко изпълнено"
    } else {
      content.secondaryText = "\(checklist.unckeckedItems) остава" + (checklist.unckeckedItems == 1 ? "" : "т")
    }
    content.image = UIImage(named: checklist.iconName)            // for .subtitle cell style only ! ! !
    content.imageProperties.tintColor = .label
    cell.contentConfiguration = content
    
    return cell
  }
  
  // MARK: - Table View Delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "ShowChecklist", sender: dataModel.lists[indexPath.row])
    dataModel.indexOfLastChecklist = indexPath.row
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      dataModel.lists.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      if indexPath.row == 0 {
        dataModel.indexOfLastChecklist = nil
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    let controller = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
    controller.delegate = self
    controller.listToEdit = dataModel.lists[indexPath.row]
    navigationController?.pushViewController(controller, animated: true)
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowChecklist" {
      let controller = segue.destination as! ChecklistViewController
      controller.checklist = sender as? Checklist
    } else if segue.identifier == "AddChecklist" {
      let controller = segue.destination as! ListDetailViewController
      controller.delegate = self
    }
  }
  
  // MARK: - ListDetail View Controller Delegate
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
    dataModel.lists.append(checklist)
    dataModel.sortLists()
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
    dataModel.sortLists()
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: - Navigation Controller Delegates
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {   //   < Back from sub-view
    if viewController === self {                                  // ===
      dataModel.indexOfLastChecklist = nil
    }
  }
  
}
