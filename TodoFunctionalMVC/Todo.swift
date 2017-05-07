//
//  Todo.swift
//  TodoFunctionalMVC
//
//  Created by Owen Choi on 2017. 5. 5..
//  Copyright © 2017년 Geonu Choi. All rights reserved.
//

import Foundation

public struct Todo {
    let id: Int
    let title: String
    let createdAt: Date
}

extension Todo: Equatable {
    public static func ==(lhs: Todo, rhs: Todo) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.createdAt == rhs.createdAt
    }
}
