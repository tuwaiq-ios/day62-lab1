//
//  NewCustomer.swift
//  Lab
//
//  Created by Jawaher🌻 on 19/05/1443 AH.
//

import UIKit


class NewCustomer: UIViewController, UITextFieldDelegate {

   
    var a : Customer?
    
    lazy var TF1: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = NSLocalizedString("", comment:"  ")
        tf.backgroundColor = .white
        tf.textAlignment = .left
        tf.delegate = self
        tf.layer.cornerRadius = 20
        return tf
    }()
    
    lazy var TF2: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = NSLocalizedString("", comment:"   ")
        tf.backgroundColor = .white
        tf.textAlignment = .left
        tf.delegate = self
        tf.layer.cornerRadius = 20
        return tf
    }()
    
    lazy var TF3: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = NSLocalizedString("", comment:"  ")
        tf.backgroundColor = .white
        tf.textAlignment = .left
        tf.delegate = self
        tf.layer.cornerRadius = 20
        return tf
    }()
    
    lazy var TF4: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = NSLocalizedString("", comment:"   ")
        tf.backgroundColor = .white
        tf.textAlignment = .left
        tf.delegate = self
        tf.layer.cornerRadius = 20
        return tf
    }()
    
    lazy var addButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(add), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle(NSLocalizedString("add", comment:""), for: .normal)
        b.titleLabel?.font = UIFont(name: "Avenir-Light", size: 27.0)
        b.layer.cornerRadius = 25
        b.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        return b
    }()
    
    public let LabelN: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = UIColor(named: "Color2")
        label.text = NSLocalizedString("First Name", comment:" ")
        label.textAlignment = .left
    
        return label
    }()
    public let LabelID: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = UIColor(named: "Color2")
        label.text = NSLocalizedString("Last Name ", comment:"")
        label.textAlignment = .left
        return label
    }()
    
    public let Labelp: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = UIColor(named: "Color2")
        label.text = NSLocalizedString("Phone", comment:" ")
        label.textAlignment = .left
    
        return label
    }()
    public let Labela: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = UIColor(named: "Color2")
        label.text = NSLocalizedString(" Address ", comment:"")
        label.textAlignment = .left
        return label
    }()
    
 
    
    
    @objc func add() {
      

        let s = Customer(
            context: DataService.shared.viewContext
        )
        s.firstname = TF1.text ?? ""
        s.lastName = TF2.text ?? ""
        s.phone = TF3.text ?? ""
        s.address = TF4.text ?? ""
        
        DataService.shared.saveContext()
    }
    
  
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8594048711, green: 0.9239393971, blue: 1, alpha: 1)
        
        
        TF1.text = a?.firstname
        TF2.text = a?.lastName
  
        view.addSubview(LabelN)
        view.addSubview(LabelID)
        view.addSubview(Labelp)
        view.addSubview(Labela)
        view.addSubview(addButton)
        view.addSubview(TF1)
        
    
        
        LabelN.frame = CGRect(x: 10,
                              y: 70,
                              width: 110,
                              height:130)
        
        LabelID.frame = CGRect(x: 10,
                               y: 150,
                               width: 140,
                               height:130)
        Labelp.frame = CGRect(x: 10,
                              y: 257,
                              width: 110,
                              height:130)
        
        Labela.frame = CGRect(x: 10,
                               y: 370,
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
            TF2.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            TF2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            TF2.heightAnchor.constraint(equalToConstant: 48),
            TF2.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48)
        ])
        
        view.addSubview(TF3)
        NSLayoutConstraint.activate([
            TF3.topAnchor.constraint(equalTo: view.topAnchor, constant: 350),
            TF3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            TF3.heightAnchor.constraint(equalToConstant: 48),
            TF3.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48)
        ])
        view.addSubview(TF4)
        NSLayoutConstraint.activate([
            TF4.topAnchor.constraint(equalTo: view.topAnchor, constant: 450),
            TF4.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            TF4.heightAnchor.constraint(equalToConstant: 48),
            TF4.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48)
        ])
        
        NSLayoutConstraint.activate([
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80),
            addButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            addButton.widthAnchor.constraint(equalToConstant: 400),
            addButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
   
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        dismiss(animated: true, completion: nil)
        return true
    }
    

    
}
