//
//  TaskListViewController.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 21.11.2021.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    static let identifier = "TaskListViewController"
    
    private var model: ListModel?
    
    private let listLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(listLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        listLabel.frame = CGRect(x: 16,
                                 y: 0,
                                 width: contentView.width - 32,
                                 height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.model = nil
        listLabel.text = nil
    }
    
    public func configure(with model: ListModel){
        self.model = model
        listLabel.text = model.title
    }
}
