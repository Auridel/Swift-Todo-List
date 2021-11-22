//
//  StatusSeparatorView.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 22.11.2021.
//

import UIKit

class StatusSeparatorView: UIView {

    private var isExpanded = false
    
    private let separatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "Завершенные"
        return label
    }()
    
    private let separatorImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .label.withAlphaComponent(0.38)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        self.addSubview(separatorLabel)
        self.addSubview(separatorImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentSize = self.height - 6
        let imageSize = (contentSize / 2)
        separatorImage.frame = CGRect(x: 16,
                                   y: (imageSize + 6) / 2,
                                   width: imageSize,
                                   height: imageSize)
        
        let textWidth = self.width - contentSize - (16 * 2) - 8
        separatorLabel.frame = CGRect(x: separatorImage.right + 8,
                                 y: 3,
                                 width: textWidth,
                                 height: contentSize)
    }


}
