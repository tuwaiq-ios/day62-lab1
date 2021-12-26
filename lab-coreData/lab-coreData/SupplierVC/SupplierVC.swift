//
//  SupplierVC.swift
//  lab-coreData
//
//  Created by  HANAN ASIRI on 21/05/1443 AH.
//
import UIKit
import CoreData


class SupplierVC : UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<Supplier>?
    
    lazy var tableView1: UITableView = {
        let tablaView = UITableView()
        tablaView.translatesAutoresizingMaskIntoConstraints = false
        tablaView.delegate = self
        tablaView.dataSource = self
        tablaView.register(SupplierCell.self, forCellReuseIdentifier: SupplierCell.identifire)
        tablaView.backgroundColor = .white
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
        return 50
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
        label.textColor = .gray
        label.text = ""
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let websiteLable: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = ""
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        self.addSubview(nameLable)
        self.addSubview(websiteLable)
        
        NSLayoutConstraint.activate([
            nameLable.topAnchor.constraint(equalTo: self.topAnchor),
            //            nameLable.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            nameLable.rightAnchor.constraint(equalTo: self.rightAnchor),
            nameLable.leftAnchor.constraint(equalTo: self.leftAnchor , constant: 20),
            
            websiteLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 10),
            //            websiteLable.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            websiteLable.rightAnchor.constraint(equalTo: self.rightAnchor),
            websiteLable.leftAnchor.constraint(equalTo: self.leftAnchor , constant: 20),
        ])
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
