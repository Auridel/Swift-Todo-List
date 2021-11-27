//
//  ManageListTableViewCell.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 27.11.2021.
//

import UIKit

class ManageListTableViewCell: UITableViewCell {
    
    public static let identifier = "ManageListTableViewCell"
    
    private var model: ListModel?
    
    private let listLabel: UILabel = {
        let listLabel = UILabel()
        listLabel.textColor = .label.withAlphaComponent(0.87)
        return listLabel
    }()
    
    private let removeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "trash")
        imageView.tintColor = .red
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(listLabel)
        contentView.addSubview(removeImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureViews()
    }
 
    override func prepareForReuse() {
        listLabel.text = nil
    }
    
    // MARK: Common
    
    public func configure(with model: ListModel) {
        self.model = model
        listLabel.text = model.title
    }
    
    private func configureViews() {
        let itemHeight: CGFloat = 20
        let verticalPadding = (contentView.height - itemHeight) / 2
        removeImage.frame = CGRect(x: contentView.right - itemHeight - 16,
                                   y: verticalPadding,
                                   width: itemHeight,
                                   height: itemHeight)
        listLabel.frame = CGRect(x: 16,
                                 y: verticalPadding,
                                 width: contentView.width - itemHeight - 16 * 3,
                                 height: itemHeight)
    }
}
