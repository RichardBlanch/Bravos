//
//  BravosError.swift
//  Bravos
//
//  Created by Richard Blanchard on 4/12/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation

public enum BravosError: Error {
    case genericError(Error?)
    case noData
    case responseAlreadyInProgress
    case httpURLResponseError(HTTPURLResponse)
}
