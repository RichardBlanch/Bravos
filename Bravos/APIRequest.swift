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

    func makeRequest(from requestType: RequestDataType) throws -> URLRequest
    func parseResponse(from data: Data) throws -> ResponseDataType
}


