//
//  ViewController.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 21.11.2021.
//

import UIKit

/// Main View Controller - Allows user manage tasks
class MainViewController: UIViewController {
    
    private var listsModels = [ListModel]()
    
    private var collapsedSections = [Int]()
    
    private struct Constants {
        static let shared = Constants()
        
        let taskHeight: CGFloat = 46
        let fabSize: CGFloat = 60
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskTableViewCell.self,
                           forCellReuseIdentifier: TaskTableViewCell.identifier)
        return tableView
    }()
    
    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: Constants.shared.fabSize,
                                            height: Constants.shared.fabSize))
        button.layer.cornerRadius = 30
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.backgroundColor = .systemBlue
        button.setImage(UIImage(systemName: "plus",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 24,
                                                                               weight: .medium)),
                        for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        floatingButton.frame = CGRect(x: view.width - Constants.shared.fabSize - 8,
                                      y: view.height - Constants.shared.fabSize - 8 - view.safeAreaInsets.bottom,
                                      width: Constants.shared.fabSize,
                                      height: Constants.shared.fabSize)
    }
    
    // MARK: Actions
    
    @objc private func didTapAddTaskButton() {
        let addTaskVC = AddTaskViewController()
        addTaskVC.configure(with: nil, and: listsModels)
        addTaskVC.delegate = self
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    @objc private func didTapFloatingButton() {
        let manageListsVC = ManageListsViewController()
        if let bottomSheet = manageListsVC.presentationController as? UISheetPresentationController {
            bottomSheet.detents = [.medium()]
        }
        manageListsVC.configure(with: listsModels)
        
        present(manageListsVC, animated: true)
    }
    
    //MARK: Common
    
    private func configureView() {
        navigationItem.title = "My Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cube.transparent"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapAddTaskButton))
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(floatingButton)
        tableView.delegate = self
        tableView.dataSource = self
        floatingButton.addTarget(self,
                                 action: #selector(didTapFloatingButton),
                                 for: .touchUpInside)
    }
    
    private func fetchModels() {
        guard listsModels.count == 0 else {
            return
        }
        ApiManager.shared.getLists { models in
            DispatchQueue.main.async {
                self.listsModels = models
                self.tableView.reloadData()
            }
        }
        
    }
    
    private func moveTaskByCompletion(_ task: TodoModel, with listIndex: Int, and taskIndex: Int) {
        let list = listsModels[listIndex]
        let insertIndex = task.checked ? list.todos.count - 1 : 0
        list.todos.remove(at: taskIndex)
        list.todos.insert(task, at: insertIndex)
    }
}

// MARK: TableView

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listsModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listsModels[section].todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier,
                                                 for: indexPath) as! TaskTableViewCell
        cell.configure(with: listsModels[indexPath.section].todos[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ListSectionHeaderView()
        header.configure(with: listsModels[section])
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let list = listsModels[indexPath.section]
        let task = list.todos[indexPath.row]
        let insertIndexPath = IndexPath(row: task.checked ? 0 : list.todos.count - 1, section: indexPath.section)
        
        ApiManager.shared.editTodo(for: task.list_id,
                                      and: task.id,
                                      with: task.text,
                                      and: !task.checked, completion: nil)
        
        task.checked = !task.checked
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        moveTaskByCompletion(task, with: indexPath.section, and: indexPath.row)
        DispatchQueue.main.async {
            tableView.moveRow(at: indexPath, to: insertIndexPath)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.shared.taskHeight
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = listsModels[indexPath.section].todos[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            ApiManager.shared.removeTodo(for: task.list_id, and: task.id) { [weak self] isSuccess in
                if isSuccess {
                    guard let self = self else { return }
                    self.listsModels[indexPath.section].todos.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = listsModels[indexPath.section].todos[indexPath.row]
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            let addTaskVC = AddTaskViewController()
            addTaskVC.configure(with: task, and: self.listsModels)
            addTaskVC.delegate = self
            self.navigationController?.pushViewController(addTaskVC,
                                                          animated: true)
            isDone(true)
        }
        editAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [editAction])
    }
}

// MARK: AddTaskVC Delegate

extension MainViewController: AddTaskViewControllerDelegate {
    
    func completeTask(with actionType: TaskActionType) {
        switch actionType {
        case .create(let task):
            guard let targetIdx = listsModels.firstIndex(where: { $0.id == task.list_id }) else { return }
            let list = listsModels[targetIdx]
            list.todos.insert(task, at: 0)
            DispatchQueue.main.async {
                self.tableView.reloadSections([targetIdx], with: .automatic)
            }
        case .update(let task, let taskToRemove):
            if let taskToRemove = taskToRemove {
                guard let removeListIdx = listsModels.firstIndex(where: { $0.id == taskToRemove.list_id }),
                      let insertListIdx = listsModels.firstIndex(where: { $0.id == task.list_id })
                else { return }
                let insertList = listsModels[insertListIdx]
                listsModels[removeListIdx].todos.removeAll(where: {$0.id == taskToRemove.id})
                insertList.todos.insert(task, at: task.checked ? insertList.todos.count : 0)
                DispatchQueue.main.async {
                    self.tableView.reloadSections([removeListIdx, insertListIdx], with: .automatic)
                }
            } else {
                guard let listIdx = listsModels.firstIndex(where: {$0.id == task.list_id})
                else { return }
                let list = listsModels[listIdx]
                list.todos.removeAll(where: {$0.id == task.id})
                list.todos.insert(task, at: task.checked ? list.todos.count : 0)
                DispatchQueue.main.async {
                    self.tableView.reloadSections([listIdx], with: .automatic)
                }
            }
        }
    }
    
}
