//
//  FailableDecoder.swift
//  Braavos
//
//  Created by Richard Blanchard on 2/11/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation

public struct FailableDecodable<Base : Decodable> : Decodable {

    public let base: Base?

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}
