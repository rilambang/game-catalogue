//
//  NetworkError.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import Foundation

enum NetworkError: Error, LocalizedError {

    case middlewareError(code: Int, message: String?)
    var localizedDescription: String {
        switch self {
        case .middlewareError(_, let message):
            return message ?? ""
        }
    }
}

struct ErrorHandling: Decodable, Error, LocalizedError {
    let success: Bool
    let data: DataClass
    let message: String
    let code: Int
    let codeName: String

    enum CodingKeys: String, CodingKey {
        case success, data, message, code
        case codeName = "code_name"
    }
}

// MARK: - DataClass
struct DataClass: Decodable {
}

