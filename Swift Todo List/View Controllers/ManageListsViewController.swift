//
//  ManageListsViewController.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 21.11.2021.
//

import UIKit

class ManageListsViewController: UIViewController {
    
    private var lists = [ListModel]()
    
    //TODO: if empty
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ManageListTableViewCell.self,
                           forCellReuseIdentifier: ManageListTableViewCell.identifier)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    private let addListButton: UIButton = {
        let button = UIButton()
        let color = UIColor.label.withAlphaComponent(0.54)
        
        button.setTitleColor(color, for: .normal)
        button.tintColor = color
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setTitle("New Category", for: .normal)
//        button.transform = CGAffineTransform(scaleX: -1, y: 1)
//        button.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
//        button.semanticContentAttribute = .forceRightToLeft
        
        return button
    }()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(addListButton)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addListButton.frame = CGRect(x: 0,
                                     y: view.bottom - view.safeAreaInsets.bottom - 46,
                                     width: view.width,
                                     height: 46)
        tableView.frame = CGRect(x: 0,
                                 y: 32,
                                 width: view.width,
                                 height: view.height - 32 - addListButton.height - view.safeAreaInsets.bottom)
        
        configureButton()
    }

    // MARK: Common
    
    private func configureButton() {
        let titleWidth = addListButton.titleLabel?.width ?? 0
        let imageWidth = addListButton.imageView?.width ?? 0
        let padding = addListButton.width - titleWidth - imageWidth - 32
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .trailing
        configuration.titleAlignment = .leading
        configuration.imagePadding = padding
        addListButton.configuration = configuration
    }
    
    public func configure(with lists: [ListModel]) {
        self.lists = lists
    }
    
}


// MARK: TableView

extension ManageListsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lists.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ManageListTableViewCell.identifier,
                                                 for: indexPath) as! ManageListTableViewCell
        cell.configure(with: lists[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //TODO: delete logic
    }
    
}
