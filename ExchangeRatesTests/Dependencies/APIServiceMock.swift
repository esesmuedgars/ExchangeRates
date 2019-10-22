//
//  APIServiceMock.swift
//  ExchangeRatesTests
//
//  Created by @esesmuedgars
//

@testable import ExchangeRates

protocol APIServiceMockProtocol {
    var didAddPairs: ([String]) -> Void { get set }
    var didAddPair: (String, String) -> Void { get set }
    var didRemove: (String) -> Void { get set }
    var fetchResult: Result<[ExchangeRate], APIServiceError> { get set }
}

class APIServiceMock: APIServiceMockProtocol, APIServiceProtocol {

    var didAddPairs: ([String]) -> Void = { _ in }
    func addCurrencyPairs(_ pairs: [String]) {
        didAddPairs(pairs)
    }

    var didAddPair: (String, String) -> Void = { _, _ in }
    func addCurrencyPair(_ a: String, _ b: String) {
        didAddPair(a, b)
    }

    var didRemove: (String) -> Void = { _ in }
    func removeCurrency(_ value: String) {
        didRemove(value)
    }

    var fetchResult: Result<[ExchangeRate], APIServiceError> = .success([])
    func fetchCurrencyExchangeRates(completionHandler complete: @escaping ExchangeRateCompletionBlock) {
        complete(fetchResult)
    }
}
