//
//  HomeServices.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import Foundation
import Combine
import Core

protocol HomeProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    func getListGames(endPoint: NetworkFactory) -> AnyPublisher<GamesModel, Error>
}

final class HomeServices: HomeProtocol {
    var networker: NetworkerProtocol
    init(networker: NetworkerProtocol) {
        self.networker = networker
    }
    func getListGames(endPoint: NetworkFactory) -> AnyPublisher<GamesModel, Error> {
        return networker.get(type: GamesModel.self, endPoint: endPoint)
    }
}
