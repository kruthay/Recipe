//
//  EndPoint.swift
//  Recipe
//
//  Created by Kruthay Kumar Reddy Donapati on 11/17/23.
//

import Foundation

protocol EndPoint {
    
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod? { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryItem: URLQueryItem? { get }
}

extension EndPoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "www.themealdb.com"
    }
}
