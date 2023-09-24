//
//  LogInManager.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import Alamofire

final class LogInManager {
    static let shared = LogInManager()
    private init() { }
    
    func signUp(name: String, email: String, password: String, url: String? = "") async -> TokenInfo? {
        guard let requestUrl = URL(string: BASEURL + "auth/signup") else { return nil }
        let params: [String: String] = [
            "username": name,
            "password": password,
            "email": email,
            "url": url ?? ""
        ]
        
        let request = AF.request(requestUrl, method: .post, parameters: params, encoding: JSONEncoding.default)
        return await getResult(request: request)
    }
    
    func logIn(email: String, password: String) async -> TokenInfo? {
        guard let requestUrl = URL(string: BASEURL + "auth/login") else { return nil }
        let params: [String: String] = [
            "email": email,
            "password": password
        ]
        
        let request = AF.request(requestUrl, method: .post, parameters: params, encoding: JSONEncoding.default)
        return await getResult(request: request)
    }
}

private extension LogInManager {
    private func getResult(request: DataRequest) async -> TokenInfo? {
        let dataTask = request.serializingDecodable(TokenInfo.self)
        
        switch await dataTask.result {
        case .success(let value):
            return value
            
        case .failure(let error):
            print(error)
            print(error.localizedDescription)
            return nil
        }
    }
}
