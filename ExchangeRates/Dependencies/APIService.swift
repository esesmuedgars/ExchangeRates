//
//  APIService.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import Foundation

enum APIServiceError: Error {
    case emptyDataOrError
    case unexpectedStatusCode(statusCode: Int)
    case unableToParseDataWith(error: Error)
}

extension APIServiceError {
    var description: String {
        switch self {
        case .emptyDataOrError:
            return "Request did not fetch data or returned error."
        case .unexpectedStatusCode(let statusCode):
            return "Expected request status code between 200 - 299, received \(statusCode)."
        case .unableToParseDataWith(let error):
            return "Unable to parse data, with error: \(error)."
        }
    }
}

typealias ExchangeRateCompletionBlock = (Result<[ExchangeRate], APIServiceError>) -> Void

protocol APIServiceProtocol: AnyObject {
    func addCurrencyPairs(_ pairs: [String])
    func addCurrencyPair(_ a: String, _ b: String)
    func removeCurrency(_ value: String)

    func fetchCurrencyExchangeRates(completionHandler complete: @escaping ExchangeRateCompletionBlock)
}

final class APIService: APIServiceProtocol {

    private var parameters = [URLQueryItem]()

    func addCurrencyPairs(_ pairs: [String]) {
        parameters.append(contentsOf: pairs.map(URLQueryItem.init))
    }

    func addCurrencyPair(_ a: String, _ b: String) {
        parameters.append(URLQueryItem(value: a + b))
    }

    func removeCurrency(_ value: String) {
        parameters.removeAll { $0.value == value }
    }

    func fetchCurrencyExchangeRates(completionHandler complete: @escaping ExchangeRateCompletionBlock) {

        let request = Endpoint.currencyRates.request(with: parameters)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                complete(.failure(.emptyDataOrError))
                return
            }

            guard 200 ..< 300 ~= response.statusCode else {
                complete(.failure(.unexpectedStatusCode(statusCode: response.statusCode)))
                return
            }

            do {
                let model = try ExchangeRateDataModel(from: data)
                complete(.success(model.rates))
            } catch {
                complete(.failure(.unableToParseDataWith(error: error)))
            }
        }.resume()
    }
}

fileprivate extension URLQueryItem {
    init(value: String) {
        self.init(name: "pairs", value: value)
    }
}
