//
//  SuppliersViewController.swift
//  CoreDataTask
//
//  Created by Amal on 21/05/1443 AH.
//

import UIKit
import CoreData

class SuppliersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var supplier = [Supplier]()
    var passedSupplier: Supplier?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfig()
        addButton()
        loadSupplies()
    }
    
    func addButton() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        navigationItem.rightBarButtonItems = [add]
    }
    func tableViewConfig() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func saveCustomer() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadSupplies() {
        let request : NSFetchRequest<Supplier> = Supplier.fetchRequest()
        do{
            supplier = try context.fetch(request)
        } catch {
            print("Error loading customers \(error)")
        }
        tableView.reloadData()
    }
    func deleteCustomer(item: Supplier) {
        context.delete(item)
        do {
            try context.save()
        } catch {
        }
    }
    
    func updateCustomer(item: Supplier, name: String, website: String, indexPath: IndexPath) {
        item.name = name
        item.website = website
        do {
            try context.save()
        } catch {
        }
    }

    @objc func addAction() {
        var firstNametextField = UITextField()
        
        var secondNametextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Supply", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newSupply = Supplier(context: self.context)
            newSupply.name = firstNametextField.text!
            newSupply.website = secondNametextField.text!
            self.supplier.append(newSupply)
            self.saveCustomer()
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            firstNametextField = field
            firstNametextField.placeholder = "Add Name"
        }
        alert.addTextField { (field) in
            secondNametextField = field
            secondNametextField.placeholder = "Add Website"
        }
        present(alert, animated: true, completion: nil)
    }
    
    func updateAction(indexPath: IndexPath) {
        let model = supplier[indexPath.row]
        let alertController = UIAlertController(title:"Update", message:"Update Your Supply", preferredStyle:.alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        alertController.addTextField{(textField) in
            textField.text = model.name
        }
        alertController.addTextField{(textField) in
            textField.text = model.website
        }
        let updateAction = UIAlertAction(title: "Update", style:.default){(_) in
            let name = alertController.textFields?[0].text
            let website =  alertController.textFields?[1].text
            self.updateCustomer(item: model, name: name ?? "", website: website ?? "", indexPath: indexPath)
            self.loadSupplies()
        }
        alertController.addAction(updateAction)
        present (alertController, animated:true, completion: nil)
    }
}

extension SuppliersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supplier.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let name = supplier[indexPath.row].name ?? ""
        let website = supplier[indexPath.row].website ?? ""
        cell.textLabel?.text = "Supplier Name:  \(name)"
        cell.detailTextLabel?.text = "Supplier WebSite:  \(website)"
        return cell
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        passedSupplier = supplier[indexPath.row]
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PartsViewController.instaintiate(on: .mainView)
        vc.passedSupplier = passedSupplier
        navigationController?.pushViewController(vc, animated: true)
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
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let item = supplier[indexPath.row]
            deleteCustomer(item: item)
            loadSupplies()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

