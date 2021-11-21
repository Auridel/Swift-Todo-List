//
//  ViewController.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 21.11.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private var listsModels = [ListModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskListTableViewCell.self,
                           forCellReuseIdentifier: TaskListTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        fetchModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        guard let models = ApiManager.shared.getLists() else {
            return
        }
        listsModels = models
    }
}

// MARK: TableView Delegate

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listsModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listsModels[section].todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTableViewCell.identifier,
                                                 for: indexPath) as! TaskListTableViewCell
        
        return cell
    }
    
}