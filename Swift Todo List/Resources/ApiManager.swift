//
//  ApiManager.swift
//  Swift Todo List
//
//  Created by Олег Ефимов on 21.11.2021.
//

import Foundation
import Alamofire

public class ApiManager {
    
    static let shared = ApiManager()
    
    private let baseURL = "http://mobile-dev.oblakogroup.ru/candidate/qweqwe/"
    
    private init(){}
    
    public func getLists(completion: @escaping (([ListModel]) -> Void)) {
        var models = [ListModel]()
        AF.request("\(baseURL)list")
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success:
                    guard let jsonData = dataResponse.data else {
                        return
                    }
                    let jsonDecoder = JSONDecoder()
                    do {
                        models = try jsonDecoder.decode([ListModel].self, from: jsonData)
                        completion(models)
                    } catch let error {
                        print(error)
                    }
                    break
                case .failure(let error):
                    print(error)
                }
            }
        completion(models)
    }
    
    public func deleteList(with id: String, completion: ((Bool) -> Void)?) {
        AF.request("\(baseURL)/list/\(id)",
                   method: .delete)
            .validate()
            .response { dataResponse in
                switch dataResponse.result {
                case .success:
                    guard let completion = completion else {
                        return
                    }
                    completion(true)
                    return
                case .failure(let error):
                    print(error)
                    guard let completion = completion else {
                        return
                    }
                    completion(false)
                    return
                }
            }
    }
    
    public func patchList(with id: String, and title: String, completion: ((Bool) -> Void)?) {
        AF.request("\(baseURL)/list/\(id)",
                   method: .patch,
                   parameters: ["title": title])
            .validate()
            .response { dataResponse in
                switch dataResponse.result {
                case .success:
                    guard let completion = completion else {
                        return
                    }
                    completion(true)
                case .failure(let error):
                    print(error)
                    guard let completion = completion else {
                        return
                    }
                    completion(false)
                }
            }
    }
    
    public func createTodo(for listId: Int, with text: String, and checked: Bool, completion: @escaping ((TodoModel?) -> Void)) {
        AF.request("\(baseURL)/list/\(listId)/todo",
                   method: .post,
                   parameters: ["text": text, "checked": checked])
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success:
                    guard let jsonData = dataResponse.data else { return }
                    let jsonDecoder = JSONDecoder()
                    do {
                        let model = try jsonDecoder.decode(TodoModel.self, from: jsonData)
                        completion(model)
                    } catch let error {
                        print(error)
                        completion(nil)
                    }
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
            }
    }
    
    public func editTodo(for listId: Int, and todoId: Int, with text: String, and checked: Bool, completion: @escaping ((TodoModel?) -> Void)) {
        AF.request("\(baseURL)/list/\(listId)/todo/\(todoId)",
                   method: .patch,
                   parameters: ["text": text, "checked": checked])
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success:
                    guard let jsonData = dataResponse.data else { return }
                    let jsonDecoder = JSONDecoder()
                    do {
                        let model = try jsonDecoder.decode(TodoModel.self, from: jsonData)
                        completion(model)
                    } catch let error {
                        print(error)
                        completion(nil)
                    }
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
            }
    }
    
    public func removeTodo(for listId: Int, and todoId: Int, completion: ((Bool) -> Void)?) {
        AF.request("\(baseURL)/list/\(listId)/todo/\(todoId)",
                   method: .delete)
            .validate()
            .response { dataResponse in
                switch dataResponse.result {
                case .success:
                    guard let completion = completion else {
                        return
                    }
                    completion(true)
                case .failure(let error):
                    print(error)
                    guard let completion = completion else {
                        return
                    }
                    completion(false)
                }
            }
    }
}
