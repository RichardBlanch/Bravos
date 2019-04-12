//
//  APIRequestHandler.swift
//  Bravos
//
//  Created by Richard Blanchard on 4/11/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation

public struct APIRequestHandler<T: APIRequest, H: APIResponseHandler> where T.ResponseDataType == H.ResponseDataType {
    typealias ResponseType = T.ResponseDataType
    public let apiRequest: T
    public let apiResponseHandler: H
    
    public init(apiRequest: T, apiResponseHandler: H) {
        self.apiRequest = apiRequest
        self.apiResponseHandler = apiResponseHandler
    }
}

extension APIRequestHandler: Hashable {
}
