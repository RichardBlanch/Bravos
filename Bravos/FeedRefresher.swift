//
//  FeedRefresher.swift
//  Bravos
//
//  Created by Richard Blanchard on 4/11/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation

public class FeedRefresher {
    private static let shared = FeedRefresher()
    private var hash = Set<Int>()
    private let dispatchQueue = DispatchQueue(label: "hash")
    
    private func hasInstanceOfRequestHandlerHash(intValue: Int) -> Bool {
        return dispatchQueue.sync { return hash.contains(intValue) }
    }
    
    private func addHashValue(_ int: Int) {
        _ = dispatchQueue.sync { hash.insert(int) }
    }
    
    private func removeHashValue(_ int: Int) {
        _ = dispatchQueue.sync { hash.remove(int) }
    }
    
    private init() {
    }
    
    public static func add<T: APIRequest,H: APIResponseHandler>(requestHandler: APIRequestHandler<T,H>, timeInterval: TimeInterval, fetchImmediately: Bool = true, failure: @escaping (Error) -> Void) where T.ResponseDataType == H.ResponseDataType {
        shared.add(requestHandler: requestHandler, timeInterval: timeInterval, fetchImmediately: true, failure: failure)
    }
    
    private func add<T: APIRequest,H: APIResponseHandler>(requestHandler: APIRequestHandler<T,H>, timeInterval: TimeInterval, fetchImmediately: Bool, failure: @escaping (Error) -> Void) where T.ResponseDataType == H.ResponseDataType {
        guard !hasInstanceOfRequestHandlerHash(intValue: requestHandler.hashValue) else {
            print("ALREADY ADDED BRUH")
            return
        }
        
        addHashValue(requestHandler.hashValue)
        
        let workItem = DispatchWorkItem {
            let requestHandler = requestHandler
            APIRequestHandlerLoader<T, H>.loadAPIRequest(requestHandler: requestHandler, completion: { [weak self] _ in
                self?.removeHashValue(requestHandler.hashValue)
                self?.add(requestHandler: requestHandler, timeInterval: timeInterval, fetchImmediately: false, failure: failure)
            })
        }
        
        let dispatchTime: DispatchTime = fetchImmediately ? .now() : .now() + timeInterval
        DispatchQueue.global().asyncAfter(deadline: dispatchTime, execute: workItem)
    }
}
