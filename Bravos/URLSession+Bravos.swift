//
//  MockURLSession.swift
//  Bravos
//
//  Created by Richard Blanchard on 6/23/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import Foundation

extension URLSession {
    public static func mockURLSession(mockingWithData data: Data) -> URLSession {
        let config = URLSessionConfiguration.ephemeral

        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), data)
        }

        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }
}
