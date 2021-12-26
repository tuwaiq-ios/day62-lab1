//
//  ViewController.swift
//  coreDataLab-Afnan
//
//  Created by Fno Khalid on 15/05/1443 AH.
//



import UIKit
import CoreData

var selectedIndex = -1

class CustomersVC: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController<Customer>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9376022816, green: 0.9575132728, blue: 0.8224243522, alpha: 1)
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
            NSSortDescriptor(key: "firsetName", ascending: false),
            NSSortDescriptor(key: "lastName", ascending: false),
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}


extension CustomersVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let customers = fetchedResultsController?.fetchedObjects else { return 0 }
        
        return customers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerCell
        
        let data = fetchedResultsController?.fetchedObjects?[indexPath.row]
        cell.firstLabel.text = data?.firsetName
        cell.lastLabel.text = data?.lastName
        cell.phoneLable.text = data?.phone
        cell.addressLable.text = data?.address

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let customer = fetchedResultsController?.fetchedObjects?[indexPath.row] else {
            return
        }
        
        let newVC = OrderVC()
        newVC.customer = customer
        newVC.title = fetchedResultsController?.fetchedObjects?[indexPath.row].firsetName
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

class CustomerCell: UITableViewCell {
    static let identifire = "CustomerCell"
    
    let firstLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = ""
        label.font = label.font.withSize(19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lastLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = ""
        label.font = label.font.withSize(19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let phoneLable: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = ""
        label.font = label.font.withSize(19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressLable: UILabel = {
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
        
        self.addSubview(firstLabel)
        self.addSubview(lastLabel)
        self.addSubview(phoneLable)
        self.addSubview(addressLable)
        
        NSLayoutConstraint.activate([
            firstLabel.topAnchor.constraint(equalTo: self.topAnchor),
            firstLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 20),
            firstLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            
            lastLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 27),
            lastLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10),
            lastLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            
            phoneLable.topAnchor.constraint(equalTo: lastLabel.bottomAnchor, constant: 27),
            phoneLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 20),
            phoneLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            
            addressLable.topAnchor.constraint(equalTo: phoneLable.bottomAnchor, constant: 27),
            addressLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10),
            addressLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
        ])
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

