//
//  TabVC.swift
//  test core
//
//  Created by dmdm on 26/12/2021.
//
import Foundation
import UIKit

    class tabViewController: UITabBarController {
       
        
      fileprivate func createNavController(for rootViewController: UIViewController,
                               title: String,
                               image: UIImage) -> UIViewController {
          
          let navController = UINavigationController(rootViewController: rootViewController)
          
          navController.tabBarItem.title = title
          navController.tabBarItem.image = image
          navController.navigationBar.prefersLargeTitles = true
          rootViewController.navigationItem.title = title
          navController.navigationBar.backgroundColor = .quaternarySystemFill
          
          return navController
        }
        
      func setupVCs() {
          
         viewControllers = [

          
            createNavController(for:CustomersVC(), title: NSLocalizedString("Customer", comment: ""), image: UIImage(systemName: "person")!),
            
           createNavController(for:SupplierVc(), title: NSLocalizedString("Supplier", comment: ""), image: UIImage(systemName: "person")!),
         ]
       }
        
      override func viewDidLoad() {
          
        super.viewDidLoad()
          setupVCs()
     
          view.backgroundColor = UIColor.gray
           
      }
       
    }
