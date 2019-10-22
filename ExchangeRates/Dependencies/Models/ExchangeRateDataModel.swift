//
//  ExchangeRateDataModel.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import Foundation

struct ExchangeRateDataModel {
    var rates: [ExchangeRate]

    init(from data: Data) throws {
        guard let rates = try JSONSerialization.jsonObject(with: data) as? [String: Double] else {
            throw "Unable to dowcast serialized object to type `[String: Double]`."
        }

        self.rates = try rates.map { (pair, rate) in
            let currencies = try pair.halve()
            return ExchangeRate(identifier: pair,
                                fromCurrency: currencies.a,
                                toCurrency: currencies.b,
                                rate: rate)
        }
    }
}
