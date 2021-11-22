//
//  TaskListViewController.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 21.11.2021.
// 46

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    static let identifier = "TaskListViewController"
    
    private var model: ListModel?
    
    private struct Constants {
        static let shared = Constants()
        
        let taskHeight: CGFloat = 46
    }
    
    private var completedTodos = [TodoModel]()
    
    private var uncompletedTodos = [TodoModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.register(TaskTableViewCell.self,
                           forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.sectionHeaderTopPadding = 0
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
        model = nil
        completedTodos = []
        uncompletedTodos = []
    }
    
    
    
    public func configure(with model: ListModel){
        self.model = model
        for todo in model.todos {
            if(todo.checked) {
                completedTodos.append(todo)
            } else {
                uncompletedTodos.append(todo)
            }
        }
    }
}

// MARK: TableView

extension TaskListTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model?.todos.count ?? 0 > 0 ? 3 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard model?.todos.count ?? 0 > 0 else {
            return 0
        }
        if section == 0 {
            return uncompletedTodos.count
        } else if section == 1 {
            return 0
        } else {
            return completedTodos.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hasTodos = model?.todos.count ?? 0 > 0
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier,
                                                 for: indexPath) as! TaskTableViewCell
        if hasTodos == true {
            if indexPath.section == 0 {
                cell.configure(with: uncompletedTodos[indexPath.row])
            } else if indexPath.section == 2 {
                cell.configure(with: completedTodos[indexPath.row])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return Constants.shared.taskHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hasTodos = model?.todos.count ?? 0 > 0
        if (hasTodos && section == 1) || !hasTodos {
            return StatusSeparatorView()
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let hasTodos = model?.todos.count ?? 0 > 0
        if (hasTodos && section == 1) || !hasTodos {
            return Constants.shared.taskHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

}
