//
//  APIResponseHandler.swift
//  Bravos
//
//  Created by Richard Blanchard on 4/11/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation

public protocol APIResponseHandler: Hashable {
    associatedtype ResponseDataType
    associatedtype SuccessfulType
    
    func handle(responseDataType: ResponseDataType, completion: @escaping (Result<SuccessfulType, BravosError>) -> Void)
}
