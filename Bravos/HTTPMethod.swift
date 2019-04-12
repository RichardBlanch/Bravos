//
//  HTTPMethod.swift
//  Bravos
//
//  Created by Richard Blanchard on 4/11/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}
