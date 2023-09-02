//
//  ServerManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import Alamofire

final class ServerManager {
    static let shared = ServerManager()
    private init() { }
    
    private let subPath = "todos"
    
    /// [MyTodo]?
    func requestTodos<T: Codable>() async -> T? {
        guard let url = URL(string: BASEURL + subPath) else { return nil }
        
        let request = AF.request(url, method: .get)
        let result: T? = await getResult(request: request)
        return result
    }
    
    /// MyTodo?
    func createTodo<T: Codable>(data: Todo) async -> T? {
        guard let url = URL(string: BASEURL + subPath) else { return nil }
        let params: [String: Any] = [
            "content": data.content,
            "done": data.done
        ]
        
        let request = AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
        let result: T? = await getResult(request: request)
        return result
    }
    
    /// MyTodo?
    func updateTodo<T: Codable>(data: Todo, id: Int) async -> T? {
        guard let url = URL(string: BASEURL + subPath + "/\(id)") else { return nil }
        let params: [String: Any] = [
            "content": data.content,
            "done": data.done
        ]
        
        let request = AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default)
        let result: T? = await getResult(request: request)
        return result
    }
    
    func deleteTodo(id: Int) async -> Data? {
        guard let url = URL(string: BASEURL + subPath + "/\(id)") else { return nil }
        let request = AF.request(url, method: .delete)
        let dataTask = request.serializingData()
        
        switch await dataTask.result {
        case .success(let data):
            return data
            
        case .failure(let error):
            print("error: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func getResult<T: Codable>(request: DataRequest) async -> T? {
        let dataTask = request.serializingDecodable(T.self)
        
        switch await dataTask.result {
        case .success(let value):
            return value
            
        case .failure(let error):
            print(error.localizedDescription)
            return nil
        }
    }
}
