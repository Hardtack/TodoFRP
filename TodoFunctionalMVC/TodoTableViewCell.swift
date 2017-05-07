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
    let dateHeight: CGFloat = 16
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter.init()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var checkButton: Button!
    var currentTodo: Todo?
    var onClickTodoButon: () -> Void = {}
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func bind(todo: Todo) {
        self.currentTodo = todo
        self.textLabel?.text = todo.title
        self.detailTextLabel?.text = dateFormatter.string(from: todo.createdAt)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Check button
        self.checkButton.x = spacing
        self.checkButton.y = spacing
        self.checkButton.height = cellHeight - spacing * 2
        self.checkButton.width = cellHeight - spacing * 2

        if let textLabel = self.textLabel {
            textLabel.font = textLabel.font.withSize(16)
            textLabel.x = self.checkButton.y + self.checkButton.width + spacing
            textLabel.y = spacing
            textLabel.height = cellHeight - dateHeight - spacing - spacing
            textLabel.width = self.width - textLabel.x - spacing
        }
        if let detailLabel = self.detailTextLabel {
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.x = self.checkButton.y + self.checkButton.width + spacing
            detailLabel.y = cellHeight - dateHeight - spacing
            detailLabel.height = dateHeight
            detailLabel.width = self.width - detailLabel.x - spacing
        }
    }
    
    override func prepare() {
        super.prepare()
        self.checkButton = FlatButton(image: Icon.check, tintColor: Color.blue.lighten4)
        self.checkButton.borderWidth = 2
        self.checkButton.borderColor = Color.blue.lighten2
        self.checkButton.pulseColor = Color.blue.darken2
        self.contentView.addSubview(self.checkButton)
        
        self.checkButton.addTarget(self, action: #selector(handleCheckButtonClick), for: UIControlEvents.touchUpInside)
    }
    
    func handleCheckButtonClick() {
        self.onClickTodoButon()
    }
}
