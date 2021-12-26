//
//  PartVC.swift
//  coredetajob1
//
//  Created by Maram Al shahrani on 19/05/1443 AH.
//

import Foundation
import CoreData
import UIKit


class PartVC: UITableViewController, NSFetchedResultsControllerDelegate {

    var order: Order?
    var fetchedResultsController: NSFetchedResultsController<Part>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .done,
            target: self,
            action: #selector(addPart)
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
        if order == nil {
            return
        }
        let fetchRequest: NSFetchRequest<Part> = Part.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: false),
        ]
        fetchRequest.predicate = NSPredicate(format: "order == %@", order!)
        
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
    
    @objc func addPart() {
        let part = Part(
            context: DataService.shared.viewContext
        )
        part.order = order
        part.name = "name \(Int.random(in: 0...5))"
        part.size = 50.0
        part.retailPrice = 90.0
        part.image = UIImage().pngData()

        let supplier = Supplier(
            context: DataService.shared.viewContext
        )
        supplier.name = "name \(Int.random(in: 0...5))"
        supplier.website = URL.init(string: "www.google.com")
        
        supplier.trackable = order?.customer?.trackable
        part.supplier = supplier
        
        DataService.shared.saveContext()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
    }
}

extension PartVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let part = fetchedResultsController?.fetchedObjects else { return 0 }
        
        return part.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        
        let part = fetchedResultsController?.fetchedObjects?[indexPath.row]
        cell.textLabel?.text = "\(part?.name)"
        cell.detailTextLabel?.text = "\(part?.size)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let part = fetchedResultsController?.fetchedObjects?[indexPath.row] else {
            return
        }
        part.name = "name"
        DataService.shared.saveContext()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(
                    style: .destructive,
                    title: "Delete",
                    handler: { _, _, _ in
                        guard let part = self.fetchedResultsController?.fetchedObjects?[indexPath.row] else {
                            return
                        }
                        DataService.shared.viewContext.delete(part)
                        DataService.shared.saveContext()
                    }
                )
            ]
        )
    }
}
