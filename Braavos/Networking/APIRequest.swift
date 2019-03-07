//
//  APIRequest.swift
//
//

import Foundation

/// A protocol which will have the ability to create a URLRequest and parse an object from Data
public protocol APIRequest {
    associatedtype ResponseDataType

    var api: API { get }
    func makeRequest() throws -> URLRequest
    func parseResponse(from data: Data) throws -> ResponseDataType
}

