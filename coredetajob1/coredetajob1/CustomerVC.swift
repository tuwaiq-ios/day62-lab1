//
//  CustomerVC.swift
//  coredetajob1
//
//  Created by Kholod Sultan on 19/05/1443 AH.
//

import Foundation
import CoreData
import UIKit


class CustomerVC: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController<Customer>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .done,
            target: self,
            action: #selector(addCustomer)
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
    
    @objc func addCustomer() {
        let customer = Customer(
            context: DataService.shared.viewContext
        )
        customer.firstName = "firstName \(Int.random(in: 0...5))"
        customer.lastName = "lastName \(Int.random(in: 0...5))"
        
        let trackable = Trackable(
            context: DataService.shared.viewContext
        )
        trackable.address = "address \(Int.random(in: 0...5))"
        trackable.phone = "phone \(Int.random(in: 0...5))"
        
        customer.trackable = trackable
        DataService.shared.saveContext()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
    }
}

extension CustomerVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let customers = fetchedResultsController?.fetchedObjects else { return 0 }
        
        return customers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        
        let customer = fetchedResultsController?.fetchedObjects?[indexPath.row]
        cell.textLabel?.text = customer?.firstName
        cell.detailTextLabel?.text = customer?.lastName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let customer = fetchedResultsController?.fetchedObjects?[indexPath.row] else {
            return
        }
        let ordersVC = OrdersVC()
        ordersVC.customer = customer
        let navController = UINavigationController(rootViewController: ordersVC)
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

//
