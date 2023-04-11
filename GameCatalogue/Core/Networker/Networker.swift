//
//  Networker.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import Foundation
import Combine

protocol NetworkerProtocol: AnyObject {
    func get<T>(type: T.Type,
                endPoint: NetworkFactory
    ) -> AnyPublisher<T, Error> where T: Decodable

    func post<T>(type: T.Type, endPoint: NetworkFactory
    ) -> AnyPublisher<T, Error> where T: Decodable

}

final class Networker: NetworkerProtocol {
    func get<T>(type: T.Type, endPoint: NetworkFactory) -> AnyPublisher<T, Error> where T: Decodable {
        var urlRequest = URLRequest(url: endPoint.url)
        if let header = endPoint.headers {
            header.forEach { key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .print()
            .retry(2)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.middlewareError(code: 500, message: "Connection Error")
                }

                guard 200..<300 ~= httpResponse.statusCode else {
                    let res  = try JSONDecoder().decode(ErrorHandling.self, from: data)
                    let error = self.mapHTTPError(with: res.code, errorMessage: res.message)
                    throw error
                }
                return data
            }
            .mapError({ error -> NetworkError in
                guard let error = error as? NetworkError else {
                    return NetworkError.middlewareError(code: 500, message: error.localizedDescription)
                }
                return error
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func post<T>(type: T.Type, endPoint: NetworkFactory) -> AnyPublisher<T, Error> where T: Decodable {

#if DEVELOPMENT || NETFOX
        //            NFX.sharedInstance().start()
#endif
        var urlRequest = URLRequest(url: endPoint.url)
        urlRequest.httpMethod = "POST"
        if let header = endPoint.headers {
            header.forEach { key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: endPoint.bodyParam as Any)
        print("body \(urlRequest.httpBody!)")

        print(endPoint)
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .print()
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.middlewareError(code: 500, message: "Connection Error")
                }
                guard 200..<300 ~= httpResponse.statusCode else {
                    let res  = try JSONDecoder().decode(ErrorHandling.self, from: data)
                    let error = self.mapHTTPError(with: res.code, errorMessage: res.message)
                    throw error
                }
                let str = String(decoding: data, as: UTF8.self)
                print("ini data  \(str)")
                return data
            }
            .mapError({ error -> NetworkError in
                guard let error = error as? NetworkError else {
                    print("this error : \(error)")
                    return NetworkError.middlewareError(code: 500, message: error.localizedDescription)
                }
                return error
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

extension Networker {
    private func mapHTTPError(with code: Int, errorMessage: String) -> NetworkError {
        let error: NetworkError
        switch code {
        default:
            error = .middlewareError(code: code, message: errorMessage)
        }
        return error
    }
}
