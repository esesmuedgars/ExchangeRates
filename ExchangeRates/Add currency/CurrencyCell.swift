//
//  CurrencyCell.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import UIKit

class CurrencyCell: SetupTableViewCell, CellType {
    
    @IBOutlet private var countryImageView: UIImageView! {
        didSet {
            countryImageView.layer.cornerRadius = countryImageView.frame.height / 2
        }
    }
    @IBOutlet private var codeLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!

    override func setup() {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .revolutLightGray
        self.selectedBackgroundView = selectedBackgroundView
    }

    func configure(currencyCode code: String, currencyName name: String) {
        countryImageView.image = UIImage(named: code)
        codeLabel.text = code
        titleLabel.text = name
    }
}
