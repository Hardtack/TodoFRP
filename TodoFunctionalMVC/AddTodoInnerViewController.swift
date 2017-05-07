//
//  AddTodoInnerViewController.swift
//  TodoFunctionalMVC
//
//  Created by Owen Choi on 2017. 5. 6..
//  Copyright © 2017년 Geonu Choi. All rights reserved.
//

import Foundation
import UIKit
import Material
import RxSwift

class AddTodoInnerViewController: UIViewController {
    var titleTextField: TextField!
    
    override func loadView() {
        super.loadView()
        // View
        self.view.backgroundColor = Color.white
        // Title text field
        self.titleTextField = TextField()
        self.view.addSubview(self.titleTextField)
        self.view
            .layout(self.titleTextField)
            .left(8)
            .top(8)
            .right(8)
            .height(44)
    }
}
