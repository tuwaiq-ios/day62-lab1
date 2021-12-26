//
//  SupplierVC.swift
//  coreDataLab-Afnan
//
//  Created by Fno Khalid on 19/05/1443 AH.
//

import UIKit
import CoreData


class SupplierVc : UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<Supplier>?
    
    lazy var tableView1: UITableView = {
        let tablaView = UITableView()
        tablaView.translatesAutoresizingMaskIntoConstraints = false
        tablaView.delegate = self
        tablaView.dataSource = self
        tablaView.register(SupplierCell.self, forCellReuseIdentifier: SupplierCell.identifire)
        tablaView.backgroundColor = #colorLiteral(red: 0.9376022816, green: 0.9575132728, blue: 0.8224243522, alpha: 1)
        return tablaView
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierCell", for: indexPath) as! SupplierCell
        
        let data = fetchedResultsController?.fetchedObjects?[indexPath.row]
        cell.nameLable.text = data?.name
        cell.websiteLable.text = data?.website?.absoluteString
        cell.phoneLable.text = data?.phone
        cell.addressLable.text = data?.address
        
        return  cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let fetchSupplier = fetchedResultsController?.fetchedObjects?[indexPath.row] else {
            return
        }
        let partVC = PartVC()
        partVC.supplier = fetchSupplier
        let navController = UINavigationController(rootViewController: partVC)
        present(navController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(
                    style: .destructive,
                    title: "Delete",
                    handler: { _, _, _ in
                        guard let supplier = self.fetchedResultsController?.fetchedObjects?[indexPath.row] else {
                            return
                        }
                        DataService.shared.viewContext.delete(supplier)
                        DataService.shared.saveContext()
                    }
                )
            ]
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8956077695, green: 0.8412560821, blue: 0.7728853822, alpha: 1)
        view.addSubview(tableView1)
        NSLayoutConstraint.activate([
            tableView1.topAnchor.constraint(equalTo: view.topAnchor),
            tableView1.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView1.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView1.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .done,
            target: self,
            action: #selector(addSupplier)
        )
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView1.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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
        let fetchRequest: NSFetchRequest<Supplier> = Supplier.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: false),
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
            tableView1.reloadData()
        } catch {
            fatalError("The fetch could not be performd: \(error.localizedDescription)")
        }
    }
    
    @objc func addSupplier() {
        let vc = NewSupplier()
        self.present(vc, animated: true, completion: nil)
    }
    
}


class SupplierCell: UITableViewCell {
    static let identifire = "SupplierCell"
    
    let nameLable: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = ""
        label.font = label.font.withSize(19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let websiteLable: UILabel = {
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
        
        self.addSubview(nameLable)
        self.addSubview(websiteLable)
        self.addSubview(phoneLable)
        self.addSubview(addressLable)
        
        NSLayoutConstraint.activate([
            nameLable.topAnchor.constraint(equalTo: self.topAnchor),
            nameLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 20),
            nameLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            
            websiteLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 27),
            websiteLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10),
            websiteLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            
            phoneLable.topAnchor.constraint(equalTo: websiteLable.bottomAnchor, constant: 27),
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
