//
//  VC.swift
//  Lab
//
//  Created by Jawaher🌻 on 19/05/1443 AH.
//
import UIKit
import CoreData
var selectedIndex = -1
class CustomersVC: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController<Customer>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 0.8457269349, green: 0.9060993338, blue: 1, alpha: 1)
        tableView.register(CustomerCell.self, forCellReuseIdentifier: CustomerCell.identifire)
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
            NSSortDescriptor(key: "firstname", ascending: false),
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
//        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "123")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerCell
        let customer = fetchedResultsController?.fetchedObjects?[indexPath.row]
        
        cell.nLable.text = "First Name: \(customer?.firstname ?? "")"
        cell.wLable.text = "Last Name:\(customer?.lastName ?? "")"
        cell.pLable.text = "Phone:\(customer?.phone ?? "")"
        cell.aLable.text = "Address:\(customer?.address ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let customer = fetchedResultsController?.fetchedObjects?[indexPath.row] else {
            return 
        }
        
        let newVC = OrderVC()
        newVC.customer = customer
        newVC.title = fetchedResultsController?.fetchedObjects?[indexPath.row].firstname
        let navController = UINavigationController(rootViewController: newVC)
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
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



class CustomerCell: UITableViewCell {
    static let identifire = "CustomerCell"
    
    let nLable: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = ""
        label.font = label.font.withSize(19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let wLable: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = ""
        label.font = label.font.withSize(19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let pLable: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = ""
        label.font = label.font.withSize(19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let aLable: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = ""
        label.font = label.font.withSize(19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        self.addSubview(nLable)
        self.addSubview(wLable)
        self.addSubview(pLable)
        self.addSubview(aLable)
        
        NSLayoutConstraint.activate([
            nLable.topAnchor.constraint(equalTo: self.topAnchor),
            nLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 20),
            nLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            
            wLable.topAnchor.constraint(equalTo: nLable.bottomAnchor, constant: 27),
            wLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10),
            wLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            
            pLable.topAnchor.constraint(equalTo: wLable.bottomAnchor, constant: 27),
            pLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10),
            pLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            
            aLable.topAnchor.constraint(equalTo: pLable.bottomAnchor, constant: 27),
            aLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10),
            aLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
        ])
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
