//
//  Persistence.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/8.
//

import CoreData

/// A controller for managing Core Data persistence within the Quizzybee application.
///
/// - Purpose:
///   - Provides a shared instance for accessing the Core Data stack.
///   - Supports in-memory storage for previews and testing.
///   - Handles loading and configuring persistent stores.
struct PersistenceController {
    /// The shared singleton instance of `PersistenceController`.
    static let shared = PersistenceController()

    /// A preview instance for use in SwiftUI previews or testing.
    ///
    /// - Note:
    ///   - Uses an in-memory store to avoid persisting data during testing or previews.
    ///   - Prepopulates the database with sample data for UI previews.
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    /// The container that encapsulates the Core Data stack.
    let container: NSPersistentCloudKitContainer

    /// Initializes the persistence controller.
    ///
    /// - Parameters:
    ///   - inMemory: A Boolean value indicating whether to use an in-memory store.
    ///
    /// - Behavior:
    ///   - Creates an `NSPersistentCloudKitContainer` with the specified name.
    ///   - Configures the persistent store to use an in-memory store if `inMemory` is `true`.
    ///   - Loads the persistent stores and handles errors appropriately.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "quizzybee")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Handle persistent store loading errors.
                /*
                 Typical reasons for an error here include:
                 - The parent directory does not exist, cannot be created, or disallows writing.
                 - The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 - The device is out of space.
                 - The store could not be migrated to the current model version.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
