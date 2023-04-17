//
//  GameCardView.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import SwiftUI

struct GameCardView: View {
  
  var image = "default"
  var name = ""
  var released = ""
  var rating = 0.0
  var isDetail = false
  var body: some View {
    VStack {
      imageCategory
      content
    }
    .frame(maxWidth: (UIScreen.main.bounds.width - 32), minHeight: 250 , maxHeight: .infinity)
    .background(Color.random.opacity(0.3))
    .cornerRadius(30)
  }
  
}

extension GameCardView {
  
  var imageCategory: some View {
    
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
  
  var content: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(name)
        .padding(.horizontal, 8)
        .font(.headline)
        .multilineTextAlignment(.leading)
        .foregroundColor(.white)
      Spacer()
      HStack {
        Text(changeDateFormat(released) ?? "")
          .font(.footnote)
          .foregroundColor(.white)
        Spacer()
        Image(systemName: "star.fill")
          .foregroundColor(.yellow)
        Text(String(rating))
          .font(.footnote)
          .foregroundColor(.white)
      }
      .padding(16)
    }
  }
  
}
