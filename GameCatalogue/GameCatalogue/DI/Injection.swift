//
//  Injection.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import Foundation
import CoreData

class Injection: ObservableObject {
    lazy var coreDataContainer: PersistenceController = {
        PersistenceController.shared
    }()
    lazy var favoriteRepository: FavoriteRepository = {
        FavoriteRepository(container: coreDataContainer.container)
    }()
    lazy var favoriteUseCase: FavoriteUseCase = {
        FavoriteUseCase(repository: favoriteRepository)
    }()
    func provideNetworker() -> Networker {
      return Networker()
    }

    func provideHome() -> HomeViewModel {
        return HomeViewModel(homeServices: provideHomeServices())
    }

    func provideDetail() -> DetailViewModel {
        return DetailViewModel(detailServices: provideDetailServices(), useCase: favoriteUseCase)
    }

    func provideFavorite() -> FavoriteViewModel {
        return FavoriteViewModel(useCase: favoriteUseCase)
    }

    func provideHomeServices() -> HomeServices {
      return HomeServices(networker: provideNetworker())
    }

    func provideDetailServices() -> DetailServices {
      return DetailServices(networker: provideNetworker())
    }
}
