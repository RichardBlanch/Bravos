//
//  KeyedContainer+Bravos.swift
//  Braavos
//
//  Created by Richard Blanchard on 2/11/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {

    /// Decodes a value of any decodable type and transforms that type into your type of interest
    ///
    /// - Parameters:
    ///   - type: Your decoded type
    ///   - key: The key for your decoded value
    ///   - transform: A closure which will transform your decoded type into your type of interest
    /// - Returns: Your Transformed Type
    func decode<Initial: Decodable, ElementOfResult>(_ type: Initial.Type, forKey key: K, transform: (Initial) throws -> ElementOfResult) throws -> ElementOfResult {
        let initialType = try decode(Initial.self, forKey: key)
        let elementOfResult = try transform(initialType)

        return elementOfResult
    }

    /// Decodes a value IF that value is present of any decodable type and transforms that type into your type of interest
    ///
    /// - Parameters:
    ///   - type: Your decoded type
    ///   - key: The key for your decoded value
    ///   - transform: A closure which will transform your decoded type into your type of interest
    /// - Returns: Your Transformed Type
    func decodeIfPresent<Initial: Decodable, ElementOfResult>(_ type: Initial.Type, forKey key: K, transform: (Initial) throws -> ElementOfResult) throws -> ElementOfResult? {
        guard let initialType = try decodeIfPresent(Initial.self, forKey: key) else { return nil }
        let elementOfResult = try transform(initialType)

        return elementOfResult
    }
}
