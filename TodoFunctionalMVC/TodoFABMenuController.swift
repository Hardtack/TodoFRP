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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        fabMenu.fabButton = fabButton
        fabMenu.fabMenuItems = [addItem]
        view.layout(fabMenu)
            .size(fabMenuSize)
            .bottom(bottomInset)
            .right(rightInset)
    }
    
    public func asRenderer(stateStream: Observable<FABState>) -> Disposable {
        return stateStream
            .asDriver(onErrorJustReturn: FABState.closed)
            .drive(onNext: { [unowned self] state in switch (state) {
            case .opened:
                self.fabMenu.open()
            case .closed:
                self.fabMenu.close()
                }})
    }
    
    public func asUserInteractable() -> Observable<FABEvent> {
        return Observable.merge([
            addItem.fabButton.rx.controlEvent(.touchUpInside)
                .map { _ in FABEvent.clickAdd }
        ])
    }
}
