//
//  FavoriteViewModel.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import Foundation

class FavoriteViewModel: ObservableObject {
    @Published var favorites: [Favorite] = []
    private let useCase: FavoriteUseCaseProtocol

    init(useCase: FavoriteUseCaseProtocol) {
        self.useCase = useCase
    }

    func getAllFavorites() {
        favorites = useCase.getAllFavorites()
    }
}
