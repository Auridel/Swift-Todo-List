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
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeWrapper(key: .id, defaultValue: -1)
        self.title = try container.decodeWrapper(key: .title, defaultValue: "")
        self.candidate_id = try container.decodeWrapper(key: .candidate_id, defaultValue: -1)
        self.created_at = try container.decodeWrapper(key: .created_at, defaultValue: "")
        self.updated_at = try container.decodeWrapper(key: .updated_at, defaultValue: "")
        self.todos = try container.decodeWrapper(key: .todos, defaultValue: [])
    }
}

public class TodoModel: Codable {
    let id: Int
    let text: String
    let list_id: Int
    var checked: Bool
    let created_at: String
    let updated_at: String
}
