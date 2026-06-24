//
//  FavoriteCoreDataManager.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 23/06/2026.
//

import Foundation
import CoreData

class FavoriteCoreDataManager {
    static let shared = FavoriteCoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        // Must match the exact name of your .xcdatamodeld file
        persistentContainer = NSPersistentContainer(name: "Skyline")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        // Automatically merges modifications made in background threads back to the UI context
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - Save or Update Location
    func saveOrUpdateFavorite(name: String, temp: String, icon: String, lastUpdated: String) {
        let context = persistentContainer.viewContext
        
        // Check if the city already exists to update it instead of creating duplicates
        let fetchRequest: NSFetchRequest<FavoriteLocation> = FavoriteLocation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name ==[c] %@", name) // Case-insensitive matching
        
        context.perform {
            do {
                let results = try context.fetch(fetchRequest)
                let favorite: FavoriteLocation
                
                if let existingFavorite = results.first {
                    favorite = existingFavorite // Update existing record
                } else {
                    favorite = FavoriteLocation(context: context) // Create a new record
                    favorite.name = name
                }
                
                // Set or refresh properties
                favorite.temp = temp
                favorite.icon = icon
                favorite.lastUpdate = lastUpdated
                
                try context.save()
                print("Successfully saved/updated favorite location: \(name)")
            } catch {
                print("Failed to save favorite context: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Fetch All Locations
    func fetchAllFavorites() -> [FavoriteLocation] {
        let fetchRequest: NSFetchRequest<FavoriteLocation> = FavoriteLocation.fetchRequest()
        
        // Sort by name alphabetically
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch favorite locations: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Delete Location
    func deleteFavorite(name: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteLocation> = FavoriteLocation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name ==[c] %@", name)
        
        context.perform {
            do {
                let results = try context.fetch(fetchRequest)
                if let locationToDelete = results.first {
                    context.delete(locationToDelete)
                    try context.save()
                    print("Successfully deleted favorite location: \(name)")
                }
            } catch {
                print("Failed to delete favorite location: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Check if Location Is Favorite
    func isFavorite(name: String) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteLocation> = FavoriteLocation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name ==[c] %@", name)
        
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
}
