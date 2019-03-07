//
//  MockURLSession.swift
//
//

import Foundation

extension URLSession {
    public static func mockURLSession(mockingWithData data: Data?, response: HTTPURLResponse = HTTPURLResponse()) -> URLSession {
        let config = URLSessionConfiguration.ephemeral

        MockURLProtocol.requestHandler = { request in
            return (response, data)
        }

        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }
}
