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
        textField.placeholder = "Enter task"
        return textField
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label.withAlphaComponent(0.54)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureNavigationBar()
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
    
    public func configure(with model: TodoModel) {
        self.taskModel = model
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
                                            and: false) { model in
                if let task = model {
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
                ApiManager.shared.removeTodo(for: taskModel.list_id, and: taskModel.id, completion: nil)
                ApiManager.shared.createTodo(for: listId, with: text, and: false) { todo in
                    if let todo = todo {
                        self.delegate?.completeTask(with: .create(task: todo))
                    }
                }
            } else {
                ApiManager.shared.editTodo(for: listId,
                                              and: taskModel.id,
                                              with: text,
                                              and: taskModel.checked) { todo in
                    if let todo = todo {
                        self.delegate?.completeTask(with: .update(task: todo))
                    }
                }
            }
        }
        dismissVC()
    }
    
}
