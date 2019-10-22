//
//  Dependencies.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

final class Dependencies {
    
    private(set) static var shared = Dependencies()

    private let _apiService = APIService()
    var apiService: APIServiceProtocol {
        return _apiService
    }

    private let _coreDataService = CoreDataService()
    var coreDataService: CoreDataServiceProtocol {
        return _coreDataService
    }
}
