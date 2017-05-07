//
//  TodoServiceGateway.swift
//  TodoFunctionalMVC
//
//  Created by Owen Choi on 2017. 5. 5..
//  Copyright © 2017년 Geonu Choi. All rights reserved.
//

import Foundation
import RxSwift

public struct TodoCreationForm {
    let title: String
}

var nextId = 3
var todoList: [Todo] = [
    Todo(
        id: 0,
        title: "Hello, World!",
        createdAt: Date(timeIntervalSinceNow: -(2 * 60 * 60))),
    Todo(
        id: 1,
        title: "Hello, World!",
        createdAt: Date(timeIntervalSinceNow: -(60 * 60))),
    Todo(
        id: 2,
        title: "Hello, World!",
        createdAt: Date())
]

public struct TodoServiceGateway {
    //    let backgroundScheduler = ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.background)
    let backgroundScheduler = MainScheduler.asyncInstance
    
    /**
     * Emulate remote todo creation
     */
    public func create(form: TodoCreationForm) -> Observable<Todo> {
        let todo = Todo(
            id: nextId,
            title: form.title,
            createdAt: Date())
        todoList.append(todo)
        return Observable
            .just(todo)
            .delay(0.5, scheduler: backgroundScheduler)
    }
    
    /**
     * Emulate remote todo deletion
     */
    public func delete(id: Int) -> Observable<Void> {
        if let idx = (todoList.index { (todo) -> Bool in todo.id == id }) {
            todoList.remove(at: idx)
        }
        return Observable
            .just(Void())
            .delay(0.5, scheduler: backgroundScheduler)
    }
    
    /**
     * Emulate remote todo fetching
     */
    public func index() -> Observable<[Todo]> {
        return Observable
            .just(todoList)
            .delay(0.5, scheduler: backgroundScheduler)
    }
}
