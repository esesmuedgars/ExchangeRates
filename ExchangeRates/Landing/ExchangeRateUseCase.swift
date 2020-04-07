//
//  ExchangeRateUseCase.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import Foundation
import UIKit

struct ExchangeRateUseCase: UIExchangeRate {
    let identifier: String
    var currencies: CurrencyPair
    let fromAmount: String
    let fromCurrency: String
    let toAmount: NSAttributedString
    let toCurrency: String
    let toCode: String

    init?(identifier: String, from: String, to: String, rate: Double) {
        self.identifier = identifier

        if let currency = Currency(rawValue: from) {
            currencies.from = currency
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currencyISOCode
            numberFormatter.maximumFractionDigits = 0
            numberFormatter.currencyCode = currency.code
            
            guard let amount = numberFormatter.string(for: 1) else {
                return nil
            }

            fromAmount = amount
            fromCurrency = currency.shortName
        } else {
            return nil
        }

        if let currency = Currency(rawValue: to) {
            currencies.to = currency
            
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 4
            numberFormatter.maximumFractionDigits = 4
            
            guard let string = numberFormatter.string(for: rate) else {
                return nil
            }

            let attributed = NSMutableAttributedString(string: string)
            attributed.setAttributes([
                .font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ], range: NSRange(location: attributed.length - 2, length: 2))

            toAmount = attributed
            toCurrency = currency.shortName
            toCode = currency.code
        } else {
            return nil
        }
    }
}
