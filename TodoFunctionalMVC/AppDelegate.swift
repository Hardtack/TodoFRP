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
        
        let todoViewController = makeTodoList()
        let toolbarController = AppToolbarController(rootViewController: todoViewController)
        let menuController = makeTodoFAB(rootViewController: toolbarController)
        window!.rootViewController = menuController
        window!.makeKeyAndVisible()
    }
    
    private func makeTodoFAB(rootViewController: UIViewController) -> TodoFABMenuController {
        let menuViewController = TodoFABMenuController(rootViewController: rootViewController)
        let model = todoFABMenuModel
        let controller = todoFABMenuController
        let renderer = menuViewController.asRenderer
        let userInteractable = menuViewController.asUserInteractable
        
        startMVC(model: model,
                 renderer: renderer,
                 controller: controller,
                 userInteractable: userInteractable)
            .disposed(by: menuViewController.disposeBag)
        return menuViewController
    }
    
    private func makeTodoList() -> TodoListViewController {
        let todoViewController = TodoListViewController()
        let model = todoListModel
        let controller = todoListControllerFactory(gateway: TodoServiceGateway())
        let renderer = todoViewController.asRenderer
        let userInteractable = todoViewController.asUserInteractable
        
        startMVC(model: model,
                 renderer: renderer,
                 controller: controller,
                 userInteractable: userInteractable)
            .disposed(by: todoViewController.disposeBag)
        return todoViewController
    }
}

