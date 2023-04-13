//
//  FavoriteMainView.swift
//  Favorite
//
//  Created by Muhammad Ilham Rilambang on 11/04/23.
//

import SwiftUI
import Core
import Component

public struct FavoriteMainView<Detail: View>: View {
    var destinationDetailView: Detail
    var columns = Array(repeating: GridItem(.flexible()), count: 1)
    public var favorites: [Favorite]
    @Binding public var selectedId: Int
    @State var isDetail: Bool = false
    public init(favorites: [Favorite], destinationDetailView: Detail,
                selectedId: Binding<Int>){
        self.destinationDetailView = destinationDetailView
        self.favorites = favorites
        self._selectedId = selectedId
    }
    public var body: some View {
        ZStack {
            VStack {
                ZStack {
                    if !favorites.isEmpty {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(favorites, id: \.id) { item in
                                    NavigationLink(
                                        destination: destinationDetailView,
                                        isActive: $isDetail
                                    ) {
                                        Button(action: {
                                            selectedId = Int(item.id ?? 0)
                                            isDetail = true
                                        }, label: {
                                            GameCardView(image: item.image ?? "", name: item.title ?? "", released: item.releaseDate ?? "", rating: item.rating ?? 0.0)
                                        })
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
        .navigationTitle("Favorite")
    }
}
