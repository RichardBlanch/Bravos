//
//  APIRequestFactory.swift
//
//

import Foundation
import CoreData

public enum RequestError: Error {
    case statusError(Int)
    case couldNotCreateData
}

public enum Result<T: APIRequest> {
    case success(T.ResponseDataType)
    case failure(Error)
}


open class APIRequestLoader<T: APIRequest> {

    public let apiRequest: T
    public let urlSession: URLSession

    public init(apiRequest: T, urlSession: URLSession = .shared) {
        self.apiRequest = apiRequest
        self.urlSession = urlSession
    }

    public func loadAPIRequest(completionHandler: @escaping (Result<T>) -> Void) {
        do {
            let urlRequest = try apiRequest.makeRequest()

            let task = urlSession.dataTask(with: urlRequest) {  data, response, error in
                let responseError = error ?? self.error(from: response as? HTTPURLResponse)

                guard responseError == nil else { completionHandler(.failure(error!)); return }
                guard let data = data else { completionHandler(.failure(RequestError.couldNotCreateData)); return }

                do {
                    let parsedResponse = try self.apiRequest.parseResponse(from: data)

                    completionHandler(.success(parsedResponse))

                    return
                } catch {
                    completionHandler(.failure(error))

                    return
                }
            }

            task.resume()

        } catch {
            completionHandler(.failure(error))
        }
    }

     func handleResponse(completionHandler: @escaping (Result<T>) -> Void) throws {
        do {
            let urlRequest = try apiRequest.makeRequest()
            let response = getResponse(from: urlRequest, completionHandler: completionHandler)
        } catch {
            throw error
        }
    }

     func getResponse(from urlRequest: URLRequest, completionHandler: @escaping (Result<T>) -> Void) {
        let task = urlSession.dataTask(with: urlRequest) {  data, response, error in
            let responseError = error ?? self.error(from: response as? HTTPURLResponse)

            guard responseError == nil else { completionHandler(.failure(responseError!)); return }
            guard let data = data else { completionHandler(.failure(RequestError.couldNotCreateData)); return }

            do {
                let parsedResponse = try self.apiRequest.parseResponse(from: data)
                completionHandler(.success(parsedResponse))
            } catch {
                completionHandler(.failure(error))
            }
        }

        task.resume()
    }

     func error(from urlResponse: HTTPURLResponse?) -> Error? {
        guard let statusCode = urlResponse?.statusCode else { return nil }

        return (400...599).contains(statusCode) ? RequestError.statusError(statusCode) : nil
    }
}

final public class APIRequestPersister<T: APIRequest, P: Persister>: APIRequestLoader<T> {
    let persister: P

    public init(apiRequest: T, urlSession: URLSession, persister: P) {
        self.persister = persister

        super.init(apiRequest: apiRequest, urlSession: urlSession)
    }

    public func persist(container: NSPersistentContainer, completion: @escaping (_ inner: () throws -> Void) -> Void) throws -> Void {
        let viewContext = container.viewContext

        do {
            try handleResponse(completionHandler: { (result) in
                switch result {
                case .failure(let error): completion({throw error})
                case .success(let responseDataType):
                    guard let responseDataType = responseDataType as? P.ResponseDataType else { fatalError() }
                    try? self.persister.transform(responseDataType: responseDataType, in: viewContext)
                }
            })
        } catch {
            throw error
        }
    }
}
