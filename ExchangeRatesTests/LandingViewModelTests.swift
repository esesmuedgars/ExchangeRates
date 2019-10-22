//
//  LandingViewModelTests.swift
//  ExchangeRatesTests
//
//  Created by @esesmuedgars
//

import XCTest
@testable import ExchangeRates

class LandingViewModelTests: XCTestCase {

    private var coreDataService: CoreDataServiceMockProtocol!
    private var apiService: APIServiceMockProtocol!
    private var viewModel: LandingViewModel!
    private var delegate: TestLandingViewModelDelegate!
    private var flowDelegate: TestCoordinatorFlowDelegate!

    override func setUp() {
        coreDataService = CoreDataServiceMock()
        apiService = APIServiceMock()

        viewModel = LandingViewModel(coreDataService: coreDataService as! CoreDataServiceProtocol,
                                     apiService: apiService as! APIServiceProtocol)
        delegate = TestClassLandingViewModelDelegate()
        flowDelegate = TestClassCoordinatorFlowDelegate()

        viewModel.delegate = delegate as? LandingViewModelDelegate
        viewModel.flowDelegate = flowDelegate as? CoordinatorFlowDelegate
    }

    override func tearDown() {
        coreDataService = nil
        apiService = nil
        viewModel = nil
        delegate = nil
        flowDelegate = nil
    }

