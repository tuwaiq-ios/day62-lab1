//
//  Customer.swift
//  Firstcore
//  Created by dmdm on 26/12/2021.



import UIKit
import CoreData
var selectedIndex = -1
class CustomersVC: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController<Customer>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .done,
            target: self,
            action: #selector(add)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Customer> = Customer.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "firstName", ascending: false),
//            NSSortDescriptor(key: "lastName", ascending: false),
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataService.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        } catch {
            fatalError("The fetch could not be performd: \(error.localizedDescription)")
        }
    }
    

    @objc func add() {
        let newVC = NewCustomer()
        present(newVC, animated: true, completion: nil)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
    }
}

extension CustomersVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let customers = fetchedResultsController?.fetchedObjects else { return 0 }
        
        return customers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "123")
        
        let customer = fetchedResultsController?.fetchedObjects?[indexPath.row]
        
        cell.textLabel?.text = "First Name: \(customer?.firstName ?? "")"
        cell.detailTextLabel?.text = "Last Name:\(customer?.lastName ?? "")"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let customer = fetchedResultsController?.fetchedObjects?[indexPath.row] else {
            return
        }
        
        let newVC = OrderVC()
        newVC.customer = customer
        newVC.title = fetchedResultsController?.fetchedObjects?[indexPath.row].firstName
        let navController = UINavigationController(rootViewController: newVC)
        present(navController, animated: true, completion: nil)
    }
    

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(
                    style: .destructive,
                    title: "Delete",
                    handler: { _, _, _ in
                        guard let customer = self.fetchedResultsController?.fetchedObjects?[indexPath.row] else {
                            return
                        }
                        DataService.shared.viewContext.delete(customer)
                        DataService.shared.saveContext()
                    }
                )
            ]
        )
    }
}

