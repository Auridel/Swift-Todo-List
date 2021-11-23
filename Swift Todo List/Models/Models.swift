//
//  ListModel.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 21.11.2021.
//

import Foundation

public class ListModel: Codable {
    let id: Int
    let title: String
    let candidate_id: Int
    let created_at: String
    let updated_at: String
    var todos: [TodoModel]
    
}

public class TodoModel: Codable {
    let id: Int
    let text: String
    let list_id: Int
    var checked: Bool
    let created_at: String
    let updated_at: String
}
