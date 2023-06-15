//
//  CoreDataManager.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

import CoreData
import RxSwift

final class CoreDataManager: CoreDataManageable {
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataNamespace.item)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard error == nil else {
                return
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    var diaryEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: CoreDataNamespace.item, in: context)
    }

    private init() { }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func generateRequest(by id: Int) -> NSFetchRequest<ItemDAO> {
        let request: NSFetchRequest<ItemDAO> = ItemDAO.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", Int(id))
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        return request
    }

    private func generateRequest(by isAddCart: Bool) -> NSFetchRequest<ItemDAO> {
        let request: NSFetchRequest<ItemDAO> = ItemDAO.fetchRequest()
        let predicate = NSPredicate(format: "isAddCart == %@", true as CVarArg)
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        return request
    }

    private func fetchResult(from request: NSFetchRequest<ItemDAO>) -> ItemDAO? {
        guard let fetchResult = try? context.fetch(request),
              let itemDAO = fetchResult.first
        else {
            return nil
        }
        return itemDAO
    }

    func create(with item: Item) {
        let request = generateRequest(by: item.id)

        if let objectToUpdate = fetchResult(from: request) {
            objectToUpdate.stock = Int16(item.stock)
            objectToUpdate.name = item.name
            objectToUpdate.explanation = item.description
            objectToUpdate.thumbnail = item.thumbnail
            objectToUpdate.price = item.price
            objectToUpdate.bargainPrice = item.bargainPrice
            objectToUpdate.discountedPrice = item.discountedPrice
            objectToUpdate.favorites = item.favorites
            objectToUpdate.isAddCart = item.isAddCart
        } else {
            let entity = ItemDAO(context: context)
            entity.id = Int16(item.id)
            entity.stock = Int16(item.stock)
            entity.name = item.name
            entity.explanation = item.description
            entity.thumbnail = item.thumbnail
            entity.price = item.price
            entity.bargainPrice = item.bargainPrice
            entity.discountedPrice = item.discountedPrice
            entity.favorites = item.favorites
            entity.isAddCart = item.isAddCart
        }

        saveContext()
    }

    func fetch(with id: Int) -> Observable<ItemDAO> {
        return Observable.create { [weak self] emitter in
            guard let request = self?.generateRequest(by: id),
                  let fetchResult = self?.fetchResult(from: request)
            else {
                emitter.onError(CoreDataError.readFail)
                return Disposables.create()
            }

            emitter.onNext(fetchResult)
            emitter.onCompleted()

            return Disposables.create()
        }
    }

    func fetch(to isAddCart: Bool) -> Observable<[ItemDAO]> {
        return Observable.create { [weak self] emitter in
            guard let request = self?.generateRequest(by: isAddCart),
                  let fetchResult = try? self?.context.fetch(request)
            else {
                emitter.onError(CoreDataError.readFail)
                return Disposables.create()
            }

            emitter.onNext(fetchResult)
            emitter.onCompleted()

            return Disposables.create()
        }
    }

    func fetchAllEntities() -> Observable<[ItemDAO]> {
        return Observable.create { [weak self] emitter in
            let request = ItemDAO.fetchRequest()

            guard let item = try? self?.context.fetch(request) else {
                return Disposables.create()
            }

            emitter.onNext(item)
            emitter.onCompleted()

            return Disposables.create()
        }
    }

    func update(with item: Item) {
        let request = generateRequest(by: item.id)

        guard let objectToUpdate = fetchResult(from: request) else { return }

        objectToUpdate.stock = Int16(item.stock)
        objectToUpdate.name = item.name
        objectToUpdate.explanation = item.description
        objectToUpdate.thumbnail = item.thumbnail
        objectToUpdate.price = item.price
        objectToUpdate.bargainPrice = item.bargainPrice
        objectToUpdate.discountedPrice = item.discountedPrice
        objectToUpdate.favorites = item.favorites

        saveContext()
    }

    func delete(with item: Item) {
        let request = generateRequest(by: item.id)
        guard let objectToDelete = fetchResult(from: request) else { return }
        context.delete(objectToDelete)

        saveContext()
    }

    private enum CoreDataNamespace {
        static let item = "ItemDAO"
        static let idRegex = "id == %@"
    }
}

