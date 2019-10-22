//
//  ExchangeRateCell.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import UIKit

protocol UIExchangeRate {
    var fromAmount: String { get }
    var fromCurrency: String { get }
    var toAmount: NSAttributedString { get }
    var toCurrency: String { get }
    var toCode: String { get }
}

class ExchangeRateCell: SetupTableViewCell, CellType {

    @IBOutlet private var fromAmountLabel: UILabel!
    @IBOutlet private var fromCurrencyLabel: UILabel!
    @IBOutlet private var toAmountLabel: UILabel!
    @IBOutlet private var toCurrencyLabel: UILabel!
    @IBOutlet private var toCodeLabel: UILabel!

    func configure(fromAmount: String, fromCurrency: String, toAmount: NSAttributedString, toCurrency: String, toCode: String) {
        fromAmountLabel.text = fromAmount
        fromCurrencyLabel.text = fromCurrency
        toAmountLabel.attributedText = toAmount
        toCurrencyLabel.text = toCurrency
        toCodeLabel.text = toCode
    }

    func update(toAmount: NSAttributedString) {
        toAmountLabel.attributedText = toAmount
    }
}
