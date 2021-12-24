//
//  TabBarVc.swift
//  LabCoreData
//
//  Created by sara al zhrani on 19/05/1443 AH.
//

import UIKit

    class TabBarVc: UITabBarController {
       
        
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

            createNavController(for: CustomersVC(), title: NSLocalizedString("Customer", comment: ""), image: UIImage(systemName: "star")!),
            
           createNavController(for: SupplierVc(), title: NSLocalizedString("Supplier", comment: ""), image: UIImage(systemName: "person")!),
         ]
       }
        
      override func viewDidLoad() {
          
        super.viewDidLoad()
          setupVCs()
     
          view.backgroundColor = UIColor.gray
           
      }
       
    }

