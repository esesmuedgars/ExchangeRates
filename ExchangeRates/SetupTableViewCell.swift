//
//  SetupTableViewCell.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import UIKit

class SetupTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {}
}
