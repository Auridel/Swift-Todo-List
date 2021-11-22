//
//  CompletedSeparatorTableViewCell.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 22.11.2021.
//

import UIKit

class CompletedSeparatorTableViewCell: UITableViewCell {
    
    static let identifier = "CompletedSeparatorTableViewCell"

    private var isExpanded = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isExpanded = false
    }
    
}
