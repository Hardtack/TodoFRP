//
//  TodoFABMVC.swift
//  TodoFunctionalMVC
//
//  Created by Owen Choi on 2017. 5. 7..
//  Copyright © 2017년 Geonu Choi. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


enum FABState {
    case opened
    case closed
}

enum FABAction {
    case open
    case close
}

enum FABEvent {
    case clickAdd
}

func todoFABMenuModel(actionStream: Observable<FABAction>) -> Observable<FABState> {
    let initialState: FABState = .closed
    let head = Observable.just(initialState)
    let tail = actionStream.scan(initialState) { (state, action) in switch (action) {
    case .open:
        return .opened
    case .close:
        return .closed
        }}
    return Observable.concat(head, tail)
}

func todoFABMenuController(eventStream: Observable<FABEvent>) -> Observable<FABAction> {
    return eventStream.flatMap { event -> Observable<FABAction> in switch (event) {
    case .clickAdd:
        return Observable.just(FABAction.close)
        }}
}
