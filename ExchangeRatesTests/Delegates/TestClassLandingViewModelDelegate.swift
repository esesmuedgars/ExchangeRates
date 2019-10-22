//
//  TestClassLandingViewModelDelegate.swift
//  ExchangeRatesTests
//
//  Created by @esesmuedgars
//

@testable import ExchangeRates

protocol TestLandingViewModelDelegate {
    var didFetchPersisted: () -> Void { get set }
    var didFetch: () -> Void { get set }
    var didUpdate: ([UIExchangeRate]) -> Void { get set }
}

class TestClassLandingViewModelDelegate: TestLandingViewModelDelegate, LandingViewModelDelegate {

    var didFetchPersisted: () -> Void = {}
    func viewModelDidFetchPersisted() {
        didFetchPersisted()
    }

    var didFetch: () -> Void = {}
    func viewModelDidFetch() {
        didFetch()
    }

    var didUpdate: ([UIExchangeRate]) -> Void = { _ in }
    func viewModelDidUpdate(rates: [UIExchangeRate]) {
        didUpdate(rates)
    }
}
