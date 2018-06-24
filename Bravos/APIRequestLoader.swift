//
//  APIRequestFactory.swift
//  Bravos
//
//  Created by Richard Blanchard on 6/23/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import Foundation

public enum Result<T: APIRequest> {
    case success(T.ResponseDataType)
    case failure(Error)
}


open class APIRequestLoader<T: APIRequest> {

    public let apiRequest: T
    public let urlSession: URLSession
    private let requestInfo: T.RequestDataType
    private unowned let networkMonitor = APIRequestMonitor.shared

    public init(apiRequest: T, requestInfo: T.RequestDataType, urlSession: URLSession = .shared) {
        self.apiRequest = apiRequest
        self.urlSession = urlSession
        self.requestInfo = requestInfo
    }

    public func loadAPIRequest(completionHandler: @escaping (Result<T>) -> Void) {
        do {
            let urlRequest = try apiRequest.makeRequest(from: requestInfo)
            guard !isRequestInProgress(for: urlRequest.url) else { return }
            addURLToNetworkRegulator(url: urlRequest.url)

            urlSession.dataTask(with: urlRequest) {  data, response, error in
                self.removeURLFromNetworkMonitor(url: response?.url)

                guard error == nil else { completionHandler(.failure(error!)); return }
                guard let data = data else { completionHandler(.failure( NSError.init(domain: "BRAVOS COULD NOT RETRIEVE DATA", code: 0, userInfo: nil))); return }

                do {
                    let parsedResponse = try self.apiRequest.parseResponse(from: data)
                    completionHandler(.success(parsedResponse))
                } catch {
                    completionHandler(.failure(error))
                }

            }.resume()

        } catch {
            completionHandler(.failure(error))
        }
    }

    private func addURLToNetworkRegulator(url: URL?) {
        guard let url = url else { return }
        networkMonitor.add(url: url)
    }

    private func removeURLFromNetworkMonitor(url: URL?) {
        guard let url = url else { return }
        networkMonitor.remove(url: url)
    }

    private func isRequestInProgress(for url: URL?) -> Bool {
        guard let url = url else { return false }
        return networkMonitor.hasURL(url)
    }
}
