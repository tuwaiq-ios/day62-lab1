//
//  OrdersVC.swift
//  coredetajob1
//
//  Created by Maram Al shahrani on 19/05/1443 AH.
//

import Foundation
import CoreData
import UIKit


class OrdersVC: UITableViewController, NSFetchedResultsControllerDelegate {

    var customer: Customer?
    
    var fetchedResultsController: NSFetchedResultsController<Order>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .done,
            target: self,
            action: #selector(addOrder)
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
        if customer == nil {
            return
        }
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "totalPrice", ascending: false),
        ]
        fetchRequest.predicate = NSPredicate(format: "customer == %@", customer!)
        
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
    
    @objc func addOrder() {
        let order = Order(
            context: DataService.shared.viewContext
        )
        order.customer = customer
        order.totalPrice = 100.0
        order.status = "pending"
        order.orrderDate = Date()
        order.shippingPriority = Int16(Int.random(in: 0...5))

        let lifetime = Lifetime(
            context: DataService.shared.viewContext
        )
        lifetime.quantity = 4
        lifetime.returnFlag = false
        lifetime.shipDate = Date()
        lifetime.receiptDate = Date()
        lifetime.shipInstructions = "Instructions \(Int.random(in: 0...5))"

        order.lifetime = lifetime
        
        DataService.shared.saveContext()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
    }
}

extension OrdersVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let orders = fetchedResultsController?.fetchedObjects else { return 0 }
        
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        
        let order = fetchedResultsController?.fetchedObjects?[indexPath.row]
        cell.textLabel?.text = "total price\(order?.totalPrice)"
        cell.detailTextLabel?.text = order?.status
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let order = fetchedResultsController?.fetchedObjects?[indexPath.row] else {
            return
        }
        let partVC = PartVC()
        partVC.order = order
        let navController = UINavigationController(rootViewController: partVC)
        present(navController, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(
                    style: .destructive,
                    title: "Delete",
                    handler: { _, _, _ in
                        guard let order = self.fetchedResultsController?.fetchedObjects?[indexPath.row] else {
                            return
                        }
                        DataService.shared.viewContext.delete(order)
                        DataService.shared.saveContext()
                    }
                )
            ]
        )
    }
}
