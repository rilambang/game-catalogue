//
//  HomeMainView.swift
//  Home
//
//  Created by Muhammad Ilham Rilambang on 11/04/23.
//

import SwiftUI
import Core
import Component

public struct HomeMainView<Favorite: View, Profile: View, Detail: View>: View {
    var destinationFavoriteView: Favorite
    var destinationProfileView: Profile
    var destinationDetailView: Detail
    var columns = Array(repeating: GridItem(.flexible()), count: 1)
    @Binding public var dataGames: [DataGames]
    @Binding public var selectedId: Int
    @State var isDetail: Bool = false
    @State var showProfile = false
    public init(
        destinationFavoriteView: Favorite,
        destinationProfileView: Profile,
        destinationDetailView: Detail,
        dataGames: Binding<[DataGames]>,
        selectedId: Binding<Int>
    )
    {
        self.destinationFavoriteView = destinationFavoriteView
        self.destinationProfileView = destinationProfileView
        self.destinationDetailView = destinationDetailView
        self._dataGames = dataGames
        self._selectedId = selectedId
    }
    @State private var searchText = ""
    public var body: some View {
        VStack {
            TextField("Search games...", text: $searchText)
                .padding()
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {

                    ForEach(dataGames.filter { game in
                        searchText.isEmpty ?
                        true : game.name?.lowercased().contains(searchText.lowercased()) ?? false
                    }, id: \.id) { item in
                        NavigationLink(
                            destination: destinationDetailView,
                            isActive: $isDetail
                        ) {
                            Button(action: {
                                selectedId = item.id ?? 0
                                isDetail = true
                            }, label: {
                                GameCardView(image: item.backgroundImage ?? "", name: item.name ?? "", released: item.released ?? "", rating: item.rating ?? 0.0)
                            })
                        }
                    }

                }
                .navigationBarItems(trailing:
                                        HStack {
                    Button(action: { showProfile = true }) {
                        Image(systemName: "person.circle")
                            .foregroundColor(.white)
                    }
                    NavigationLink(destination: destinationFavoriteView) {
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
        .sheet(isPresented: $showProfile) {
            destinationProfileView
        }
    }
}
