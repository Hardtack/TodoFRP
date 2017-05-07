//
//  ViewController.swift
//  TodoFunctionalMVC
//
//  Created by Owen Choi on 2017. 5. 5..
//  Copyright © 2017년 Geonu Choi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TodoListViewController: UIViewController {
    public let disposeBag = DisposeBag()
    
    private var tableView: UITableView!
    private let checkButtonEventSubject = PublishSubject<Todo>()
    
    override func loadView() {
        self.tableView = UITableView()
        self.view = self.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = todoListModel
        let controller = todoListControllerFactory(gateway: TodoServiceGateway())
        let renderer = self.asRenderer
        let userInteractable = self.asUserInteractable
        
        startMVC(model: model,
                 renderer: renderer,
                 controller: controller,
                 userInteractable: userInteractable)
            .disposed(by: disposeBag)
    }
    
    private func bindTableView(todoListStream: Observable<[Todo]>) -> Disposable {
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        
        return todoListStream.bind(to: tableView.rx.items(cellIdentifier: "TodoCell", cellType: TodoTableViewCell.self)) {
            (index, todo, cell) in
            cell.bind(todo: todo)
            cell.onClickTodoButon = {
                self.checkButtonEventSubject.onNext(todo)
            }
        }
    }
    
    public func asRenderer(stateObservable: Observable<TodoListState>) -> Disposable {
        // Keep safe
        let stateStream = stateObservable
            .asDriver(onErrorJustReturn: TodoListState(
                loading: false,
                items: []
            ))
            .asObservable()
        
        // Table View
        let todoListStream = stateStream
            .map { state in state.items }
        
        return Disposables.create([
            self.bindTableView(todoListStream: todoListStream)
            ])
    }
    
    public func asUserInteractable() -> Observable<TodoListEvent> {
        let viewMount = Observable.just(TodoListEvent.viewMount)
        let todoItemSelected = tableView.rx
            .modelSelected(Todo.self)
            .map { todo in TodoListEvent.todoItemSelected(item: todo) }
        let todoItemChecked = checkButtonEventSubject
            .map { todo in TodoListEvent.todoItemChecked(item: todo) }
        
        return Observable.merge(viewMount, todoItemSelected, todoItemChecked)
    }
}

