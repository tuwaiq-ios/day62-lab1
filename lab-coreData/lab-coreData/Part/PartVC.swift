//
//  PartVC.swift
//  lab-coreData
//
//  Created by  HANAN ASIRI on 19/05/1443 AH.
//

import UIKit


class PartVC: UIViewController, UITextFieldDelegate {
    var supplier: Supplier?
    
    lazy var TF1: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = NSLocalizedString("", comment:"  ")
        tf.backgroundColor = .white
        tf.textAlignment = .right
        tf.delegate = self
        tf.layer.cornerRadius = 20
        return tf
    }()
    
    lazy var TF2: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = NSLocalizedString("", comment:"   ")
        tf.backgroundColor = .white
        tf.textAlignment = .right
        tf.delegate = self
        tf.layer.cornerRadius = 20
        return tf
    }()
    lazy var TF3: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = NSLocalizedString("", comment:"   ")
        tf.backgroundColor = .white
        tf.textAlignment = .right
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
        b.backgroundColor = UIColor(red: (87/255), green: (107/255), blue: (96/255), alpha: 1)
        return b
    }()
    
    public let LabelN: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = UIColor(named: "Color2")
        label.text = NSLocalizedString("Name:", comment:" ")
        label.textAlignment = .left
    
        return label
    }()
    public let LabelID: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = UIColor(named: "Color2")
        label.text = NSLocalizedString(" Retail Price: ", comment:"")
        label.textAlignment = .left
        return label
    }()
    public let LabelI: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = UIColor(named: "Color2")
        label.text = NSLocalizedString(" Size: ", comment:"")
        label.textAlignment = .left
        return label
    }()
    
    
 
    
    
    @objc func add() {
      

        let s = Part(
            context: DataService.shared.viewContext
        )
        s.name = TF1.text ?? ""
        s.retailPrice = Double(TF2.text ?? "")!
        s.size = Double(TF2.text ?? "")!
        
        DataService.shared.saveContext()
    }
    
  
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        
        
        view.addSubview(LabelN)
        view.addSubview(LabelID)
        view.addSubview(LabelI)
        view.addSubview(addButton)
        view.addSubview(TF1)
        
    
        
        LabelN.frame = CGRect(x: 10,
                              y: 16,
                              width: 110,
                              height:130)
        
        LabelID.frame = CGRect(x: 10,
                               y: 115,
                               width: 140,
                               height:130)
        LabelI.frame = CGRect(x: 10,
                               y: 218,
                               width: 140,
                               height:130)
        NSLayoutConstraint.activate([
            TF1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            TF1.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            TF1.heightAnchor.constraint(equalToConstant: 48),
            TF1.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48)
        ])
        
        view.addSubview(TF2)
        NSLayoutConstraint.activate([
            TF2.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            TF2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            TF2.heightAnchor.constraint(equalToConstant: 48),
            TF2.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48)
        ])
        view.addSubview(TF3)
        NSLayoutConstraint.activate([
            TF3.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            TF3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            TF3.heightAnchor.constraint(equalToConstant: 48),
            TF3.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48)
        ])
        NSLayoutConstraint.activate([
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80),
            addButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300),
            addButton.widthAnchor.constraint(equalToConstant: 400),
            addButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
   
     
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        dismiss(animated: true, completion: nil)
        return true
    }
    

    
}

