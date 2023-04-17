//
//  DetailServices.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import Foundation
import Combine

protocol DetailProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    func getDetailGames(endPoint : NetworkFactory) -> AnyPublisher<GameDetailModel, Error>
}

final class DetailServices: DetailProtocol {
    var networker: NetworkerProtocol
    init(networker: NetworkerProtocol = Networker()) {
        self.networker = networker
    }
    func getDetailGames(endPoint : NetworkFactory) -> AnyPublisher<GameDetailModel, Error> {
        return networker.get(type: GameDetailModel.self, endPoint: endPoint)
    }
}
