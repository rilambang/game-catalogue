//
//  HomeViewModel.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var dataGames: [DataGames] = []
    @Published var homeState: HomeState = .loading
    
    private let homeServices: HomeProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(homeServices: HomeProtocol) {
        self.homeServices = homeServices
    }
    
    func loadData() {
        homeState = .loading
        homeServices.getListGames(endPoint: .getListGames)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    if case .middlewareError = error as? NetworkError {
                        self?.homeState = .loaded
                    } else {
                        self?.homeState = .failed
                    }
                case .finished:
                    self?.homeState = .loaded
                }
            } receiveValue: { [weak self] result in
                self?.dataGames = result.results ?? []
            }
            .store(in: &cancellables)
    }
}

extension HomeViewModel {
    enum HomeState {
        case loading
        case loaded
        case failed
    }
}
