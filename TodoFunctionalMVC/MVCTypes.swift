//
//  MVCTypes.swift
//  TodoFunctionalMVC
//
//  Created by Owen Choi on 2017. 5. 5..
//  Copyright © 2017년 Geonu Choi. All rights reserved.
//

import Foundation
import RxSwift


// Model is a monad transformer from action observable to state observable
public typealias Model<Action, State> = (Observable<Action>) -> Observable<State>

// Controller is a monad transformer from event observable to action observable
public typealias Controller<Event, Action> = (Observable<Event>) -> Observable<Action>

// Renderer is a side-effect consumer that render observable monad to outside of the world
public typealias Renderer<State> = (Observable<State>) -> Disposable

// UserInteractable is a side-effect producer that makes event observable from user interaction,
// time sequence, system events, ...
public typealias UserInteractable<Event> = () -> Observable<Event>

public func startMVC<Action, State, Event>(model: Model<Action, State>, renderer: Renderer<State>, controller: Controller<Event, Action>, userInteractable: UserInteractable<Event>) -> Disposable {
    let eventStream = userInteractable()
    let actionStream = controller(eventStream)
    let stateStream = model(actionStream)
    return renderer(stateStream)
}
