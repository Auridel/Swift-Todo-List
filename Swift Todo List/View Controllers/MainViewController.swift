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
}

// MARK: TableView Delegate

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listsModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTableViewCell.identifier,
                                                 for: indexPath) as! TaskListTableViewCell
        cell.configure(with: listsModels[indexPath.section])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ListSectionHeaderView()
        header.configure(with: listsModels[section])
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(listsModels[indexPath.section].todos.count + 1) * 46
    }
    
}
