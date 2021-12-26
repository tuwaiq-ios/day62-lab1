//
//  TabBarVC.swift
//  lab-coreData
//
//  Created by  HANAN ASIRI on 19/05/1443 AH.
//
import UIKit

class TabVC: UITabBarController {
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)

        navController.tabBarItem.title = title
        navController.tabBarItem.badgeColor = .black
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.accessibilityTextualContext = .messaging
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
    
    func setupVCs() {
        viewControllers = [
           
            createNavController(for: CustomerVC() , title: "Customers",image: UIImage(systemName: "person.2")!),
            
           createNavController(for: SupplierVC() , title: "Supplliers", image: UIImage(systemName: "person.3")!),
            
            
          
         ]
         }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.removeObserver(self)
        UITabBar.appearance().barTintColor = .black
        tabBar.tintColor = .black
        tabBarItem.title = title
        tabBar.backgroundColor = .systemTeal
        setupVCs()
        
    }
    }


