//
//  AppDelegate.swift
//  TodoFunctionalMVC
//
//  Created by Owen Choi on 2017. 5. 5..
//  Copyright © 2017년 Geonu Choi. All rights reserved.
//

import UIKit
import Material

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        window = UIWindow(frame: Screen.bounds)
        
        let todoViewController = TodoListViewController()
        let toolbarController = AppToolbarController(rootViewController: todoViewController)
        window!.rootViewController = toolbarController
        window!.makeKeyAndVisible()
    }
}

