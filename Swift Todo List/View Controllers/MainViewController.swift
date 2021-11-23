//
//  ViewController.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 21.11.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private var listsModels = [ListModel]()
    
    private var collapsedSections = [Int]()
    
    private struct Constants {
        static let shared = Constants()
        
        let taskHeight: CGFloat = 46
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskTableViewCell.self,
                           forCellReuseIdentifier: TaskTableViewCell.identifier)
        return tableView
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
    }
    
    // MARK: Actions
    
    @objc private func didTapAddTaskButton() {
        
    }
    
    //MARK: Common
    
    private func configureView() {
        navigationItem.title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cube.transparent"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapAddTaskButton))
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchModels() {
        
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
        list.todos.insert(task, at: insertIndex);
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
        let insertIndexPath = IndexPath(row: task.checked ? list.todos.count - 1 : 0, section: indexPath.section)
        
        task.checked = !task.checked
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        moveTaskByCompletion(task, with: indexPath.section, and: indexPath.row)
        tableView.moveRow(at: indexPath, to: insertIndexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.shared.taskHeight
    }
}
