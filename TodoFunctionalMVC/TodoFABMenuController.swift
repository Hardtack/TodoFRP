//
//  TodoFABMenuController.swift
//  TodoFunctionalMVC
//
//  Created by Owen Choi on 2017. 5. 6..
//  Copyright © 2017년 Geonu Choi. All rights reserved.
//

import Foundation
import UIKit
import Material
import RxSwift
import RxCocoa


class TodoFABMenuController: FABMenuController {
    public let disposeBag = DisposeBag()
    
    private let fabMenuSize = CGSize(width: 56, height: 56)
    private let bottomInset: CGFloat = 24
    private let rightInset: CGFloat = 24
    
    private var fabButton: FABButton!
    private var addItem: FABMenuItem!
    
    private var addTodoVC: AddTodoViewController? = nil
    
    // FABMenuController
    override func prepare() {
        super.prepare()
        
        fabMenu.fabButton = fabButton
        fabMenu.fabMenuItems = [addItem]
        view.layout(fabMenu)
            .size(fabMenuSize)
            .bottom(bottomInset)
            .right(rightInset)
    }
    
    override func loadView() {
        super.loadView()

        // Add
        addItem = FABMenuItem()
        addItem.title = "New Todo"
        addItem.fabButton.image = Icon.edit
        addItem.fabButton.tintColor = .white
        addItem.fabButton.pulseColor = .white
        addItem.fabButton.backgroundColor = Color.blue.base
        
        // FAB
        fabButton = FABButton(image: Icon.cm.moreHorizontal, tintColor: .white)
        fabButton.pulseColor = .white
        fabButton.backgroundColor = Color.red.base
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = todoFABMenuModel
        let controller = todoFABMenuController
        let renderer = self.asRenderer
        let userInteractable = self.asUserInteractable
        
        startMVC(model: model,
                 renderer: renderer,
                 controller: controller,
                 userInteractable: userInteractable)
            .disposed(by: disposeBag)
    }
    
    public func asRenderer(stateObservable: Observable<FABState>) -> Disposable {
        let stateStream = stateObservable
            .asDriver(onErrorJustReturn: FABState.closed)
            .asObservable()
        let menuDisposable = stateStream
            .subscribe(onNext: { [unowned self] state in switch (state) {
            case .opened:
                self.fabMenu.open()
            case .closed:
                self.fabMenu.close()
            default:
                break
                }})
        
        let addTodoDisposable = stateStream
            .map { s in s == .showingAddTodo }
            .distinctUntilChanged()
            .subscribe(onNext: { showing in
                if (showing) {
                    let addTodoVC = AddTodoViewController()
                    self.addTodoVC = addTodoVC
                    self.present(addTodoVC, animated: true, completion: nil)
                } else {
                    if let addTodoVC = self.addTodoVC {
                        addTodoVC.dismiss(animated: true, completion: nil)
                    }
                }
            })
        
        
        return Disposables.create(menuDisposable, addTodoDisposable)
    }
    
    public func asUserInteractable() -> Observable<FABEvent> {
        return Observable.merge([
            addItem.fabButton.rx.controlEvent(.touchUpInside)
                .map { _ in FABEvent.clickAdd }
        ])
    }
}
