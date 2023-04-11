//
//  FavoriteMainView.swift
//  Favorite
//
//  Created by Muhammad Ilham Rilambang on 11/04/23.
//

import SwiftUI
import Core
import Component

public struct FavoriteMainView: View {
    var columns = Array(repeating: GridItem(.flexible()), count: 1)
    public var favorites: [Favorite]
    public init(favorites: [Favorite]){
        self.favorites = favorites
    }
    public var body: some View {
        ZStack {
            VStack {
                ZStack {
                    if !favorites.isEmpty {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(favorites, id: \.id) { item in
                                        GameCardView(image: item.image, name: item.title, released: item.releaseDate, rating: item.rating )
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
        .navigationTitle("Favorite")
    }
}
