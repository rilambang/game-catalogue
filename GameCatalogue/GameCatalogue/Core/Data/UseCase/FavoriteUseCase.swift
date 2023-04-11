//
//  FavoriteUseCase.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import Foundation
import Core

protocol FavoriteUseCaseProtocol {
    func getAllFavorites() -> [Favorite]
    func addNew(favorite: Favorite)
    func delete(favorite: Favorite)
    func searchFavorites(withKeyword keyword: String) -> [Favorite]
    func getFavoriteById(_ id: Int32) -> Favorite?
}

class FavoriteUseCase: FavoriteUseCaseProtocol {
    private let repository: FavoriteRepositoryProtocol

    init(repository: FavoriteRepositoryProtocol) {
        self.repository = repository
    }

    func getAllFavorites() -> [Favorite] {
        return repository.getAllFavorites()
    }

    func addNew(favorite: Favorite) {
        repository.addNew(favorite: favorite)
    }

    func delete(favorite: Favorite) {
        repository.delete(favorite: favorite)
    }

    func searchFavorites(withKeyword keyword: String) -> [Favorite] {
        return repository.searchFavorites(withKeyword: keyword)
    }

    func getFavoriteById(_ id: Int32) -> Favorite? {
        return repository.getFavoriteById(id)
    }
}
