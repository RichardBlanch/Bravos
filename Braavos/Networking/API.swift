//
//  API.swift
//  Braavos
//
//  Created by Richard Blanchard on 2/11/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation

public protocol API {
    var scheme: String? { get }
    var host: String? { get }
    var versionNumber: Int? { get }
}

public extension API {
    var baseURL: URL? {
        var urlComponents = URLComponents()

        urlComponents.scheme = scheme
        urlComponents.host = host

        return urlComponents.url
    }

    var versionNumber: Int? {
        return nil
    }
}
