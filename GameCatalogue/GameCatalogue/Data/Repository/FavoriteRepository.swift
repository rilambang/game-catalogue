//
//  FavoriteRepository.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import Foundation
import CoreData
import Core

protocol FavoriteRepositoryProtocol {
    func getAllFavorites() -> [Favorite]
    func addNew(favorite: Favorite)
    func delete(favorite: Favorite)
    func searchFavorites(withKeyword keyword: String) -> [Favorite]
    func getFavoriteById(_ id: Int32) -> Favorite?
}

class FavoriteRepository: FavoriteRepositoryProtocol {
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer) {
        self.container = container
    }

    func getAllFavorites() -> [Favorite] {
        let request: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()

        do {
            let results = try container.viewContext.fetch(request)
            return results.map { $0.toFavorite() }
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }

    func addNew(favorite: Favorite) {
        let context = container.viewContext
        let favoriteEntity = FavoriteEntity(context: context)
        favoriteEntity.id = favorite.id
        favoriteEntity.title = favorite.title
        favoriteEntity.image = favorite.image
        favoriteEntity.releaseDate = favorite.releaseDate
        favoriteEntity.rating = favorite.rating

        do {
            try context.save()
        } catch {
            print("Error saving favorite: \(error)")
        }
    }

    func delete(favorite: Favorite) {
        let context = container.viewContext

        let request: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", favorite.id)

        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            try context.save()
        } catch {
            print("Error deleting favorite: \(error)")
        }
    }

    func searchFavorites(withKeyword keyword: String) -> [Favorite] {
        let request: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title contains[c] %@", keyword)

        do {
            let results = try container.viewContext.fetch(request)
            return results.map { $0.toFavorite() }
        } catch {
            print("Error searching for favorites: \(error)")
            return []
        }
    }

    func getFavoriteById(_ id: Int32) -> Favorite? {
        let request: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try container.viewContext.fetch(request)
            return results.first?.toFavorite()
        } catch {
            print("Error fetching favorite by id: \(error)")
            return nil
        }
    }
}

extension FavoriteEntity {
    func toFavorite() -> Favorite {
        return Favorite(id: self.id, title: self.title ?? "", image: self.image ?? "", releaseDate: self.releaseDate ?? "", rating: self.rating)
    }
}
