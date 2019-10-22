//
//  TestClassCurrencyViewModelDelegate.swift
//  ExchangeRatesTests
//
//  Created by @esesmuedgars
//

@testable import ExchangeRates

protocol TestCurrencyViewModelDelegate {
    var didRetrieve: () -> Void { get set }
}

class TestClassCurrencyViewModelDelegate: TestCurrencyViewModelDelegate, CurrencyViewModelDelegate {

    var didRetrieve: () -> Void = {}
    func viewModelDidRetrieve() {
        didRetrieve()
    }
}
