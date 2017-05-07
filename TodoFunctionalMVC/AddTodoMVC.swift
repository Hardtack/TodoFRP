//
//  AddTodoMVC.swift
//  TodoFunctionalMVC
//
//  Created by Owen Choi on 2017. 5. 7..
//  Copyright © 2017년 Geonu Choi. All rights reserved.
//

import Foundation
import RxSwift

/* Types */

struct AddTodoState {
}

enum AddTodoEvent {
    case doneClick(title: String)
}

enum AddTodoAction {
}

/* Model */

func addTodoModel(actionStream: Observable<AddTodoAction>) -> Observable<AddTodoState> {
    return Observable.just(AddTodoState())
}

func addTodoController(eventStream: Observable<AddTodoEvent>) -> Observable<AddTodoAction> {
    // Nothing to do
    return Observable.empty()
}
