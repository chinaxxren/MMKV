//
//  AppDelegate.swift
//  Base
//
//  Created by 赵江明 on 2022/1/15.
//

import UIKit
import XCoordinator
 
let router = AppCoordinator().strongRouter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let window: UIWindow! = UIWindow()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        // window = UIWindow(frame: UIScreen.main.bounds)
        //        let navController = UINavigationController.init(rootViewController: ViewController())
        //        window?.rootViewController = navController
        //        window?.makeKeyAndVisible()
    

        router.setRoot(for: window)

        return true
    }

}

