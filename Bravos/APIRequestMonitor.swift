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

    private let dispatchQueue = DispatchQueue(label: "com.APIRequestMonitorQueue")
    private var currentlyRequestedURLS = Set<URL>()

    func hasURL(_ url: URL) -> Bool {
        return dispatchQueue.sync { return currentlyRequestedURLS.contains(url) }
    }

    func add(url: URL) {
        _ = dispatchQueue.sync { currentlyRequestedURLS.insert(url) }
    }

    func remove(url: URL) {
        _ = dispatchQueue.sync { currentlyRequestedURLS.remove(url) }
    }
}
