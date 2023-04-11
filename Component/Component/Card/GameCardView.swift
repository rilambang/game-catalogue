//
//  GameCardView.swift
//  Component
//
//  Created by Muhammad Ilham Rilambang on 11/04/23.
//

import SwiftUI
import Core

public struct GameCardView: View {

    public var image = "default"
    public var name = ""
    public var released = ""
    public var rating = 0.0
    public init(image: String, name: String, released: String, rating: Double) {
            self.image = image
            self.name = name
            self.released = released
            self.rating = rating
        }
    public var body: some View {
        VStack {
            imageCategory
            content
        }
        .frame(maxWidth: (UIScreen.main.bounds.width - 32), minHeight: 250, maxHeight: .infinity)
        .background(Color.random.opacity(0.3))
        .cornerRadius(30)
    }

}

extension GameCardView {

    public var imageCategory: some View {

        AsyncImage(url: URL(string: image)) { image in
            image
                .resizable()
                .scaledToFill()

        } placeholder: {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
        }
        .frame(width: (UIScreen.main.bounds.width - 64), height: 200)
        .cornerRadius(30)
        .padding()
    }

    public var content: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(name)
                .padding(.horizontal, 16)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
            HStack {
                Text(changeDateFormat(released) ?? "")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .italic()
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(String(rating))
                    .font(.footnote)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }

}
