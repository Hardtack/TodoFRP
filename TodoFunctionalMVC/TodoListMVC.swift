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
    case todoItemChecked(item: Todo)
    case addTodoClicked(title: String)
    case scrolled
    case newTodoTitleChange(title: String)
    case writingNewTodoStarted
}

enum TodoListAction {
    case startLoading
    case endLoading
    case updateTodoList(items: [Todo])
    case deleteTodo(todo: Todo)
    case addTodo(todo: Todo)
    case setWritingNewTodo(value: Bool)
    case setNewTodoTitle(value: String)
}

struct TodoListState: Equatable {
    let loading: Bool
    let items: [Todo]
    let writingNewTodo: Bool
    let newTodoTitle: String
    
    public static func ==(lhs: TodoListState, rhs: TodoListState) -> Bool {
        return lhs.loading == rhs.loading &&
            lhs.items == rhs.items &&
            lhs.writingNewTodo == rhs.writingNewTodo &&
            lhs.newTodoTitle == rhs.newTodoTitle
    }
}

/* Model */

func todoListModel(actionStream: Observable<TodoListAction>) -> Observable<TodoListState> {
    let initialState = TodoListState(
        loading: false,
        items: [],
        writingNewTodo: false,
        newTodoTitle: ""
    )
    let head = Observable.just(initialState)
    let tail = actionStream.scan(initialState) { (state, action) in
        switch (action) {
        case .updateTodoList(let items):
            return TodoListState(
                loading: state.loading,
                items: items,
                writingNewTodo: state.writingNewTodo,
                newTodoTitle: state.newTodoTitle
            )
        case .startLoading:
            return TodoListState(
                loading: true,
                items: state.items,
                writingNewTodo: state.writingNewTodo,
                newTodoTitle: state.newTodoTitle
            )
        case .endLoading:
            return TodoListState(
                loading: false,
                items: state.items,
                writingNewTodo: state.writingNewTodo,
                newTodoTitle: state.newTodoTitle
            )
        case .deleteTodo(let todo):
            let items = state.items.filter { x in x != todo }
            return TodoListState(
                loading: state.loading,
                items: items,
                writingNewTodo: state.writingNewTodo,
                newTodoTitle: state.newTodoTitle
            )
        case .addTodo(let todo):
            return TodoListState(
                loading: state.loading,
                items: [todo] + state.items,
                writingNewTodo: state.writingNewTodo,
                newTodoTitle: state.newTodoTitle
            )
        case .setWritingNewTodo(let value):
            return TodoListState(
                loading: state.loading,
                items: state.items,
                writingNewTodo: value,
                newTodoTitle: state.newTodoTitle
            )
        case .setNewTodoTitle(let value):
            return TodoListState(
                loading: state.loading,
                items: state.items,
                writingNewTodo: state.writingNewTodo,
                newTodoTitle: value
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
            case .todoItemChecked(let todo):
                return gateway.delete(id: todo.id)
                    .map { _ in TodoListAction.deleteTodo(todo: todo) }
            case .addTodoClicked(let title):
                let reset = Observable
                    .just(TodoListAction.setNewTodoTitle(value: ""))
                let result = gateway
                    .create(form: TodoCreationForm(title: title))
                    .map { todo in TodoListAction.addTodo(todo: todo) }
                return Observable.concat(reset, result)
            case .newTodoTitleChange(let title):
                return Observable.just(TodoListAction.setNewTodoTitle(value: title))
            case .scrolled:
                return Observable.just(TodoListAction.setWritingNewTodo(value: false))
            case .writingNewTodoStarted:
                return Observable.just(TodoListAction.setWritingNewTodo(value: true))
            }
        })
    }
    return todoListController
}
