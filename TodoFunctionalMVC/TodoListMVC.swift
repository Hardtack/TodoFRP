//
//  TodoMVC.swift
//  TodoFunctionalMVC
//
//  Created by Owen Choi on 2017. 5. 7..
//  Copyright © 2017년 Geonu Choi. All rights reserved.
//

import Foundation
import RxSwift

/* Types */

enum TodoListEvent {
    case viewMount
    case todoItemSelected(item: Todo)
    case todoItemChecked(item: Todo)
}

enum TodoListAction {
    case startLoading
    case endLoading
    case updateTodoList(items: [Todo])
    case deleteTodo(todo: Todo)
    case addTodo(todo: Todo)
}

struct TodoListState {
    let loading: Bool
    let items: [Todo]
}

/* Model */

func todoListModel(actionStream: Observable<TodoListAction>) -> Observable<TodoListState> {
    let initialState = TodoListState(loading: false, items: [])
    let head = Observable.just(initialState)
    let tail = actionStream.scan(initialState) { (state, action) in
        switch (action) {
        case .updateTodoList(let items):
            return TodoListState(
                loading: state.loading,
                items: items
            )
        case .startLoading:
            return TodoListState(
                loading: true,
                items: state.items
            )
        case .endLoading:
            return TodoListState(
                loading: false,
                items: state.items
            )
        case .deleteTodo(let todo):
            let items = state.items.filter { x in x != todo }
            return TodoListState(
                loading: state.loading,
                items: items
            )
        case .addTodo(let todo):
            return TodoListState(
                loading: state.loading,
                items: [todo] + state.items
            )
        }
    }
    return Observable.merge(head, tail)
}

/* Controller */

func todoListControllerFactory(gateway: TodoServiceGateway) -> Controller<TodoListEvent, TodoListAction> {
    func todoListController(eventStream: Observable<TodoListEvent>) -> Observable<TodoListAction> {
        return eventStream.flatMapLatest({ (event) -> Observable<TodoListAction> in
            switch (event) {
            case .viewMount:
                let startLoading = Observable.just(TodoListAction.startLoading)
                let endLoading = Observable.just(TodoListAction.endLoading)
                let remoteCall = gateway.index()
                    .map { todoList in TodoListAction.updateTodoList(items: todoList) }
                return Observable.concat(
                    startLoading,
                    remoteCall,
                    endLoading)
            case .todoItemSelected:
                print("Selected")
                // Nothing to do currently
                return Observable.empty()
            case .todoItemChecked(let todo):
                return gateway.delete(id: todo.id)
                    .map { _ in TodoListAction.deleteTodo(todo: todo) }
            }
        })
    }
    return todoListController
}
