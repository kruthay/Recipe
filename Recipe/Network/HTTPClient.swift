//
//  HTTPClient.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/17/23.
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: EndPoint, responseModel: T.Type) async throws -> T
}

extension HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: EndPoint,
        responseModel: T.Type
    ) async throws -> T {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        if let queryItem = endpoint.queryItem {
            urlComponents.queryItems = [queryItem]
        }
        guard let url = urlComponents.url else {
            
            throw FoodAppErrors.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method?.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
        guard let response = response as? HTTPURLResponse else {
            throw FoodAppErrors.invalidResponse
        }
        
        switch response.statusCode {
        case 200...299:
            guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                throw FoodAppErrors.invalidResponse
            }
            return decodedResponse
        default:
            throw FoodAppErrors.invalidResponse
        }
        
    }
}
