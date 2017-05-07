//
//  TodoTableViewCell.swift
//  TodoFunctionalMVC
//
//  Created by Owen Choi on 2017. 5. 6..
//  Copyright © 2017년 Geonu Choi. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Material

enum TodoTableViewCellEvent {
    case checkButtonClick(todo: Todo)
}

class TodoTableViewCell: TableViewCell {
    let spacing: CGFloat = 8
    let cellHeight: CGFloat = 44
    
    var checkButton: Button!
    var currentTodo: Todo?
    var onClickTodoButon: () -> Void = {}

    func bind(todo: Todo) {
        self.currentTodo = todo
        self.textLabel?.text = todo.title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layout(self.checkButton)
            .left(spacing)
            .top(spacing)
            .bottom(spacing)
            .height(cellHeight - spacing * 2)
            .width(cellHeight - spacing * 2)
        if let textLabel = self.textLabel {
            textLabel.x = self.checkButton.y + self.checkButton.width + spacing
            textLabel.y = 0
            textLabel.height = cellHeight
            textLabel.width = self.width - textLabel.x - spacing
        }
    }
    
    override func prepare() {
        super.prepare()
        self.checkButton = FlatButton(image: Icon.check, tintColor: Color.white)
        self.checkButton.backgroundColor = Color.blue.darken2
        self.checkButton.pulseColor = Color.white
        self.contentView.addSubview(self.checkButton)
        
        self.checkButton.addTarget(self, action: #selector(handleCheckButtonClick), for: UIControlEvents.touchUpInside)
    }
    
    func handleCheckButtonClick() {
        self.onClickTodoButon()
    }
}
