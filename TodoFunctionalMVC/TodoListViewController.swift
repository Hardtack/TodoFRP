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
import Material

class TodoListViewController: UIViewController {
    public let disposeBag = DisposeBag()
    
    fileprivate var tableView: UITableView!
    fileprivate var newTodoTextField: TextField!
    fileprivate let checkButtonEventSubject = PublishSubject<Todo>()
    
    override func loadView() {
        super.loadView()
        // Textfield
        self.newTodoTextField = TextField()
        self.newTodoTextField.returnKeyType = UIReturnKeyType.done
        self.view.addSubview(self.newTodoTextField)
        self.view.layout(self.newTodoTextField)
            .left(8)
            .right(8)
            .top()
            .height(44)
        // Table view
        self.tableView = UITableView()
        self.view.addSubview(self.tableView)
        self.view.layout(self.tableView)
            .left()
            .right()
            .top(44)
            .bottom()
    }
}

extension TodoListViewController {
    private func bindTableView(todoListStream: Observable<[Todo]>) -> Disposable {
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell")
        
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
                items: [],
                writingNewTodo: false,
                newTodoTitle: ""
            ))
            .asObservable()
            .distinctUntilChanged()
            .debug()
        
        // Table View
        let todoListStream = stateStream
            .map { state in state.items }
        
        // Writing
        let writingDisposable = stateStream
            .map { state in state.writingNewTodo }
            .distinctUntilChanged()
            .subscribe(onNext: {
                [weak self]
                writingNewTodo in
                if let currentSelf = self {
                    if (writingNewTodo) {
                        if (!currentSelf.newTodoTextField.isFirstResponder) {
                            _ = currentSelf.newTodoTextField.becomeFirstResponder()
                        }
                    } else {
                        if (currentSelf.newTodoTextField.isFirstResponder) {
                            currentSelf.newTodoTextField.resignFirstResponder()
                        }
                    }
                }
            })
        
        // New Todo
        let newTodoDisposable = stateStream
            .map { state in state.newTodoTitle }
            .distinctUntilChanged()
            .bind(to: self.newTodoTextField.rx.text)
        
        
        return Disposables.create([
            self.bindTableView(todoListStream: todoListStream),
            writingDisposable,
            newTodoDisposable
            ])
    }
    
    public func asUserInteractable() -> Observable<TodoListEvent> {
        let viewMount = Observable.just(TodoListEvent.viewMount)
        
        let todoItemChecked = checkButtonEventSubject
            .map { todo in TodoListEvent.todoItemChecked(item: todo) }
        
        let scrolled = tableView.rx.didScroll
            .map { _ in TodoListEvent.scrolled }
            .observeOn(MainScheduler.asyncInstance)
        
        let newTodoTitleChanged = newTodoTextField.rx
            .controlEvent(UIControlEvents.editingChanged)
            .map { [weak self] _ in self?.newTodoTextField.text ?? "" }
            .distinctUntilChanged()
            .map { text in TodoListEvent.newTodoTitleChange(title: text) }
        
        let writingNewTodoStarted = newTodoTextField.rx
            .controlEvent(UIControlEvents.editingDidBegin)
            .map { _ in TodoListEvent.writingNewTodoStarted }
        
        let addClicked = newTodoTextField.rx
            .controlEvent(UIControlEvents.editingDidEndOnExit)
            .map { [weak self ] _ in self?.newTodoTextField?.text }
            .map { title in (title ?? "").trimmed }
            .filter { title in !title.isEmpty }
            .map { title in TodoListEvent.addTodoClicked(title: title) }
        
        return Observable.merge(
            viewMount,
            todoItemChecked,
            scrolled,
            newTodoTitleChanged,
            writingNewTodoStarted,
            addClicked
        )
    }
}

