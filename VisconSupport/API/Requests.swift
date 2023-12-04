//
//  Requests.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 03/12/2023.
//

import Foundation

class Requests {
    static var ServerUrl = "https://api.project-c.zoutigewolf.dev/"
    
    static func Get(url: String, completion: @escaping (Result<[String : Any]?, Error>) -> Void) {
        MakeRequest(urlString: url, method: "GET", parameters: nil, completion: completion)
    }

    static func Post(url: String, parameters: [String: Any]?, completion: @escaping (Result<[String : Any]?, Error>) -> Void) {
        MakeRequest(urlString: url, method: "POST", parameters: parameters, completion: completion)
    }

    private static func MakeRequest(urlString: String, method: String, parameters: [String: Any]?, completion: @escaping (Result<[String : Any]?, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.uppercased()
        
        if let authToken = Authentication.shared.token {
            request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }

        if let parameters = parameters {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(NetworkError.invalidRequestBody))
                return
            }
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            if (400..<500).contains(httpResponse.statusCode) {
                let clientError = NSError(domain: NSURLErrorDomain, code: httpResponse.statusCode, userInfo: nil)
                completion(.failure(clientError))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(NetworkError.invalidResponseFormat))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

}

enum NetworkError: Error {
    case invalidURL
    case invalidRequestBody
    case invalidResponseFormat
    case invalidResponse
    case noData
}
