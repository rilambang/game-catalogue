//
//  DetailMainView.swift
//  Detail
//
//  Created by Muhammad Ilham Rilambang on 11/04/23.
//

import SwiftUI
import Core

public struct DetailMainView: View {
    
    @Binding public var dataDetail: GameDetailModel?
    public var addFavorite: () -> Void = {}
    public var deleteFavorite: () -> Void = {}
    public init(dataDetail: Binding<GameDetailModel?>, addFavorite: @escaping () -> Void, deleteFavorite: @escaping () -> Void) {
        self._dataDetail = dataDetail
        self.addFavorite = addFavorite
        self.deleteFavorite = deleteFavorite
    }

    public var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                AsyncImage(url: URL(string: dataDetail?.backgroundImage ?? "")) { image in
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
                            Text(dataDetail?.name ?? "")
                                .font(.headline)
                            Text("Release date: \(changeDateFormat(dataDetail?.released ?? "N/A") ?? "N/A")")
                                .font(.subheadline)
                                .italic()
                            Text(String("Rating: \(dataDetail?.rating ?? 0)"))
                                .font(.subheadline)
                        }
                        Spacer()
                        HStack {
                            Button(action: {
                                dataDetail?.status.toggle()
                                if dataDetail?.status == true {
                                    addFavorite()
                                } else {
                                    deleteFavorite()
                                }
                            }) {
                                Image(systemName: dataDetail?.status ?? false ? "heart.fill" : "heart")
                                    .foregroundColor(.pink)
                            }
                            Text("Favorite")
                                .font(.subheadline)
                        }

                    }
                    .padding(.top, 16)
                    Text(dataDetail?.descriptionRaw ?? "")
                        .padding(.top, 16)
                        .font(.body)
                }
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 1)
        }
    }
}
