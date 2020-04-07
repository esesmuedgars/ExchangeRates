//
//  CoreDataService.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import CoreData

enum CoreDataServiceError: Error {
    case errorLoadingPersistentStores(error: NSError)
    case failedToDeleteObject(error: Error)
    case failedToRetrieveObjects(error: Error)
    case unableToSaveChanges
}

extension CoreDataServiceError {
    var description: String {
        switch self {
        case .errorLoadingPersistentStores(let error):
            return "Error loading persistent stores: \(error), \(error.userInfo)."
        case .failedToDeleteObject(let error):
            return "Fetch request predicate did not match any objects, error: \(error)."
        case .failedToRetrieveObjects(let error):
            return "Fetch request was unable to return managed objects with error: \(error)."
        case .unableToSaveChanges:
            return "Error committing unsaved changes to the context’s parent store."
        }
    }
}

typealias PersistedExchangeRatesCompletionBlock = (Result<[ExchangeRate], CoreDataServiceError>) -> Void

protocol CoreDataServiceProtocol: AnyObject {

    /// Update managed object if able to match `value` to context using predicate.
    /// Create new managed object from `value` parameters if update failed.
    ///
    /// This does not push changes to conetext's persistent store,
    /// to push changes call `save()`.
    func commit(_ value: ExchangeRate)

    /// Push pending changes to conetext's persistent store.
    func push()

    /// Update managed object if able to match `value` to context using predicate.
    /// Create and saves new managed object from `value` parameters if update failed.
    func save(_ value: ExchangeRate)

    func retrieve(completionHandler complete: @escaping PersistedExchangeRatesCompletionBlock)
    func delete(_ value: ExchangeRate)
}

final class CoreDataService: CoreDataServiceProtocol {

    private let containerName = "ExchangeRates"
    private let entityName = "ExchangeRate"

    private lazy var managedContext: NSManagedObjectContext = {
        let persistentContainer = NSPersistentContainer(name: containerName)
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                print(CoreDataServiceError.errorLoadingPersistentStores(error: error))
            }
        }

        return persistentContainer.newBackgroundContext()
    }()

    func commit(_ value: ExchangeRate) {
        do {
            try update(value)
        } catch {
            create(value)
        }
    }

    func save(_ value: ExchangeRate) {
        commit(value)
        push()
    }

    func create(_ value: ExchangeRate) {
        guard let description = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else { return }

        value.set(NSManagedObject(entity: description, insertInto: managedContext))
    }

    private func update(_ newValue: ExchangeRate) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", newValue.identifier)

        guard let managedObject = try managedContext.fetch(fetchRequest).compactMap({ $0 as? NSManagedObject }).first else {
            throw CoreDataServiceError.failedToRetrieveObjects(error: "Update unecessary")
        }

        newValue.set(managedObject)
    }

    func retrieve(completionHandler complete: @escaping PersistedExchangeRatesCompletionBlock) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(ExchangeRateMO.objectID), ascending: false)]

        do {
            guard try managedContext.count(for: fetchRequest) != 0 else {
                throw "Context is empty"
            }

            let persistedValue = try managedContext
                .fetch(fetchRequest)
                .compactMap { $0 as? NSManagedObject }
                .compactMap(ExchangeRate.init)

            complete(.success(persistedValue))
        } catch {
            complete(.failure(.failedToRetrieveObjects(error: error)))
        }
    }

    func delete(_ value: ExchangeRate) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", value.identifier)

        do {
            guard let managedObject = try managedContext.fetch(fetchRequest).compactMap({ $0 as? NSManagedObject }).first else {
                throw "Attempted to delete object from cotenxt which doesn't exist"
            }

            managedContext.delete(managedObject)

            push()
        } catch {
            print(CoreDataServiceError.failedToDeleteObject(error: error))
        }
    }

    func push() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                print(CoreDataServiceError.unableToSaveChanges.description)
            }
        }
    }
}

fileprivate extension NSManagedObject {
    func value(forKey key: ExchangeRate.Key) -> Any? {
        value(forKey: key.rawValue)
    }

    func setValue(_ value: Any?, forKey key: ExchangeRate.Key) {
        setValue(value, forKey: key.rawValue)
    }
}

fileprivate extension ExchangeRate {

    enum Key: String {
        case identifier
        case fromCurrency
        case toCurrency
        case rate
    }

    init?(_ managedObject: NSManagedObject) {
        guard let identifier = managedObject.value(forKey: .identifier) as? String,
            let fromCurrency = managedObject.value(forKey: .fromCurrency) as? String,
            let toCurrency = managedObject.value(forKey: .toCurrency) as? String,
            let rate = managedObject.value(forKey: .rate) as? Double else { return nil }

        self.identifier = identifier
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.rate = rate
    }

    func set(_ managedObject: NSManagedObject) {
        managedObject.setValue(identifier, forKey: .identifier)
        managedObject.setValue(fromCurrency, forKey: .fromCurrency)
        managedObject.setValue(toCurrency, forKey: .toCurrency)
        managedObject.setValue(rate, forKey: .rate)
    }
}
