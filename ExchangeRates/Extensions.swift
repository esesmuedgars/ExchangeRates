//
//  Extensions.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import UIKit

extension String: Error {}

extension UIStoryboard {
    func instantiateViewController<Controller>(ofType type: Controller.Type) -> Controller {
        instantiateViewController(withIdentifier: String(describing: type)) as! Controller
    }
}

extension UITableView {
    func register<Cell: UITableViewCell>(cellOfType cell: Cell.Type) where Cell: CellType {
        register(cell.nib, forCellReuseIdentifier: cell.identifier)
    }

    func dequeueReusableCell<Cell: UITableViewCell>(_ cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        dequeueReusableCell(withIdentifier: String(describing: cellType), for: indexPath) as! Cell
    }
}

extension UIColor {

    /// #191C1F
    static var revolutBlack: UIColor {
        #colorLiteral(red: 0.09803921569, green: 0.1098039216, blue: 0.1215686275, alpha: 1)
    }

    /// #0075EB
    static var revolutBlue: UIColor {
        #colorLiteral(red: 0, green: 0.4588235294, blue: 0.9215686275, alpha: 1)
    }

    /// #8B959E
    static var revolutGray: UIColor {
        #colorLiteral(red: 0.5450980392, green: 0.5843137255, blue: 0.6196078431, alpha: 1)
    }

    /// #F6F5F8
    static var revolutLightGray: UIColor {
        #colorLiteral(red: 0.9654909968, green: 0.9606856704, blue: 0.9735022187, alpha: 1)
    }
}

extension Notification.Name {
    static let currencyHasBeenSelected = Notification.Name("CurrencyHasBeenSelected")

    static var applicationWillTerminate: Notification.Name {
        UIApplication.willTerminateNotification
    }
}

extension String {
    func halve() throws -> (a: String, b: String) {
        guard count % 2 == 0 else {
            throw "Attempted to halve string with odd number of characters."
        }

        let length = count / 2
        let a = String(prefix(length))
        let b = String(suffix(length))

        return (a, b)
    }
}

extension IndexPath {
    static var zero: IndexPath {
        IndexPath(row: 0, section: 0)
    }
}
