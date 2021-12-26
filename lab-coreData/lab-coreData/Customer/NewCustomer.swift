//
//  NewCustomer.swift
//  lab-coreData
//
//  Created by  HANAN ASIRI on 21/05/1443 AH.
//
import UIKit


class NewCustomer: UIViewController, UITextFieldDelegate {

    var a : Customer?
    lazy var TF1: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = NSLocalizedString("", comment:"  ")
        tf.backgroundColor = .white
        tf.textAlignment = .right
        tf.delegate = self
        tf.layer.cornerRadius = 15
        return tf
    }()
    
    lazy var TF2: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = NSLocalizedString("", comment:"   ")
        tf.backgroundColor = .white
        tf.textAlignment = .right
        tf.delegate = self
        tf.layer.cornerRadius = 15
        return tf
    }()
    
    lazy var addButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(add), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle(NSLocalizedString("add", comment:""), for: .normal)
        b.titleLabel?.font = UIFont(name: "Avenir-Light", size: 27.0)
        b.layer.cornerRadius = 15
        b.backgroundColor = UIColor(red: (87/255), green: (107/255), blue: (96/255), alpha: 1)
        return b
    }()
    
    public let LabelN: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 15)
        label.textColor = UIColor(named: "Color2")
        label.text = NSLocalizedString("First Name", comment:"")
        label.textAlignment = .left
    
        return label
    }()
    public let LabelID: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 15)
        label.textColor = UIColor(named: "Color2")
        label.text = NSLocalizedString(" Last Name ", comment:"")
        label.textAlignment = .left
        return label
    }()
    
    
    
 
    
    
    @objc func add() {
    
        let s = Customer(
            context: DataService.shared.viewContext
        )
        s.firstName = TF1.text ?? ""
        s.lastName = TF2.text ?? ""
        
        DataService.shared.saveContext()
    }
    
  
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        
        
        TF1.text = a?.firstName
        TF2.text = a?.lastName
        view.addSubview(LabelN)
        view.addSubview(LabelID)
        view.addSubview(addButton)
        view.addSubview(TF1)
        
    
        
        LabelN.frame = CGRect(x: 50,
                              y: 70,
                              width: 110,
                              height:130)
        
        LabelID.frame = CGRect(x: 40,
                               y: 150,
                               width: 140,
                               height:130)
        NSLayoutConstraint.activate([
            TF1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            TF1.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            TF1.heightAnchor.constraint(equalToConstant: 48),
            TF1.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48)
        ])
        
        view.addSubview(TF2)
        NSLayoutConstraint.activate([
            TF2.topAnchor.constraint(equalTo: view.topAnchor, constant: 240),
            TF2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            TF2.heightAnchor.constraint(equalToConstant: 48),
            TF2.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48)
        ])
        NSLayoutConstraint.activate([
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80),
            addButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
   
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        dismiss(animated: true, completion: nil)
        return true
    }
    

    
}
