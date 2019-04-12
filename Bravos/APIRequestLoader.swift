//
//  APIRequestFactory.swift
//  Bravos
//
//  Created by Richard Blanchard on 6/23/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import Foundation

public class APIRequestLoader {
    
    public static func loadAPIRequest<T: APIRequest>(_ apiRequest: T, using urlSession: URLSession = URLSession.shared, completionHandler: @escaping ( Result<T.ResponseDataType, BravosError>) -> Void) {
        do {
            let urlRequest = try apiRequest.makeRequest()
            guard !isRequestInProgress(for: urlRequest.url) else { return }
            addURLToNetworkRegulator(url: urlRequest.url)

            urlSession.dataTask(with: urlRequest) {  data, response, error in
                self.removeURLFromNetworkMonitor(url: response?.url)
                
                if let bravosError = self.bravosError(from: data, error: error, response: response) {
                    completionHandler(.failure(bravosError))
                    return
                }
                
                do {
                    let parsedResponse = try apiRequest.parseResponse(from: data!)
                    completionHandler(.success(parsedResponse))
                } catch {
                    completionHandler(.failure(.genericError(error)))
                }

            }.resume()

        } catch {
            completionHandler(.failure(.genericError(error)))
        }
    }
    
    private static func bravosError(from data: Data?, error: Error?, response: URLResponse?) -> BravosError? {
        let bravosError: BravosError?

        if error != nil {
            bravosError = .genericError(error)
        } else if let httpURLResponse = response as? HTTPURLResponse, (400...499).contains(httpURLResponse.statusCode) {
            bravosError = .httpURLResponseError(httpURLResponse)
        } else if data == nil {
            bravosError = .noData
        } else {
            bravosError = nil
        }
 
        return bravosError
    }

    private static func addURLToNetworkRegulator(url: URL?) {
        guard let url = url else { return }
        APIRequestMonitor.shared.add(url: url)
    }

    private static func removeURLFromNetworkMonitor(url: URL?) {
        guard let url = url else { return }
        APIRequestMonitor.shared.remove(url: url)
    }

    private static func isRequestInProgress(for url: URL?) -> Bool {
        guard let url = url else { return false }
        return APIRequestMonitor.shared.hasURL(url)
    }
}
