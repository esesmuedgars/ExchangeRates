//
//  CurrencyViewController.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import UIKit

protocol CurrencyViewModelType: AnyObject {
    var currencies: [Currency] { get }
    var numberOfCurrencies: Int { get }

    func fetchCurrencyList()

    func didSelectRowAt(index: Int)
}

class CurrencyViewController: UIViewController, CurrencyViewModelDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.register(cellOfType: CurrencyCell.self)
        }
    }

    var viewModel: CurrencyViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)

        viewModel.fetchCurrencyList()
    }

    // MARK: - CurrencyViewModelDelegate

    func viewModelDidRetrieve() {
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCurrencies
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CurrencyCell.self, for: indexPath)

        let currency = viewModel.currencies[indexPath.row]
        cell.configure(currencyCode: currency.code,
                       currencyName: currency.longName)

        return cell
    }


    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(index: indexPath.row)
    }
}
