//
//  ListSectionHeaderView.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 22.11.2021.
//

import UIKit

class ListSectionHeaderView: UIView {

    private var model: ListModel?
    
    private let listLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label.withAlphaComponent(0.54)
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        self.addSubview(listLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        listLabel.frame = CGRect(x: 16,
                                 y: 0,
                                 width: self.width - 32,
                                 height: self.height)
    }
    
    public func configure(with model: ListModel){
        self.model = model
        listLabel.text = model.title
    }
}
