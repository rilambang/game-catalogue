//
//  HomeView.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import SwiftUI

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
                VStack {
                    TextField("Search games...", text: $searchText)
                        .padding()
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {

                            ForEach(homeVM.dataGames.filter { game in
                                searchText.isEmpty ?
                                true : game.name?.lowercased().contains(searchText.lowercased()) ?? false
                            }, id: \.id) { item in
                                NavigationLink(
                                    destination:
                                        DetailView(detailVM: diContainer.provideDetail(), gameId: item.id ?? 0)
                                        .environment(\.managedObjectContext, viewContext)
                                ) {
                                    GameCardView(image: item.backgroundImage ?? "",
                                                 name: item.name ?? "",
                                                 released: item.released ?? "",
                                                 rating: item.rating ?? 0.0)
                                }
                            }

                        }
                        .navigationBarItems(trailing:
                                                HStack {
                            Button(action: { showProfile = true }) {
                                Image(systemName: "person.circle")
                                    .foregroundColor(.white)
                            }
                            NavigationLink(destination: FavoriteView(favVM: diContainer.provideFavorite())) {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.pink)
                            }
                            .padding(.trailing, 8)
                        }
                        )
                    }
                    .padding(.top, 8)
                    Spacer()
                }
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
        .sheet(isPresented: $showFavorites) {
            FavoriteView(favVM: diContainer.provideFavorite())
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
        .navigationTitle("Game Catalogue")
    }
}

// struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(homeVM: HomeViewModel(homeServices: HomeServices()))
//    }
// }
