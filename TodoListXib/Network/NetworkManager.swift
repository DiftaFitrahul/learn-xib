//
//  NetworkManager.swift
//  TodoListXib
//
//  Created by MacBook Difta on 14/10/24.
//

import Foundation


class NetworkManager{
    static let shared = NetworkManager()
    private init () {}
    let baseStringURL = "https://63803e922f8f56e28e9ebeab.mockapi.io/todo"
    
    func getTodo(completionHandler: @escaping (Result<[Todo], ErrorNetworkMessage>) -> Void) -> Void{
        let url = URL(string: baseStringURL)!
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard data != nil else{
                completionHandler(.failure(.dataError))
                return
            }
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                completionHandler(.failure(.responseError))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let result = try decoder.decode([Todo].self, from: data!)
                completionHandler(.success(result))
            }catch{
                completionHandler(.failure(.responseError))
            }
        }.resume()
    }
    
    
    func postTodo(todo: PostTodo, completionHandler: @escaping (Bool)->()) -> Void{
        let url = URL(string: baseStringURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(todo)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
          
            guard error == nil else{
                completionHandler(false)
                return
            }
            completionHandler(true)
            
        }.resume()
        
        
    }
    
    func putTodo(todo: Todo, completionHandler: @escaping (Bool)->()) -> Void{
        let url = URL(string: "\(baseStringURL)/\(todo.id)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(todo)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
          
            guard error == nil else{
                completionHandler(false)
                return
            }
            completionHandler(true)
            
        }.resume()
        
        
    }
    
    func deleteTodo(id: String, completionHandler: @escaping (Bool)->()) -> Void{
        let url = URL(string: "\(baseStringURL)/\(id)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, response, error in
          
            guard error == nil else{
                completionHandler(false)
                return
            }
            completionHandler(true)
            
        }.resume()
        
        
    }
    
}
