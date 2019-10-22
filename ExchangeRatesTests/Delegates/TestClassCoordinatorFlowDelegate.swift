//
//  TestClassCoordinatorFlowDelegate.swift
//  ExchangeRatesTests
//
//  Created by @esesmuedgars
//

@testable import ExchangeRates

protocol TestCoordinatorFlowDelegate {
    var didPresent: ([CurrencyPair]) -> Void { get set }
    var didPush: (Int, [CurrencyPair]) -> Void { get set }
    var didDismiss: () -> Void { get set }
}

class TestClassCoordinatorFlowDelegate: TestCoordinatorFlowDelegate, CoordinatorFlowDelegate {

    var didPresent: ([CurrencyPair]) -> Void = { _ in }
    func presentCurrencyViewController(comparedCurrencies currencies: [CurrencyPair]) {
        didPresent(currencies)
    }

    var didPush: (Int, [CurrencyPair]) -> Void = { _, _ in }
    func pushCurrencyViewController(selectedCurrencyAt index: Int, comparedCurrencies currencies: [CurrencyPair]) {
        didPush(index, currencies)
    }

    var didDismiss: () -> Void = {}
    func dismissPresentedViewController() {
        didDismiss()
    }
}
