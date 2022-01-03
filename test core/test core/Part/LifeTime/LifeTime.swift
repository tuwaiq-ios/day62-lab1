//
//  LifeTime.swift
//  test core
//
//  Created by sara saud on 20/05/1443 AH.
//


import UIKit
import CoreData

class LifeTime: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    var lifetime: Order?
    
    
    var fetchedResultsController: NSFetchedResultsController<Lifetime>?
    
    lazy var tableView: UITableView = {
        let tablaView = UITableView()
        tablaView.translatesAutoresizingMaskIntoConstraints = false
        tablaView.delegate = self
        tablaView.dataSource = self
        tablaView.register(Cell2.self, forCellReuseIdentifier: Cell2.identifire)
        tablaView.backgroundColor = .white
        return tablaView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
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
        let fetchRequest: NSFetchRequest<Lifetime> = Lifetime.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "shipInstructions", ascending: false),
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
        let newVC = NewLifeTime()
        present(newVC, animated: true, completion: nil)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
    }
}

extension LifeTime {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let lifetimes = fetchedResultsController?.fetchedObjects else { return 0 }
        
        return lifetimes.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: Cell2.identifire, for: indexPath) as! Cell2

        
        let lifetime = fetchedResultsController?.fetchedObjects?[indexPath.row]
        
         cell.label2.text = "Status: \(lifetime?.shipInstructions ?? "")"
         cell.label3.text = "return flag:\(lifetime!.returnFlag)"
         cell.label4.text = "Ship Date:\(lifetime!.shipDate ?? Date())"
         cell.label5.text = "Recipt Date:\(lifetime!.reciptDate ?? Date())"
         cell.label6.text =  "shipping: \(lifetime!.quantity)"
      

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndex {
            return 370
        }else {
            return 225
        }
    }


     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(
                    style: .destructive,
                    title: "Delete",
                    handler: { _, _, _ in
                        guard let lifetime = self.fetchedResultsController?.fetchedObjects?[indexPath.row] else {
                            return
                        }
                        DataService.shared.viewContext.delete(lifetime)
                        DataService.shared.saveContext()
                    }
                )
            ]
        )
    }
}


class Cell2: UITableViewCell {
    
    static let identifire = "Cell"
    
    public let label2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let label3: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir-Light", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let label4: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Light", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    public let label5: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir-Light", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public let label6: UILabel = {
        let label = UILabel()
//        label.text = "a"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Light", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = #colorLiteral(red: 1, green: 0.9926941103, blue: 0.9993625388, alpha: 1)
        contentView.layer.cornerRadius = 13
        

        self.addSubview(label2)
        self.addSubview(label3)
        self.addSubview(label4)
        self.addSubview(label5)
        self.addSubview(label6)
        
        NSLayoutConstraint.activate([
            label2.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            label2.rightAnchor.constraint(equalTo: self.rightAnchor ),
            label2.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 9),
            
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 10),
            label3.rightAnchor.constraint(equalTo: self.rightAnchor),
            label3.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 9),
            
            label4.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 10),
            label4.rightAnchor.constraint(equalTo: self.rightAnchor),
            label4.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 9),
            
            label6.topAnchor.constraint(equalTo: label4.bottomAnchor, constant: 10),
            label6.rightAnchor.constraint(equalTo: self.rightAnchor),
            label6.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 9),
            
            label5.topAnchor.constraint(equalTo: label6.bottomAnchor, constant: 10),
            label5.rightAnchor.constraint(equalTo: self.rightAnchor),
            label5.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 9),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        
 
        
        
        
    }
    
}
