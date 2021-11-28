//
//  ManageListsViewController.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 21.11.2021.
//

import UIKit

protocol ManageListsViewControllerDelegate: AnyObject {
    func deleteList(listId: Int)
    
    func createList(list: ListModel)
}

class ManageListsViewController: UIViewController {
    
    weak var delegate: ManageListsViewControllerDelegate?
    
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
        button.addTarget(self,
                         action: #selector(didTapAddNewList),
                         for: .touchUpInside)
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
    
    // MARK: Actions
    
    @objc private func didTapAddNewList() {
        let alert = UIAlertController(title: "Add New Category",
                                      message: "Please enter category name",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            
        }
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "Done",
                                      style: .default,
                                      handler: { _ in
            guard let title = alert.textFields?.first?.text, !title.isEmpty else {
                return
            }
            self.createList(with: title)
        }))
        present(alert, animated: true)
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
    
    private func showConfirmDeleteAlert(for list: ListModel, at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Category",
                                      message: "Do you really want to delete \(list.title)?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "Delete",
                                      style: .destructive,
                                      handler: { _ in
            self.deleteList(list, at: indexPath)
        }))
        present(alert, animated: true)
    }
    
    private func deleteList(_ list: ListModel, at indexPath: IndexPath) {
        ApiManager.shared.deleteList(with: list.id) { [weak self] isDone in
            if isDone, let self = self {
                self.lists.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath],
                                              with: .automatic)
                }
                self.delegate?.deleteList(listId: list.id)
                self.dismissVC()
            }
        }
    }
    
    private func createList(with title: String) {
        ApiManager.shared.createList(with: title) { [weak self] model in
            guard let model = model, let self = self else {
                return
            }
            self.delegate?.createList(list: model)
            self.dismissVC()
        }
    }
    
    private func dismissVC() {
        dismiss(animated: true, completion: nil)
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
        let list = lists[indexPath.row]
        showConfirmDeleteAlert(for: list, at: indexPath)
    }
    
}
