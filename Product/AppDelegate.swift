//
//  AppDelegate.swift
//  Product
//
//  Created by Mike Saradeth on 5/28/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let productService = ProductService()
        let items = [Product]()
        let viewModel = ListViewModel(items: items, productService: productService)
        let vc = ListVC(viewModel: viewModel)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: vc)
        
        return true
    }

    


}

