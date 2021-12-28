//
//  LifeTimeViewController.swift
//  CoreDataTask
//
//  Created by Amal on 21/05/1443 AH.


import UIKit
import CoreData

class LifeTimeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var lifeTime = [Lifetime]()
    var passedLifeTime: Lifetime?
    var order: Orders?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfig()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadOrders()
    }
    func tableViewConfig() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    //MARK: - CRUD
    func loadOrders(with request: NSFetchRequest<Lifetime> = Lifetime.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentOrder.shippingPriority MATCHES %@", order!.shippingPriority!)
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        do {
            lifeTime = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        self.tableView.reloadData()
    }
    func deleteOrders(item: Lifetime) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            //
        }
    }
    func updateLifeTimeData(item: Lifetime, quantity: String, releaseDate: String, returnFlag: String, shipInstructions: String, shopDate: String, indexPath: IndexPath) {
        item.quantity = quantity
        item.releaseDate = releaseDate
        item.returnFlag = returnFlag
        item.shipInstructions = shipInstructions
        item.shopDate = shopDate
        do {
            try context.save()
        } catch {
            //
        }
    }
    //MARK: - Actions
    func updateAction(indexPath: IndexPath) {
        let model = lifeTime[indexPath.row]
        let alertController = UIAlertController(title:"Update", message:"Update Your OrderLifeTime", preferredStyle:.alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        alertController.addTextField{(textField) in
            textField.text = model.quantity
        }
        alertController.addTextField{(textField) in
            textField.text = model.releaseDate
        }
        alertController.addTextField{(textField) in
            textField.text = model.returnFlag
        }
        alertController.addTextField{(textField) in
            textField.text = model.shipInstructions
        }
        alertController.addTextField{(textField) in
            textField.text = model.shopDate
        }
        let updateAction = UIAlertAction(title: "Update", style:.default){(_) in
            let quantity = alertController.textFields?[0].text
            let releaseDate =  alertController.textFields?[1].text
            let returnFlag =  alertController.textFields?[2].text
            let shipInstructions =  alertController.textFields?[3].text
            let shopDate =  alertController.textFields?[4].text
            self.updateLifeTimeData(item: model, quantity: quantity ?? "", releaseDate: releaseDate ?? "", returnFlag: returnFlag ?? "", shipInstructions: shipInstructions ?? "", shopDate: shopDate ?? "", indexPath: indexPath)
            self.loadOrders()
        }
        alertController.addAction(updateAction)
        present (alertController, animated:true, completion: nil)
    }
}
//MARK: - TableView
extension LifeTimeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lifeTime.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LifeTimeCell
        let model = lifeTime[indexPath.row]
        cell.firstLabel.text = "Quantity: \(model.quantity ?? "")"
        cell.secondLabel.text = "Release Date: \(model.releaseDate ?? "")"
        cell.thirdLabel.text = "Return Flag: \(model.returnFlag ?? ""))"
        cell.fourthLabel.text = "Ship Instructions: \(model.shipInstructions ?? ""))"
        cell.fifthLabel.text = "Shop Date: \(model.shopDate ?? ""))"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
        }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                tableView.beginUpdates()
                let item = lifeTime[indexPath.row]
                deleteOrders(item: item)
                loadOrders()
                navigationController?.popViewController(animated: true)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
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
}
//MARK: - Cell
class LifeTimeCell: UITableViewCell{
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
}
