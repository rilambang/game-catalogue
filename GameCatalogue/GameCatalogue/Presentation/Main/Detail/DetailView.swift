//
//  DetailView.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import SwiftUI
import Detail

struct DetailView: View {
    var gameId: Int
    @StateObject var detailVM: DetailViewModel
    @State var indexDataFavorite = 0
    @Environment(\.managedObjectContext) private var viewContext

    init(detailVM: DetailViewModel, gameId: Int) {
        _detailVM = StateObject(wrappedValue: detailVM)
        self.gameId = gameId
    }

    var body: some View {
        ZStack {
            switch detailVM.detailState {
            case .loaded:
                DetailMainView(dataDetail: $detailVM.dataDetail, addFavorite: detailVM.addFavorite, deleteFavorite: detailVM.deleteFavorite)
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            case .failed:
                Text("Data not found")
                    .font(.title)
            }
        }
        .onAppear {
            Task.init {
                await detailVM.loadData(gameId)
            }
        }
        .navigationTitle(detailVM.dataDetail?.name ?? "")
    }
}
