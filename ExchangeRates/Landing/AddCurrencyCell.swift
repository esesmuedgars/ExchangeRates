//
//  AddCurrencyCell.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import UIKit

class AddCurrencyCell: SetupTableViewCell, CellType {

    @IBOutlet private var titleLabel: UILabel!

    override func setup() {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .revolutLightGray
        self.selectedBackgroundView = selectedBackgroundView
    }

    func configure(titleText: String) {
        titleLabel.text = titleText
    }
}
