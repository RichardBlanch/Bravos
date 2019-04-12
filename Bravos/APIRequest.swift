//
//  APIRequest.swift
//  Bravos
//
//  Created by Richard Blanchard on 6/23/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import Foundation

public protocol APIRequest: Hashable {
    associatedtype RequestDataType
    associatedtype ResponseDataType: Codable
    
    var api: API { get }
    var requestPayload: RequestDataType { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [HTTPHeader]? { get }
    var body: Data? { get }
    
    func makeRequest() throws -> URLRequest
    func parseResponse(from data: Data) throws -> ResponseDataType
}

public extension APIRequest {
    func makeRequest() throws -> URLRequest {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = api.baseURL.scheme
        urlComponents.host = api.baseURL.host
        urlComponents.path = api.baseURL.path
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url?.appendingPathComponent(path) else {
            // throw error here
            fatalError()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body
        
        headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        
        return urlRequest
    }
}


