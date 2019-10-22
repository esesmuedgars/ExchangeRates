//
//  CoreDataServiceMock.swift
//  ExchangeRatesTests
//
//  Created by @esesmuedgars
//

@testable import ExchangeRates

protocol CoreDataServiceMockProtocol {
    var didCommit: (ExchangeRate) -> Void { get set }
    var didPush: () -> Void { get set }
    var didSave: (ExchangeRate) -> Void { get set }
    var retrieveResult: Result<[ExchangeRate], CoreDataServiceError> { get set }
    var didDelete: (ExchangeRate) -> Void { get set }
}

class CoreDataServiceMock: CoreDataServiceMockProtocol, CoreDataServiceProtocol {

    var didCommit: (ExchangeRate) -> Void = { _ in }
    func commit(_ value: ExchangeRate) {
        didCommit(value)
    }

    var didPush: () -> Void = {}
    func push() {
        didPush()
    }

    var didSave: (ExchangeRate) -> Void = { _ in }
    func save(_ value: ExchangeRate) {
        didSave(value)
    }

    var retrieveResult: Result<[ExchangeRate], CoreDataServiceError> = .success([])
    func retrieve(completionHandler complete: @escaping PersistedExchangeRatesCompletionBlock) {
        complete(retrieveResult)
    }

    var didDelete: (ExchangeRate) -> Void = { _ in }
    func delete(_ value: ExchangeRate) {
        didDelete(value)
    }
}
