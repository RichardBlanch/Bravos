//
//  APIRequestHandlerLoader.swift
//  Bravos
//
//  Created by Richard Blanchard on 4/12/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation

public class APIRequestHandlerLoader<T: APIRequest, H: APIResponseHandler> where T.ResponseDataType == H.ResponseDataType  {
    
    public static func loadAPIRequest<T: APIRequest>(requestHandler: APIRequestHandler<T,H>, completion: @escaping (Result<H.SuccessfulType, BravosError>) -> Void) {
        let apiRequest = requestHandler.apiRequest
        APIRequestLoader.loadAPIRequest(apiRequest, completionHandler: { result in
            switch result {
            case .success(let responseDataType):
                requestHandler.apiResponseHandler.handle(responseDataType: responseDataType, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
