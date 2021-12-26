//
//  NewSupplier.swift
//  lab-coreData
//
//  Created by  HANAN ASIRI on 21/05/1443 AH.
//

import UIKit

class NewSupplier: UIViewController, UITextFieldDelegate {
    
    
    var data: Supplier?
    
    lazy var contentTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Add Name "
        tf.delegate = self
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.cornerRadius = 15
       
        return tf
    }()
    
    lazy var contentTF2: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Add Website"
        tf.delegate = self
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.cornerRadius = 15
        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title =  NSLocalizedString("Add new supplier", comment:"")
        view.backgroundColor = .white
       
        view.backgroundColor = .white
        view.addSubview(contentTF)
        view.addSubview(contentTF2)
      
        NSLayoutConstraint.activate([
            contentTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            contentTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            contentTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            contentTF.heightAnchor.constraint(equalToConstant: 50),
            
            
            
            contentTF2.topAnchor.constraint(equalTo: view.topAnchor, constant: 190),
            contentTF2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            contentTF2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            contentTF2.heightAnchor.constraint(equalToConstant: 50),
        
        ])
        contentTF.text = data?.name
        contentTF2.text = data?.website?.absoluteString
    
}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentTF.resignFirstResponder()
        contentTF2.resignFirstResponder()
        
        let supplier = Supplier(
            context: DataService.shared.viewContext
        )
        supplier.name = contentTF.text ?? ""
        supplier.website = URL(string: contentTF2.text ?? "")
        
        DataService.shared.saveContext()
        
        return true
    }
}

