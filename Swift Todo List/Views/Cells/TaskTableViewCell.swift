//
//  TaskTableViewCell.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 22.11.2021.
//

import UIKit


class TaskTableViewCell: UITableViewCell {
    
    static let identifier = "TaskTableViewCell"
    
    private var model: TodoModel?
    
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label.withAlphaComponent(0.87)
        return label
    }()
    
    private let statusImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(taskLabel)
        contentView.addSubview(statusImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskLabel.text = nil
        taskLabel.attributedText = nil
        statusImage.image = nil
    }
    
    private func configureSubviews() {
        
        let contentSize = contentView.height - 6
        let imageSize = (contentSize / 2)
        statusImage.frame = CGRect(x: 16,
                                   y: (imageSize + 6) / 2,
                                   width: imageSize,
                                   height: imageSize)
        
        let textWidth = contentView.width - contentSize - (16 * 2) - 8
        taskLabel.frame = CGRect(x: statusImage.right + 8,
                                 y: 3,
                                 width: textWidth,
                                 height: contentSize)
    }
    
    public func configure(with task: TodoModel) {
        self.model = task
        taskLabel.textColor = .label.withAlphaComponent(task.checked ? 0.38 : 0.87)
        if task.checked {
            let attributedString = NSMutableAttributedString(string: task.text)
//            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
            taskLabel.attributedText = attributedString
        } else {
            taskLabel.text = task.text
        }
        statusImage.image = UIImage(systemName: task.checked ? "checkmark" : "circle")
        statusImage.tintColor = task.checked ? .systemBlue : .label.withAlphaComponent(0.38)
    }
    
  
}
