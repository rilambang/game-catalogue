//
//  FavoriteView.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import SwiftUI
import Favorite

struct FavoriteView: View {
    var columns = Array(repeating: GridItem(.flexible()), count: 1)
    @StateObject var favVM: FavoriteViewModel
    @EnvironmentObject var diContainer: Injection
    init(favVM: FavoriteViewModel) {
        _favVM = StateObject(wrappedValue: favVM)
    }
    public var body: some View {
        VStack {
            FavoriteMainView(favorites: favVM.favorites)
        }
        .onAppear {
            favVM.getAllFavorites()
        }
        .navigationTitle("Favorite")
    }
}
