//
//  HomeView.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import SwiftUI
import Component
import Home
import Profile

struct HomeView: View {
    
    @StateObject var homeVM: HomeViewModel
    @State private var searchText = ""
    @State var showProfile = false
    @State var showFavorites = false
    
    var columns = Array(repeating: GridItem(.flexible()), count: 1)
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var diContainer: Injection
    
    init(homeVM: HomeViewModel) {
        _homeVM = StateObject(wrappedValue: homeVM)
    }
    
    var body: some View {
        ZStack {
            switch homeVM.homeState {
            case .loaded:
                HomeMainView(
                    destinationFavoriteView: FavoriteView(favVM: diContainer.provideFavorite()),
                    destinationProfileView: ProfileView(),
                    destinationDetailView: DetailView(detailVM: diContainer.provideDetail(), gameId: homeVM.selectedId)
                        .environment(\.managedObjectContext, viewContext),
                    dataGames: $homeVM.dataGames,
                    selectedId: $homeVM.selectedId
                )
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                
            case .failed:
                Text("Data not found")
                    .font(.title)
            }
        }
        .onAppear {
            homeVM.loadData()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                homeVM.loadData()
            }
        }
        .navigationTitle("Game Catalogue")
    }
}
