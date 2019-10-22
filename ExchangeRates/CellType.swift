//
//  CellType.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import UIKit

protocol CellType {
    static var identifier: String { get }
    static var nib: UINib? { get }
}

extension CellType {
    private static var className: String {
        return String(describing: self)
    }

    static var identifier: String {
        return className
    }

    static var nib: UINib? {
        guard Bundle.main.path(forResource: className, ofType: "nib") != nil else {
            fatalError("\(className).xib does not exist")
        }

        return UINib(nibName: className, bundle: .main)
    }
}