    func testNumberOfItems() {
        XCTAssertEqual(viewModel.numberOfItems, 1)

        let expectation = XCTestExpectation()

        coreDataService.retrieveResult = .success([ExchangeRate()])

        viewModel.fetchPersistedCurrencyExchangeRates { [unowned self] _ in
            XCTAssertEqual(self.viewModel.numberOfItems, 2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testFetchPersistedCurrencyExchangeRatesSuccessCallback() {
        let fetchExpectation = XCTestExpectation()

        let value = ExchangeRate()
        coreDataService.retrieveResult = .success([value])

        viewModel.fetchPersistedCurrencyExchangeRates { values in
            XCTAssertEqual(value, values[0])
            fetchExpectation.fulfill()
        }

        wait(for: [fetchExpectation], timeout: 1)
    }

    func testFetchPersistedCurrencyExchangeRatesFailCallback() {
        let fetchExpectation = XCTestExpectation()

        coreDataService.retrieveResult = .failure(.unableToSaveChanges)

        viewModel.fetchPersistedCurrencyExchangeRates { values in
            XCTAssertTrue(values.isEmpty)
            fetchExpectation.fulfill()
        }

        wait(for: [fetchExpectation], timeout: 1)
    }

    func testFetchCurrencyExchangeRateSuccessCallback() {
        let fetchExpectation = XCTestExpectation()

        let value = ExchangeRate()
        apiService.fetchResult = .success([value])

        viewModel.fetchCurrencyExchangeRate { values in
            XCTAssertEqual(value, values[0])
            fetchExpectation.fulfill()
        }

        wait(for: [fetchExpectation], timeout: 1)
    }

    func testFetchCurrencyExchangeRateUniqueValueCallback() {
        let persistedExpectation = XCTestExpectation()
        let fetchExpectation = XCTestExpectation()

        let oldValues = [ExchangeRate(id: "1"), ExchangeRate(id: "2")]
        coreDataService.retrieveResult = .success(oldValues)

        viewModel.fetchPersistedCurrencyExchangeRates { values in
            XCTAssertEqual(oldValues, values)
            persistedExpectation.fulfill()
        }

        let newValues = [ExchangeRate(id: "3"), ExchangeRate(id: "4")]
        apiService.fetchResult = .success(newValues)

        viewModel.fetchCurrencyExchangeRate { values in
            XCTAssertEqual(newValues, values)
            fetchExpectation.fulfill()
        }

        wait(for: [fetchExpectation], timeout: 1)
    }

    func testFetchCurrencyExchangeRateFailCallback() {
        let fetchExpectation = XCTestExpectation()

        apiService.fetchResult = .failure(.emptyDataOrError)

        viewModel.fetchCurrencyExchangeRate { values in
            XCTAssertTrue(values.isEmpty)
            fetchExpectation.fulfill()
        }

        wait(for: [fetchExpectation], timeout: 1)
    }

    func testUpdateCurrencyExchangeRatesSuccessCallback() {
        let fetchExpectation = XCTestExpectation()
        let updateExpectation = XCTestExpectation()

        let oldValue = ExchangeRate(from: "EUR", to: "RUB")
        coreDataService.retrieveResult = .success([oldValue])

        viewModel.fetchPersistedCurrencyExchangeRates { values in
            XCTAssertEqual(oldValue, values[0])
            fetchExpectation.fulfill()
        }

        let newValue = ExchangeRate(from: "GBP", to: "USD")
        apiService.fetchResult = .success([newValue])

        viewModel.updateCurrencyExchangeRates { values in
            XCTAssertEqual(newValue, values[0])
            updateExpectation.fulfill()
        }

        wait(for: [fetchExpectation, updateExpectation], timeout: 1, enforceOrder: true)
    }

    func testUpdateCurrencyExchangeRatesFailCallback() {
        let fetchExpectation = XCTestExpectation()
        let updateExpectation = XCTestExpectation()

        coreDataService.retrieveResult = .failure(.unableToSaveChanges)

        viewModel.fetchPersistedCurrencyExchangeRates { values in
            XCTAssertTrue(values.isEmpty)
            fetchExpectation.fulfill()
        }

        apiService.fetchResult = .failure(.emptyDataOrError)

        viewModel.updateCurrencyExchangeRates { values in
            XCTAssertTrue(values.isEmpty)
            updateExpectation.fulfill()
        }

        wait(for: [fetchExpectation, updateExpectation], timeout: 1, enforceOrder: true)
    }

    func testCurrencyHasBeenSelectedNotification() {
        let expectation = XCTestExpectation()

        let fromCode = "GBP"
        let toCode = "EUR"

        apiService.didAddPair = { from, to in
            XCTAssertEqual(fromCode, from)
            XCTAssertEqual(toCode, to)
            expectation.fulfill()
        }

        NotificationCenter.default.post(name: .currencyHasBeenSelected,
                                        object: nil,
                                        userInfo: ["code": fromCode])
        NotificationCenter.default.post(name: .currencyHasBeenSelected,
                                        object: nil,
                                        userInfo: ["code": toCode])

        wait(for: [expectation], timeout: 1)
    }

    func testApplicationWillTerminateNotification() {
        let expectation = XCTestExpectation()

        coreDataService.didPush = {
            expectation.fulfill()
        }

        NotificationCenter.default.post(name: .applicationWillTerminate,
                                        object: nil,
                                        userInfo: nil)

        wait(for: [expectation], timeout: 1)
    }

    func testTimerBlock() {
        let persistedExpectation = XCTestExpectation()
        let updateExpectation = XCTestExpectation()
        let timerExpectation = XCTestExpectation()

        let oldValue = ExchangeRate(from: "USD", to: "RUB")
        coreDataService.retrieveResult = .success([oldValue])

        viewModel.fetchPersistedCurrencyExchangeRates { values in
            XCTAssertEqual(oldValue, values[0])
            persistedExpectation.fulfill()
        }

        let newValue = ExchangeRate()
        apiService.fetchResult = .success([newValue])

        coreDataService.didCommit = { value in
            XCTAssertEqual(newValue, value)
            updateExpectation.fulfill()
        }

        delegate.didUpdate = { newValue in
            XCTAssertNotNil(newValue[0] as? ExchangeRateUseCase)
            XCTAssertEqual(ExchangeRateUseCase(), newValue[0] as? ExchangeRateUseCase)
            timerExpectation.fulfill()
        }

        viewModel.viewDidLoad()

        wait(for: [persistedExpectation, updateExpectation, timerExpectation], timeout: 1, enforceOrder: true)
    }

    func testExchangeRateItem() {
        let persistedExpectation = XCTestExpectation()

        let oldValue = ExchangeRate()
        coreDataService.retrieveResult = .success([oldValue])

        viewModel.fetchPersistedCurrencyExchangeRates { values in
            XCTAssertEqual(oldValue, values[0])
            persistedExpectation.fulfill()
        }

        let value = viewModel.exchangeRateItem(at: IndexPath(row: 1, section: 0))
        let expectedValue = ExchangeRateUseCase()

        XCTAssertNotNil(value as? ExchangeRateUseCase)
        XCTAssertEqual(expectedValue, value as? ExchangeRateUseCase)

        wait(for: [persistedExpectation], timeout: 1)
    }

    func testRemoveExchangeRateItemCallback() {
        let persistedExpectation = XCTestExpectation()
        let removedExpectation = XCTestExpectation()
        removedExpectation.expectedFulfillmentCount = 3

        let oldValue = ExchangeRate()
        coreDataService.retrieveResult = .success([oldValue])

        viewModel.fetchPersistedCurrencyExchangeRates { values in
            XCTAssertEqual(oldValue, values[0])
            persistedExpectation.fulfill()
        }

        apiService.didRemove = { identifier in
            XCTAssertEqual(oldValue.identifier, identifier)
            removedExpectation.fulfill()
        }

        coreDataService.didDelete = { value in
            XCTAssertEqual(oldValue, value)
            removedExpectation.fulfill()
        }

        viewModel.removeExchangeRateItem(at: IndexPath(row: 1, section: 0)) { isEmpty in
            XCTAssertTrue(isEmpty)
            removedExpectation.fulfill()
        }

        wait(for: [persistedExpectation, removedExpectation], timeout: 1, enforceOrder: true)
    }

    func testPresentCurrencyViewController() {
        let persistedExpectation = XCTestExpectation()
        let expectation = XCTestExpectation()

        let oldValue = ExchangeRate()
        coreDataService.retrieveResult = .success([oldValue])

        viewModel.fetchPersistedCurrencyExchangeRates { values in
            XCTAssertEqual(oldValue, values[0])
            persistedExpectation.fulfill()
        }

        let value = ExchangeRateUseCase()
        flowDelegate.didPresent = { values in
            if value.currencies == values[0] {
                expectation.fulfill()
            }
        }

        viewModel.presentCurrencyViewController()

        wait(for: [expectation], timeout: 1)
    }

    func testIndexReturnIncorrectValue() {
        let index = viewModel.index(from: .zero)

        XCTAssertEqual(index, 0)
    }
}
