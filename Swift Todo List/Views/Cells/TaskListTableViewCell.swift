//
//  TaskListViewController.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 21.11.2021.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    static let identifier = "TaskListViewController"
    
    private var model: ListModel?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.register(TaskTableViewCell.self,
                           forCellReuseIdentifier: TaskTableViewCell.identifier)
        return tableView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.model = nil
    }
    
    private func sortTodos(_ todos: [TodoModel]) -> [TodoModel] {
        return todos.sorted { $0.checked && !$1.checked }
    }
    
    public func configure(with model: ListModel){
        self.model = model
        guard let todos = self.model?.todos else {
            return
        }
        self.model?.todos = sortTodos(todos)
    }
}

// MARK: TableView

extension TaskListTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.todos.count ?? 0 + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let task = model?.todos[indexPath.row] else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier,
                                                 for: indexPath) as! TaskTableViewCell
        cell.configure(with: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
