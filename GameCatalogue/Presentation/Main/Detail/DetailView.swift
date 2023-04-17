//
//  DetailView.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import SwiftUI

struct DetailView: View {
    var gameId: Int
    @StateObject var detailVM: DetailViewModel
    @State var indexDataFavourite = 0
    @Environment(\.managedObjectContext) private var viewContext

    init(detailVM: DetailViewModel, gameId: Int) {
        _detailVM = StateObject(wrappedValue: detailVM)
        self.gameId = gameId
    }

    var body: some View {
        ZStack {
            switch detailVM.detailState {
            case .loaded:
                VStack(alignment: .leading) {
                    ScrollView {
                        AsyncImage(url: URL(string: detailVM.dataDetail?.backgroundImage ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 200)
                        .cornerRadius(30)
                        .padding()
                        VStack(alignment: .leading) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    Text(detailVM.dataDetail?.name ?? "")
                                        .font(.headline)
                                    Text("Release date: \(detailVM.changeDateFormat(detailVM.dataDetail?.released ?? ""))")
                                        .font(.subheadline)
                                    Text(String("Rating: \(detailVM.dataDetail?.rating ?? 0)"))
                                        .font(.subheadline)
                                }
                                Spacer()
                                HStack {
                                    Button(action: {
                                        detailVM.dataDetail?.status.toggle()
                                        if detailVM.dataDetail?.status == true {
                                            detailVM.addDataFavourite()
                                        } else {
                                            detailVM.deleteFavourite()
                                        }
                                        Task.init {
                                            await detailVM.loadData(gameId)
                                        }
                                    }) {
                                        Image(systemName: detailVM.dataDetail?.status ?? false ? "heart.fill" : "heart")
                                        .foregroundColor(.pink)
                                    }
                                    Text("Favorite")
                                        .font(.subheadline)
                                }

                            }
                            .padding(.top, 16)
                            Text(detailVM.dataDetail?.descriptionRaw ?? "")
                                .padding(.top, 16)
                                .font(.body)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 1)
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
            Task.init {
                await detailVM.loadData(gameId)
            }
        }
        .navigationTitle(detailVM.dataDetail?.name ?? "")
    }
}
