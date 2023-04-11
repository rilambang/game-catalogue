//
//  FavoriteModel.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import Foundation

public struct Favorite {
    public init(id: Int32, title: String, image: String, releaseDate: String, rating: Double){
        self.id = id
        self.title = title
        self.image = image
        self.releaseDate = releaseDate
        self.rating = rating
    }
    public let id: Int32
    public let title: String
    public let image: String
    public let releaseDate: String
    public let rating: Double
}
