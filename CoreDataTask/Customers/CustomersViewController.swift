//
//  CustomersViewController.swift
//  CoreDataTask
//
//  Created by Amal on 21/05/1443 AH.
//

import UIKit
import CoreData

class CustomersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var customers = [Customers]()
    var passedCustomers: Customers?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfig()
        addButton()
        loadCustomers()
    }
    func addButton() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        navigationItem.rightBarButtonItems = [add]
    }
    func tableViewConfig() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    //MARK: - CRUD
    func saveCustomer() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    func loadCustomers() {
        let request : NSFetchRequest<Customers> = Customers.fetchRequest()
        do{
            customers = try context.fetch(request)
        } catch {
            print("Error loading customers \(error)")
        }
        tableView.reloadData()
    }
    func deleteCustomer(item: Customers) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            //
        }
    }
    func updateCustomer(item: Customers, newFirstName: String, newLastName: String, indexPath: IndexPath) {
        item.firstName = newFirstName
        item.lastName = newLastName
        do {
            try context.save()
        } catch {
            //
        }
    }
    //MARK: - Actions
    @objc func addAction() {
        var firstNametextField = UITextField()
        var secondNametextField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCustomer = Customers(context: self.context)
            newCustomer.firstName = firstNametextField.text!
            newCustomer.lastName = secondNametextField.text!
            self.customers.append(newCustomer)
            self.saveCustomer()
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            firstNametextField = field
            firstNametextField.placeholder = "Add First Name"
        }
        alert.addTextField { (field) in
            secondNametextField = field
            secondNametextField.placeholder = "Add Second Name"
        }
        present(alert, animated: true, completion: nil)
    }
    func updateAction(indexPath: IndexPath) {
        let model = customers[indexPath.row]
        let alertController = UIAlertController(title:"Update", message:"Update Your Name", preferredStyle:.alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        alertController.addTextField{(textField) in
            textField.text = model.firstName
        }
        alertController.addTextField{(textField) in
            textField.text = model.lastName
        }
        let updateAction = UIAlertAction(title: "Update", style:.default){(_) in
            let firstName = alertController.textFields?[0].text
            let secondName =  alertController.textFields?[1].text
            self.updateCustomer(item: model, newFirstName: firstName ?? "", newLastName: secondName ?? "", indexPath: indexPath)
            self.loadCustomers()
        }
        alertController.addAction(updateAction)
        present (alertController, animated:true, completion: nil)
    }
}
//MARK: - TableView
extension CustomersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let firstName = customers[indexPath.row].firstName!
        let lastName = customers[indexPath.row].lastName!
        cell.textLabel?.text = "Customer Name:  \(firstName) " + lastName
        return cell
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        passedCustomers = customers[indexPath.row]
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = OrdersViewController.instaintiate(on: .mainView)
        vc.passedCustomer = passedCustomers
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //context Menu
    
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
            let item = customers[indexPath.row]
            deleteCustomer(item: item)
            loadCustomers()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

