//
//  NewLifeTime.swift
//  Day62 Lab1(Core Data)
//
//  Created by Fatimah Ayeidh on 23/05/1443 AH.
//

import UIKit


class NewLifeTime: UIViewController, UITextFieldDelegate {

   
    var b : Lifetime?
    lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        dp.datePickerMode = .date
        dp.layer.cornerRadius = 12
        return dp
    }()
    lazy var datePicker2: UIDatePicker = {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.addTarget(self, action: #selector(dateChanged2), for: .valueChanged)
        dp.datePickerMode = .date
        dp.layer.cornerRadius = 12
        return dp
    }()
    
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
        b.backgroundColor = .blue
        return b
    }()
    
    public let LabelN: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = .lightGray
        label.text = NSLocalizedString("Ship Instructions:", comment:" ")
        label.textAlignment = .left
    
        return label
    }()
    public let LabelID: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = .lightGray
        label.text = NSLocalizedString("Return Flag:", comment:"")
        label.textAlignment = .left
        return label
    }()
    public let LabelI: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = .lightGray
        label.text = NSLocalizedString(" Quantity: ", comment:"")
        label.textAlignment = .left
        return label
    }()
    
    
 
    
    
    @objc func add() {
      

        let s = Lifetime(
            context: DataService.shared.viewContext
        )
        s.shipInstructions = TF1.text ?? ""
        s.retunFlag = Bool(TF2.text ?? "") ?? true
        s.shipDate =  datePicker.date
        s.receiptDate =  datePicker2.date
        s.quantity = Int32(TF3.text ?? "") ?? 0
        
        DataService.shared.saveContext()
    }
    
  
    @objc func dateChanged() {
        
        print("New date = \(datePicker.date)")
    }
    @objc func dateChanged2() {

        print("New date = \(datePicker.date)")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        
        TF1.text = b?.shipInstructions
        view.addSubview(LabelN)
        view.addSubview(LabelID)
        view.addSubview(LabelI)
        view.addSubview(addButton)
        view.addSubview(TF1)
        
    
        
        LabelN.frame = CGRect(x: 10,
                              y: 16,
                              width: 200,
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
       
        
   
        view.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: TF3.bottomAnchor, constant: 10),
        
        ])
        view.addSubview(datePicker2)
        NSLayoutConstraint.activate([
            datePicker2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker2.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),

        ])
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: datePicker2.bottomAnchor, constant: 10),
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80),
            addButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80),
            addButton.widthAnchor.constraint(equalToConstant: 400),
            addButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        dismiss(animated: true, completion: nil)
        return true
    }
    

    
}

