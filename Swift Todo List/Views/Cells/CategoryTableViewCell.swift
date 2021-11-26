//
//  CategoryTableViewCell.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 25.11.2021.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let identifier = "CategoryTableViewCell"
    
    private var isItemSelected = false
    
    private var listModel: ListModel?
    
    private struct Constants {
        let color: UIColor = .label.withAlphaComponent(0.54)
        let selectedColor: UIColor = .systemBlue
        
        let selectedImg = "record.circle"
        let image = "circle"
        
        static let shared = Constants()
    }
    
    private let listLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label.withAlphaComponent(0.54)
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let listAccessory: UIImageView = {
        let accessory = UIImageView()
        accessory.tintColor = Constants.shared.color
        return accessory
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(listLabel)
        contentView.addSubview(listAccessory)
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isItemSelected = false
        listModel = nil
        listLabel.text = nil
    }
    
    private func configureViews() {
        let itemHeight: CGFloat = 20
        let topPadding: CGFloat = (contentView.height - itemHeight) / 2
        listLabel.frame = CGRect(x: 16,
                                 y: topPadding,
                                 width: contentView.width - 32 - itemHeight - 16,
                                 height: itemHeight)
        listAccessory.frame = CGRect(x: listLabel.right + 16,
                                     y: topPadding,
                                     width: itemHeight,
                                     height: itemHeight)
    }
    
    public func configure(with list: ListModel, and selected: Bool) {
        listModel = list
        isItemSelected = selected
        listLabel.text = list.title
        listAccessory.image = UIImage(systemName: selected ?
                                      Constants.shared.selectedImg : Constants.shared.image)
        listAccessory.tintColor = selected ? Constants.shared.selectedColor : Constants.shared.color
    }
}
