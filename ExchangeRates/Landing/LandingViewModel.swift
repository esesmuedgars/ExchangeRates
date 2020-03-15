//
//  LandingViewModel.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import Foundation

protocol LandingViewModelDelegate: AnyObject {
    func viewModelDidFetchPersisted()
    func viewModelDidFetch()
    func viewModelDidUpdate(rates: [UIExchangeRate])
}

class LandingViewModel: LandingViewModelType {

    typealias ExchangeRateCompletionBlock = ([ExchangeRate]) -> Void

    private let coreDataService: CoreDataServiceProtocol!
    private let apiService: APIServiceProtocol!

    weak var delegate: LandingViewModelDelegate!
    weak var flowDelegate: CoordinatorFlowDelegate!

    let title = "Rates & converter"
    let addCurrencyCellTitle = "Add currency pair"
    let addCurrencyButtonText = "Add currency pair"
    let addCurrencyDescriptionText = "Choose a currency pair to compare their live rates"
    let deleteActionTitle = "Delete"

    private var pendingCurrency: String?

    private(set) var rates = [ExchangeRate]()

    var numberOfItems: Int {
        rates.isEmpty ? 1 : rates.count + 1
    }

    private lazy var timer: Timer = {
        let timer = Timer(timeInterval: 1, repeats: true) { [weak self] timer in
            self?.updateCurrencyExchangeRates { rates in
                DispatchQueue.main.async {
                    self?.delegate?.viewModelDidUpdate(rates: rates.compactMap {
                        ExchangeRateUseCase(identifier: $0.identifier,
                                            from: $0.fromCurrency,
                                            to: $0.toCurrency,
                                            rate: $0.rate)
                    })
                }
            }
        }

        RunLoop.current.add(timer, forMode: .common)

        return timer
    }()

    init(coreDataService: CoreDataServiceProtocol = Dependencies.shared.coreDataService,
         apiService: APIServiceProtocol = Dependencies.shared.apiService) {
        self.coreDataService = coreDataService
        self.apiService = apiService

        NotificationCenter.default.addObserver(self, selector: #selector(handleSelectedCurrency), name: .currencyHasBeenSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate), name: .applicationWillTerminate, object: nil)
    }

    @objc
    private func handleSelectedCurrency(_ notification: Notification) {
        let currency = notification.userInfo?["code"] as? String

        if pendingCurrency == nil {
            pendingCurrency = currency
        } else if let a = pendingCurrency, let b = currency {
            pendingCurrency = nil

            apiService.addCurrencyPair(a, b)

            fetchCurrencyExchangeRate { [weak self] rates in
                DispatchQueue.main.async {
                    self?.delegate?.viewModelDidFetch()
                    self?.timer.fire()
                }
            }
        }
    }

    @objc
    private func applicationWillTerminate() {
        coreDataService.push()
    }

    func viewDidLoad() {
        fetchPersistedCurrencyExchangeRates { [unowned self] rates in
            guard !rates.isEmpty else { return }

            self.apiService.addCurrencyPairs(rates.map { $0.identifier })

            DispatchQueue.main.async {
                self.delegate?.viewModelDidFetchPersisted()
                self.timer.fire()
            }
        }
    }

    func fetchPersistedCurrencyExchangeRates(completionHandler complete: @escaping ExchangeRateCompletionBlock) {
        coreDataService.retrieve { result in
            switch result {
            case .success(let rates):
                self.rates = rates

                complete(rates)

            case .failure(let error):
                print(error.description)

                complete([])
            }
        }
    }

    func fetchCurrencyExchangeRate(completionHandler complete: @escaping ExchangeRateCompletionBlock) {
        apiService.fetchCurrencyExchangeRates { [unowned self] result in
            switch result {
            case .success(let newValues):
                let uniqueValues = newValues.filter { newValue in
                    !self.rates.contains { oldValue in
                        oldValue.identifier == newValue.identifier
                    }
                }

                newValues.forEach { self.coreDataService.save($0) }

                self.rates.insert(contentsOf: uniqueValues, at: 0)

                complete(uniqueValues)

            case .failure(let error):
                print(error.description)

                complete([])
            }
         }
    }

    func updateCurrencyExchangeRates(completionHandler complete: @escaping ExchangeRateCompletionBlock) {
        apiService.fetchCurrencyExchangeRates { [unowned self] result in
            switch result {
            case .success(let newValues):

                let updatedValues = self.rates.compactMap { oldValue in
                    return newValues.first { newValue in
                        newValue.identifier == oldValue.identifier
                    }
                }

                updatedValues.forEach { self.coreDataService.commit($0) }

                self.rates = updatedValues

                complete(updatedValues)

            case .failure(let error):
                print(error.description)

                complete([])
            }
        }
    }

    func index(from indexPath: IndexPath) -> Int {
        indexPath.row - 1 < 0 ? 0 : indexPath.row - 1
    }

    func exchangeRateItem(at indexPath: IndexPath) -> UIExchangeRate {
        let index = self.index(from: indexPath)
        return rates.compactMap({ $0.ui })[index]
    }

    func removeExchangeRateItem(at indexPath: IndexPath, completionHandler complete: @escaping (Bool) -> Void) {
        let index = self.index(from: indexPath)
        let currency = rates.remove(at: index)

        apiService.removeCurrency(currency.identifier)

        coreDataService.delete(currency)

        complete(rates.isEmpty)
    }

    func presentCurrencyViewController() {
        let currencies = rates.compactMap { $0.ui?.currencies }
        flowDelegate?.presentCurrencyViewController(comparedCurrencies: currencies)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
}

fileprivate extension ExchangeRate {
    var ui: ExchangeRateUseCase? {
        ExchangeRateUseCase(identifier: identifier,
                            from: fromCurrency,
                            to: toCurrency,
                            rate: rate)
    }
}
