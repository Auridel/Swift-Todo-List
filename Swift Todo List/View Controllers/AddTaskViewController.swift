//
//  AddTaskViewController.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 21.11.2021.
//

import UIKit

enum TaskActionType {
    case create(task: TodoModel), update(task: TodoModel)
}

protocol AddTaskViewControllerDelegate: AnyObject {
    func completeTask(with actionType: TaskActionType)
}

/// Allows to add or edit tasks
class AddTaskViewController: UIViewController {
    
    weak var delegate: AddTaskViewControllerDelegate?
    
    private var taskModel: TodoModel?
    
    private var lists = [ListModel]()
    
    private var selectedListId: Int?
    
    private let taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Task Name"
        textField.font = .systemFont(ofSize: 22)
        return textField
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18,
                                 weight: .bold)
        label.textColor = .label.withAlphaComponent(0.54)
        label.text = "Categories"
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryTableViewCell.self,
                           forCellReuseIdentifier: CategoryTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        view.addSubview(taskTextField)
        view.addSubview(categoryLabel)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureViews()
    }
    
    private func configureViews() {
        taskTextField.frame = CGRect(x: 16,
                                     y: view.safeAreaInsets.top + 16,
                                     width: view.width - 32,
                                     height: 24)
        categoryLabel.frame = CGRect(x: 16,
                                     y: taskTextField.bottom + 32,
                                     width: view.width - 32,
                                     height: 20)
        tableView.frame = CGRect(x: view.left,
                                 y: categoryLabel.bottom + 16,
                                 width: view.width,
                                 height: view.width - categoryLabel.bottom - 16)
    }
    
    private func configureNavigationBar(){
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(didTapBackButton))
        let doneBarButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
                                            style: .done,
                                            target: self,
                                            action: #selector(didTapDoneButton))
        
        backBarButton.tintColor = .label.withAlphaComponent(0.54)
        doneBarButton.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    public func configure(with model: TodoModel?, and lists: [ListModel]) {
        self.taskModel = model
        self.lists = lists
    }
    
    private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Actions
    
    @objc private func didTapBackButton(){
        dismissVC()
    }
    
    @objc private func didTapDoneButton(){
        if taskModel != nil {
            guard let text = taskTextField.text,
                  !text.isEmpty,
                  let listId = selectedListId
            else {
                dismissVC()
                return
            }
            ApiManager.shared.createTodo(for: listId,
                                            with: text,
                                            and: false) { [weak self] model in
                if let task = model, let self = self {
                    self.delegate?.completeTask(with: .create(task: task))
                }
            }
        } else {
            guard let text = taskTextField.text,
                  !text.isEmpty,
                  let listId = selectedListId,
                  let taskModel = taskModel
            else {
                dismissVC()
                return
            }
            if listId != taskModel.list_id {
                ApiManager.shared.removeTodo(for: taskModel.list_id,
                                                and: taskModel.id,
                                                completion: nil)
                ApiManager.shared.createTodo(for: listId,
                                                with: text,
                                                and: false) { [weak self] todo in
                    if let todo = todo, let self = self {
                        self.delegate?.completeTask(with: .create(task: todo))
                    }
                }
            } else {
                ApiManager.shared.editTodo(for: listId,
                                              and: taskModel.id,
                                              with: text,
                                              and: taskModel.checked) {[weak self] todo in
                    if let todo = todo, let self = self {
                        self.delegate?.completeTask(with: .update(task: todo))
                    }
                }
            }
        }
        dismissVC()
    }
    
}


// MARK: TableView

extension AddTaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier,
                                                 for: indexPath) as! CategoryTableViewCell
        
        cell.configure(with: lists[indexPath.row],
                       and: taskModel != nil ? lists[indexPath.row].id == taskModel?.list_id : indexPath.row == 0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
}
