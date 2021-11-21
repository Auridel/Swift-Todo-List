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
    
    public func getLists() -> [ListModel]? {
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
                    } catch let error {
                        print(error)
                    }
                    break
                case .failure(let error):
                    print(error)
                }
            }
        return models
    }
}
