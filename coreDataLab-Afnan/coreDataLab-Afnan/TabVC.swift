//
//  TabVC.swift
//  coreDataLab-Afnan
//
//  Created by Fno Khalid on 19/05/1443 AH.
//

import UIKit

import UIKit

    class TabVC: UITabBarController {
       
        
      fileprivate func createNavController(for rootViewController: UIViewController,
                               title: String,
                               image: UIImage) -> UIViewController {
          
          let navController = UINavigationController(rootViewController: rootViewController)
          
          navController.tabBarItem.title = title
          navController.tabBarItem.image = image
          navController.navigationBar.prefersLargeTitles = true
          rootViewController.navigationItem.title = title
          navController.navigationBar.backgroundColor = .quaternarySystemFill
          navController.toolbar.tintColor = .white
          
    
          return navController
        }
        
      func setupVCs() {
          
         viewControllers = [

          
            createNavController(for: CustomersVC(), title: NSLocalizedString("Customer", comment: ""), image: UIImage(systemName: "person.fill")!),
            
           createNavController(for: SupplierVc(), title: NSLocalizedString("Supplier", comment: ""), image: UIImage(systemName: "shippingbox.circle.fill")!),
         ]
       }
        
      override func viewDidLoad() {
        super.viewDidLoad()
          setupVCs()
          view.backgroundColor = UIColor.white
          tabBar.backgroundColor = UIColor.white
           
      }
       
    }
