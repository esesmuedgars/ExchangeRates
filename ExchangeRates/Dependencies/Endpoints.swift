//
//  Endpoints.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import Foundation

enum Endpoint: String {
    case currencyRates = "revolut-ios"

    private var base: String {
        return "https://europe-west1-revolut-230009.cloudfunctions.net"
    }
}

extension Endpoint {
    func url() -> URL {
        var url = URL(string: base)!
        url.appendPathComponent(rawValue)
        return url
    }

    func request(with parameters: [URLQueryItem]) -> URLRequest {
        var components = URLComponents(url: url(), resolvingAgainstBaseURL: false)!
        components.queryItems = parameters

        return URLRequest(url: components.url!)
    }
}
