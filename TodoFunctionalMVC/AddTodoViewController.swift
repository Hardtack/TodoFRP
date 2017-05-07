//
//  AddTodoViewController.swift
//  TodoFunctionalMVC
//
//  Created by Owen Choi on 2017. 5. 7..
//  Copyright © 2017년 Geonu Choi. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Material


class AddTodoViewController: ToolbarController {
    fileprivate var doneButton: Button!
    fileprivate var cancelButton: Button!
    private let innerController = AddTodoInnerViewController()
    
    init() {
        super.init(rootViewController: innerController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func prepare() {
        super.prepare()
        prepareDoneButton()
        prepareCancelButton()
        prepareStatusBar()
        prepareToolbar()
    }
}

extension AddTodoViewController {
    fileprivate func prepareDoneButton() {
        doneButton = IconButton(image: Icon.pen, tintColor: Color.white)
        doneButton.pulseColor = .white
    }

    fileprivate func prepareCancelButton() {
        cancelButton = IconButton(image: Icon.close, tintColor: Color.white)
        cancelButton.pulseColor = .white
    }
    
    fileprivate func prepareStatusBar() {
        statusBarStyle = .lightContent
        statusBar.backgroundColor = Color.blue.darken3
    }
    
    fileprivate func prepareToolbar() {
        toolbar.depthPreset = .none
        toolbar.backgroundColor = Color.blue.darken2
        
        toolbar.title = "Add New Todo"
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .left
        
        toolbar.detail = "Add new todo to list"
        toolbar.detailLabel.textColor = .white
        toolbar.detailLabel.textAlignment = .left
        
        toolbar.leftViews = [cancelButton]
        toolbar.rightViews = [doneButton]
    }
}
