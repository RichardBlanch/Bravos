//
//  APIRequestFactory.swift
//  Bravos
//
//  Created by Richard Blanchard on 6/23/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import Foundation

class APIRequestMonitor {
    public static let shared = APIRequestMonitor()

    private var _currentlyRequestedURLS = Set<URL>()
    private var currentlyRequestedURLS: Set<URL> {
        get {
            return DispatchQueue.global(qos: .default).sync(execute: { return _currentlyRequestedURLS })
        }

        set {
            DispatchQueue.global(qos: .default).sync(execute: { _currentlyRequestedURLS = newValue })
        }
    }

    func hasURL(_ url: URL) -> Bool {
        return currentlyRequestedURLS.contains(url)
    }

    func add(url: URL) {
        currentlyRequestedURLS.insert(url)
    }

    func remove(url: URL) {
        currentlyRequestedURLS.remove(url)
    }
}
