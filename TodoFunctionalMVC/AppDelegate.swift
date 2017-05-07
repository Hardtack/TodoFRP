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
        
        let todoListViewController = makeTodoList()
        
        let toolbarController = AppToolbarController(rootViewController: todoListViewController)
        window!.rootViewController = toolbarController
        window!.makeKeyAndVisible()
    }
    
    func makeTodoList() -> TodoListViewController {
        let todoListViewController = TodoListViewController()
        
        let model = todoListModel
        let controller = todoListControllerFactory(gateway: TodoServiceGateway())
        let renderer = todoListViewController.asRenderer
        let userInteractable = todoListViewController.asUserInteractable
        
        // To load a view
        _ = todoListViewController.view
        
        startMVC(model: model,
                 renderer: renderer,
                 controller: controller,
                 userInteractable: userInteractable)
            .disposed(by: todoListViewController.disposeBag)
        return todoListViewController
    }
}

