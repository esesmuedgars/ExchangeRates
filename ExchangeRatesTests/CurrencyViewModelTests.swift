//
//  CurrencyViewModelTests.swift
//  ExchangeRatesTests
//
//  Created by @esesmuedgars
//

import XCTest
@testable import ExchangeRates

class CurrencyViewModelTests: XCTestCase {

    private func makeViewModel(selectedCurrencyAt index: Int? = nil, comparedCurrencies currencies: [CurrencyPair] = [], canPushViewControllers: Bool = true) -> CurrencyViewModel {
        let viewModel = CurrencyViewModel(selectedCurrencyAt: index,
                                          comparedCurrencies: currencies,
                                          canPushViewControllers: canPushViewControllers)

        viewModel.delegate = delegate as? CurrencyViewModelDelegate
        viewModel.flowDelegate = flowDelegate as? CoordinatorFlowDelegate

        return viewModel
    }

    private var delegate: TestCurrencyViewModelDelegate!
    private var flowDelegate: TestCoordinatorFlowDelegate!

    override func setUp() {
        super.setUp()

        delegate = TestClassCurrencyViewModelDelegate()
        flowDelegate = TestClassCoordinatorFlowDelegate()
    }

    override func tearDown() {
        delegate = nil
        flowDelegate = nil

        super.tearDown()
    }

    func testFetchCurrencyListCallback() {
        let viewModel = makeViewModel()
        let retrievedExpectation = XCTestExpectation()

        delegate.didRetrieve = {
            XCTAssertEqual(viewModel.numberOfCurrencies, 32)
            retrievedExpectation.fulfill()
        }

        viewModel.fetchCurrencyList()

        wait(for: [retrievedExpectation], timeout: 1)
    }

    func testSelectedCurrencyNotification() {
        let retrievedExpectation = XCTestExpectation()
        let notificationExpectation = XCTNSNotificationExpectation(name: .currencyHasBeenSelected)

        let viewModel = makeViewModel()

        delegate.didRetrieve = {
            retrievedExpectation.fulfill()

            viewModel.didSelectRowAt(index: 0)
        }

        viewModel.fetchCurrencyList()

        wait(for: [retrievedExpectation, notificationExpectation], timeout: 1, enforceOrder: true)
    }

    func testFilterSelectedAndComparedDataMutation() {
        let retrievedExpectation = XCTestExpectation()

        let rates = [ExchangeRateUseCase(from: "AUD", to: "RUB"),
                     ExchangeRateUseCase(from: "AUD", to: "GBP"),
                     ExchangeRateUseCase(from: "GBP", to: "AUD"),
                     ExchangeRateUseCase(from: "AUD", to: "USD"),
                     ExchangeRateUseCase(from: "AUD", to: "EUR")]

        let viewModel = makeViewModel(selectedCurrencyAt: 0,
                                      comparedCurrencies: rates.map { $0.currencies })

        delegate.didRetrieve = {
            XCTAssertEqual(viewModel.numberOfCurrencies, 27)
            retrievedExpectation.fulfill()
        }

        viewModel.fetchCurrencyList()

        wait(for: [retrievedExpectation], timeout: 1)
    }

    func testDidSelectRowAtIfBlockCallback() {
        let retrievedExpectation = XCTestExpectation()
        let pushExpectation = XCTestExpectation()

        let index = 0
        let rates = [ExchangeRateUseCase(from: "AUD", to: "EUR"),
                     ExchangeRateUseCase(from: "AUD", to: "USD")]
        let currencies = rates.map { $0.currencies }

        let viewModel = makeViewModel(comparedCurrencies: currencies)

        delegate.didRetrieve = {
            retrievedExpectation.fulfill()

            viewModel.didSelectRowAt(index: index)
        }

        flowDelegate.didPush = { selectedAtIndex, comparedCurrencies in
            XCTAssertEqual(index, selectedAtIndex)
            XCTAssertEqual(currencies[0].from, comparedCurrencies[0].from)
            XCTAssertEqual(currencies[0].to, comparedCurrencies[0].to)
            pushExpectation.fulfill()
        }

        viewModel.fetchCurrencyList()

        wait(for: [retrievedExpectation, pushExpectation], timeout: 1, enforceOrder: true)
    }

    func testDidSelectRowAtElseBlockCallback() {
        let retrievedExpectation = XCTestExpectation()
        let dismissExpectation = XCTestExpectation()

        let viewModel = makeViewModel(canPushViewControllers: false)

        delegate.didRetrieve = {
            retrievedExpectation.fulfill()

            viewModel.didSelectRowAt(index: 0)
        }

        flowDelegate.didDismiss = {
            dismissExpectation.fulfill()
        }

        viewModel.fetchCurrencyList()

        wait(for: [retrievedExpectation, dismissExpectation], timeout: 1, enforceOrder: true)
    }
}

