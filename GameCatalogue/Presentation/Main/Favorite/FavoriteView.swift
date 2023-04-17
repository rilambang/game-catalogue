//
//  FavoriteView.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import SwiftUI

struct FavoriteView: View {
    var columns = Array(repeating: GridItem(.flexible()), count: 1)
    @StateObject var favVM: FavoriteViewModel
    @EnvironmentObject var diContainer: Injection
    init(favVM: FavoriteViewModel) {
        _favVM = StateObject(wrappedValue: favVM)
    }
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    if !favVM.favorites.isEmpty {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(favVM.favorites, id: \.id) { item in
                                    NavigationLink(destination: DetailView(detailVM: diContainer.provideDetail(), gameId: Int(item.id))) {
                                        GameCardView(image: item.image , name: item.title, released: item.releaseDate, rating: item.rating, isDetail: true )
                                    }
                                }
                            }
                        }
                        .padding(.top, 8)
                    } else {
                        Text("You have no favorites")
                            .font(.title)
                    }
                }
                Spacer()
            }
        }
        .onAppear {
          favVM.getAllFavorites()
        }
        .navigationTitle("Favorite")
    }
}

// struct FavoriteView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteView()
//    }
// }
