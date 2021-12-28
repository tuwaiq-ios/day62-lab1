//
//  PartsViewController.swift
//  CoreDataTask
//
//  Created by Amal on 24/12/2021.
//

import UIKit

import UIKit
import CoreData

class PartsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var part = [Part]()
    var passedSupplier: Supplier?
    var passedPart: Part?
    var trackable = [Trackable]()
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfig()
        addButton()
        imagePicker.delegate = self

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadOrders()
    }
    func addButton() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addOrderAction))
        navigationItem.rightBarButtonItems = [add]
    }
    func tableViewConfig() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    //MARK: - CRUD
    func saveOrders() {
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    func loadOrders(with request: NSFetchRequest<Part> = Part.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentSupplier.name MATCHES %@", passedSupplier!.name!)
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        do {
            part = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        self.tableView.reloadData()
    }
    func deleteOrders(item: Part) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            //
        }
    }
    func updateOrder(item: Part, name: String, retailPrice: String, size: String, indexPath: IndexPath) {
        item.name = name
        item.retailPrice = retailPrice
        item.size = size
        do {
            try context.save()
        } catch {
            //
        }
    }
    //MARK: - Actions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          picker.dismiss(animated: true, completion: nil)
          guard let image = info[.originalImage] as? UIImage else {
              fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
          }
        guard let data = image.pngData() else {return}
        var secondNametextField = UITextField()
        var thirdNametextField = UITextField()
        var fourthNametextField = UITextField()
        let alert = UIAlertController(title: "Add New Parts", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        let action = UIAlertAction(title: "Add Parts", style: .default) { (action) in
            let newOrder = Part(context: self.context)
            newOrder.name = secondNametextField.text!
            newOrder.retailPrice = thirdNametextField.text!
            newOrder.image = data
            newOrder.size = fourthNametextField.text!
            newOrder.parentSupplier = self.passedSupplier
            self.part.append(newOrder)
            self.saveOrders()
        }
        alert.addTextField { (field) in
            secondNametextField = field
            secondNametextField.placeholder = "Add Name"
        }
        alert.addTextField { (field) in
            thirdNametextField = field
            thirdNametextField.placeholder = "Add Retail Price"
        }
        alert.addTextField { (field) in
            fourthNametextField = field
            fourthNametextField.placeholder = "Add Size"
        }
        alert.addAction(action)
        present(alert, animated: true)
      }
    @objc func addOrderAction() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true)
             }
    }
    func updateAction(indexPath: IndexPath) {
        let model = part[indexPath.row]
        let alertController = UIAlertController(title:"Update", message:"Update Your Order", preferredStyle:.alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        alertController.addTextField{(textField) in
            textField.text = model.name
        }
        alertController.addTextField{(textField) in
            textField.text = model.retailPrice
        }
        alertController.addTextField{(textField) in
            textField.text = model.size
        }
        let updateAction = UIAlertAction(title: "Update", style:.default){(_) in
            let name = alertController.textFields?[0].text
            let retailPrice =  alertController.textFields?[1].text
            let size =  alertController.textFields?[2].text
            self.updateOrder(item: model, name: name ?? "", retailPrice: retailPrice ?? "", size: size ?? "", indexPath: indexPath)
            self.loadOrders()
        }
        alertController.addAction(updateAction)
        present(alertController, animated: true)
    }
}
//MARK: - TableView
extension PartsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return part.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PartsCell
        let model = part[indexPath.row]
        if let data = model.image {
            cell.firstLabel.image = UIImage(data: data)
        }
        let name = model.name
        let retailPrice = model.retailPrice
        let size = model.size
        cell.secondLabel.text = "name: \(name ?? "")"
        cell.thirdLabel.text = "retailPrice: \(retailPrice ?? "")"
        cell.fourthLabel.text = "size: \(size ?? "")"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(String(describing: index))" as NSString
        return UIContextMenuConfiguration( identifier: identifier, previewProvider: nil) { _ in
            let editAction = UIAction(
                title: "Edit",
                image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    self.updateAction(indexPath: indexPath)
                }
            return UIMenu(title: "", image: nil, children: [editAction])
        }
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        passedPart = part[indexPath.row]
        return indexPath
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 228
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
        }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                tableView.beginUpdates()
                let item = part[indexPath.row]
                deleteOrders(item: item)
                loadOrders()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
    }
}
//MARK: - Cell
class PartsCell: UITableViewCell{
    @IBOutlet weak var firstLabel: UIImageView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
}
