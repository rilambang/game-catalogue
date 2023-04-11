//
//  DetailViewModel.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import Foundation
import Combine
import CoreData
import Core

class DetailViewModel: ObservableObject {

    @Published var dataDetail: GameDetailModel?
    @Published var detailState: DetailState = .loading
    @Published var favoriteData: Favorite?
    @Published var indexFavorite: Int = 0
    private var cancellable = Set<AnyCancellable>()
    private var detailServices: DetailProtocol
    private let useCase: FavoriteUseCaseProtocol
    init(detailServices: DetailProtocol, useCase: FavoriteUseCase) {
        self.detailServices = detailServices
        self.useCase = useCase
    }

    func loadData(_ gameId: Int) async {
        detailServices.getDetailGames(endPoint: .getDetailGames(id: String(gameId)))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .middlewareError:
                            self?.detailState = .loaded
                        }
                    }
                case .finished:
                    self?.detailState = .loaded
                }
            } receiveValue: { [weak self] result in
                self?.dataDetail = result
                self?.searchFavorite()
            }
            .store(in: &cancellable)
    }

    func addFavorite() {
        if let data = dataDetail {
            let favorite = Favorite(id: Int32(data.id ?? 0), title: data.name ?? "", image: data.backgroundImage ?? "", releaseDate: data.released ?? "", rating: data.rating ?? 0.0)
            useCase.addNew(favorite: favorite)
        }
    }

    func deleteFavorite() {
        if let data = favoriteData {
            useCase.delete(favorite: data)
        }
    }

    func searchFavorite() {
        favoriteData = useCase.getFavoriteById(Int32(dataDetail?.id ?? 0))
        if favoriteData != nil {
            dataDetail?.status = true
        } else {
            dataDetail?.status = false
        }
    }
}

extension DetailViewModel {
    enum DetailState {
        case loading
        case loaded
        case failed
    }
}
