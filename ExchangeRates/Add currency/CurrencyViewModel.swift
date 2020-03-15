//
//  CurrencyViewModel.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import Foundation

protocol CurrencyViewModelDelegate: AnyObject {
    func viewModelDidRetrieve()
}

class CurrencyViewModel: CurrencyViewModelType {

    weak var delegate: CurrencyViewModelDelegate!
    weak var flowDelegate: CoordinatorFlowDelegate!

    private(set) var currencies = [Currency]() {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.viewModelDidRetrieve()
            }
        }
    }

    var numberOfCurrencies: Int {
        currencies.count
    }

    private var selectedCurrencyIndex: Int?
    private var comparedCurrencies: [CurrencyPair]
    private var canPushViewControllers: Bool

    init(selectedCurrencyAt index: Int? = nil, comparedCurrencies currencies: [CurrencyPair], canPushViewControllers: Bool = true) {
        self.selectedCurrencyIndex = index
        self.comparedCurrencies = currencies
        self.canPushViewControllers = canPushViewControllers
    }

    func fetchCurrencyList() {
        DispatchQueue.global(qos: .userInteractive).async {
            if let path = Bundle.main.path(forResource: "Currencies", ofType: "json") {
                do {
                    let url = URL(fileURLWithPath: path)
                    let data = try Data(contentsOf: url)

                    var currencies = try JSONDecoder().decode([Currency].self, from: data)
                    self.filterSelectedAndCompared(&currencies)

                    self.currencies = currencies
                } catch {
                    print("Unable to parse file at path \(path) to type `Currencies`. Error: \(error)")
                }
            }
        }
    }

    func didSelectRowAt(index: Int) {
        notifyOfSelectedCurrency(atIndex: index)

        if canPushViewControllers {
            flowDelegate?.pushCurrencyViewController(selectedCurrencyAt: index,
                                                     comparedCurrencies: comparedCurrencies)
        } else {
            flowDelegate?.dismissPresentedViewController()
        }
    }

    private func notifyOfSelectedCurrency(atIndex index: Int) {
        NotificationCenter.default.post(name: .currencyHasBeenSelected,
                                        object: nil,
                                        userInfo: ["code": currencies[index].code])
    }

    private func filterSelectedAndCompared(_ currencies: inout [Currency]) {
        if let index = selectedCurrencyIndex {
            let selected = currencies.remove(at: index)

            let comparedTo = comparedCurrencies
                .filter { $0.from == selected }
                .map { $0.to }

            currencies.removeAll { comparedTo.contains($0) }
        }
    }
}
