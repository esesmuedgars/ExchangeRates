//
//  Extensions.swift
//  ExchangeRatesTests
//
//  Created by e.vanags on 24/10/2019.
//  Copyright © 2019 Revolut Ltd. All rights reserved.
//

@testable import ExchangeRates

extension ExchangeRate: Equatable {
    init(id: String = "identifier", from: String = "GBP", to: String = "EUR", rate: Double = 1) {
        self = ExchangeRate(identifier: id,
                            fromCurrency: from,
                            toCurrency: to,
                            rate: rate)
    }

    public static func == (lhs: ExchangeRate, rhs: ExchangeRate) -> Bool {
        return lhs.identifier == rhs.identifier &&
            lhs.fromCurrency == rhs.fromCurrency &&
            lhs.toCurrency == rhs.toCurrency &&
            lhs.rate == rhs.rate
    }
}

extension ExchangeRateUseCase: Equatable {
    init(id: String = "identifier", from: String = "GBP", to: String = "EUR", rate: Double = 1) {
        self = ExchangeRateUseCase(identifier: id,
                                   from: from,
                                   to: to,
                                   rate: rate)!
    }

    public static func == (lhs: ExchangeRateUseCase, rhs: ExchangeRateUseCase) -> Bool {
        return lhs.identifier == rhs.identifier &&
            lhs.currencies == rhs.currencies &&
            lhs.fromAmount == rhs.fromAmount &&
            lhs.fromCurrency == rhs.fromCurrency &&
            lhs.toAmount == rhs.toAmount &&
            lhs.toCurrency == rhs.toCurrency &&
            lhs.toCode == rhs.toCode
    }
}
