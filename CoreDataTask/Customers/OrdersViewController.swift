//
//  OrdersViewController.swift
//  CoreDataTask
//
//  Created by Amal on 21/05/1443 AH.
//

import UIKit
import CoreData

class OrdersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var orders = [Orders]()
    var passedCustomer: Customers?
    var passedOrder: Orders?
    var lifeTime = [Lifetime]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfig()
        addButton()
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
    func loadOrders(with request: NSFetchRequest<Orders> = Orders.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCustomer.firstName MATCHES %@", passedCustomer!.firstName!)
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        do {
            orders = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        self.tableView.reloadData()
    }
    func deleteOrders(item: Orders) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            //
        }
    }
    func updateOrder(item: Orders, shippingPriority: String, orderDate: String, orderPrice: String, orderStatus: String, indexPath: IndexPath) {
        item.shippingPriority = shippingPriority
        item.orderDate = orderDate
        item.orderPrice = orderPrice
        item.status = orderStatus
        do {
            try context.save()
        } catch {
            //
        }
    }
    //MARK: - Actions
    @objc func addOrderAction() {
        var firstNametextField = UITextField()
        var secondNametextField = UITextField()
        var thirdNametextField = UITextField()
        var fourthNametextField = UITextField()
        let alert = UIAlertController(title: "Add New Order", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        let action = UIAlertAction(title: "Add Order", style: .default) { (action) in
            let newOrder = Orders(context: self.context)
            newOrder.orderDate = firstNametextField.text!
            newOrder.orderPrice = secondNametextField.text!
            newOrder.shippingPriority = thirdNametextField.text!
            newOrder.status = fourthNametextField.text!
            newOrder.parentCustomer = self.passedCustomer
            self.orders.append(newOrder)
            self.saveOrders()
        }
        alert.addTextField { (field) in
            firstNametextField = field
            firstNametextField.placeholder = "Add Order Date"
        }
        alert.addTextField { (field) in
            secondNametextField = field
            secondNametextField.placeholder = "Add Order Price"
        }
        alert.addTextField { (field) in
            thirdNametextField = field
            thirdNametextField.placeholder = "Add Order Shopping Priority"
        }
        alert.addTextField { (field) in
            fourthNametextField = field
            fourthNametextField.placeholder = "Add Order Status"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func addLifeTimeAction(indexPath: IndexPath) {
        var firstNametextField = UITextField()
        var secondNametextField = UITextField()
        var thirdNametextField = UITextField()
        var fourthNametextField = UITextField()
        var fifthNametextField = UITextField()
        let alert = UIAlertController(title: "Add LifeTime To Order", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        let action = UIAlertAction(title: "Add LifeTime For Order", style: .default) { (action) in
            let newOrder = Lifetime(context: self.context)
            newOrder.quantity = firstNametextField.text!
            newOrder.releaseDate = secondNametextField.text!
            newOrder.returnFlag = thirdNametextField.text!
            newOrder.shipInstructions = fourthNametextField.text!
            newOrder.shopDate = fifthNametextField.text!
            newOrder.parentOrder = self.passedOrder
            self.lifeTime.append(newOrder)
            self.saveOrders()
            let vc = LifeTimeViewController.instaintiate(on: .mainView)
            vc.order = self.passedOrder
            vc.lifeTime = self.lifeTime
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addTextField { (field) in
            firstNametextField = field
            firstNametextField.placeholder = "Add Order Quantity"
        }
        alert.addTextField { (field) in
            secondNametextField = field
            secondNametextField.placeholder = "Add Order ReleaseDate"
        }
        alert.addTextField { (field) in
            thirdNametextField = field
            thirdNametextField.placeholder = "Add Order ReturnFlag"
        }
        alert.addTextField { (field) in
            fourthNametextField = field
            fourthNametextField.placeholder = "Add Order ShipInstructions"
        }
        alert.addTextField { (field) in
            fifthNametextField = field
            fifthNametextField.placeholder = "Add Order ShopDate"
        }
        alert.addAction(action)
        if passedOrder?.lifeTime == nil {
            present(alert, animated: true, completion: nil)
        } else {
            let vc = LifeTimeViewController.instaintiate(on: .mainView)
            vc.order = self.passedOrder
            vc.lifeTime = self.lifeTime
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func updateAction(indexPath: IndexPath) {
        let model = orders[indexPath.row]
        let alertController = UIAlertController(title:"Update", message:"Update Your Order", preferredStyle:.alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        alertController.addTextField{(textField) in
            textField.text = model.orderDate
        }
        alertController.addTextField{(textField) in
            textField.text = model.orderPrice
        }
        alertController.addTextField{(textField) in
            textField.text = model.shippingPriority
        }
        alertController.addTextField{(textField) in
            textField.text = model.status
        }
        let updateAction = UIAlertAction(title: "Update", style:.default){(_) in
            let orderDate = alertController.textFields?[0].text
            let orderPrice =  alertController.textFields?[1].text
            let shippingPriority =  alertController.textFields?[2].text
            let status =  alertController.textFields?[3].text
            self.updateOrder(item: model, shippingPriority: shippingPriority ?? "", orderDate: orderDate ?? "", orderPrice: orderPrice ?? "", orderStatus: status ?? "", indexPath: indexPath)
            self.loadOrders()
        }
        alertController.addAction(updateAction)
        present (alertController, animated:true, completion: nil)
    }
}
//MARK: - TableView
extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrdersCell
        let model = orders[indexPath.row]
        let shippingPriority = model.shippingPriority
        let orderDate = model.orderDate
        let orderPrice = model.orderPrice
        let status = model.status
        cell.firstLabel.text = "Shopping Priority: \(shippingPriority ?? "")"
        cell.secondLabel.text = "Order Date: \(orderDate ?? "")"
        cell.thirdLabel.text = "Order Price: \(orderPrice ?? "")"
        cell.fourthLabel.text = "Status: \(status ?? "")"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        addLifeTimeAction(indexPath: indexPath)
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
        passedOrder = orders[indexPath.row]
        return indexPath
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
        }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                tableView.beginUpdates()
                let item = orders[indexPath.row]
                deleteOrders(item: item)
                loadOrders()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
    }
}
//MARK: - Cell
class OrdersCell: UITableViewCell{
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
}
