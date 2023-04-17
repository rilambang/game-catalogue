//
//  DetailViewModel.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import Foundation
import Combine
import CoreData

class DetailViewModel: ObservableObject {

    @Published var dataDetail: GameDetailModel?
    @Published var detailState: DetailState = .loading
    @Published var favouriteData: Favorite?
    @Published var indexFavourite: Int = 0
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
                    switch error as! NetworkError {
                    case .middlewareError:
                        self?.detailState = .loaded
                    }
                case .finished:
                    self?.detailState = .loaded
                }
            } receiveValue: { [weak self] result in
                self?.dataDetail = result
                self?.searchFavourite()
            }
            .store(in: &cancellable)
    }

    func changeDateFormat(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let showDate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let resultString = dateFormatter.string(from: showDate!)
        return resultString
    }

    func addDataFavourite() {
        if let data = dataDetail {
            let favorite = Favorite(id: Int32(data.id ?? 0), title: data.name ?? "", image: data.backgroundImage ?? "", releaseDate: data.released ?? "", rating: data.rating ?? 0.0)
            useCase.addNew(favorite: favorite)
            debugPrint("added:",favorite)
        }
    }

    func deleteFavourite() {
        if let data = favouriteData {
            useCase.delete(favorite: data)
            debugPrint("deleted:", data)
        }
    }

    func searchFavourite() {
        favouriteData = useCase.getFavoriteById(Int32(dataDetail?.id ?? 0))
        if favouriteData != nil {
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
