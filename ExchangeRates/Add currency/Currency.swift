//
//  Currency.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

typealias CurrencyPair = (from: Currency, to: Currency)

enum Currency: String, Decodable {
    case australianDollar = "AUD"
    case bulgarianLev = "BGN"
    case brazilianReal = "BRL"
    case canadianDollar = "CAD"
    case swissFranc = "CHF"
    case chineseYuan = "CNY"
    case czechKoruna = "CZK"
    case danishKrone = "DKK"
    case euro = "EUR"
    case poundSterling = "GBP"
    case hongKongDollar = "HKD"
    case croatianKuna = "HRK"
    case hungarianForint = "HUF"
    case indonesianRupiah = "IDR"
    case israeliNewShekel = "ILS"
    case indianRupee = "INR"
    case icelandicKrona = "ISK"
    case japaneseYen = "JPY"
    case southKoreanWon = "KRW"
    case mexicanPeso = "MXN"
    case malaysianRinggit = "MYR"
    case norwegianKrone = "NOK"
    case newZealandDollar = "NZD"
    case philippinePeso = "PHP"
    case polandZloty = "PLN"
    case romanianLeu = "RON"
    case russianRuble = "RUB"
    case swedishKrona = "SEK"
    case singaporeDollar = "SGD"
    case thaiBaht = "THB"
    case unitedStatesDollar = "USD"
    case southAfricanRand = "ZAR"

    var shortName: String {
        switch self {
        case .australianDollar: return "Australian Dollar"
        case .bulgarianLev: return "Bulgarian Lev"
        case .brazilianReal: return "Brazilian Real"
        case .canadianDollar: return "Canadian Dollar"
        case .swissFranc: return "Swiss Franc"
        case .chineseYuan: return "Chinese Yuan"
        case .czechKoruna: return "Czech Koruna"
        case .danishKrone: return "Danish Krone"
        case .euro: return "Euro"
        case .poundSterling: return "British Pound"
        case .hongKongDollar: return "Hong Kong Dollar"
        case .croatianKuna: return "Croatian Kuna"
        case .hungarianForint: return "Hungarian Forint"
        case .indonesianRupiah: return "Indonesian Rupiah"
        case .israeliNewShekel: return "Israeli Shekel"
        case .indianRupee: return "Indian Rupee"
        case .icelandicKrona: return "Icelandic Króna"
        case .japaneseYen: return "Japanese Yen"
        case .southKoreanWon: return "South Korean Won"
        case .mexicanPeso: return "Mexican Peso"
        case .malaysianRinggit: return "Malaysian Ringgit"
        case .norwegianKrone: return "Norwegian Krone"
        case .newZealandDollar: return "New Zealand Dollar"
        case .philippinePeso: return "Philippine Peso"
        case .polandZloty: return "Poland Złoty"
        case .romanianLeu: return "Romanian Leu"
        case .russianRuble: return "Russian Ruble"
        case .swedishKrona: return "Swedish Krona"
        case .singaporeDollar: return "Singapore Dollar"
        case .thaiBaht: return "Thai Baht"
        case .unitedStatesDollar: return "US Dollar"
        case .southAfricanRand: return "South African Rand"
        }
    }

    var longName: String {
        switch self {
        case .australianDollar: return "Australian Dollar"
        case .bulgarianLev: return "Bulgarian Lev"
        case .brazilianReal: return "Brazilian Real"
        case .canadianDollar: return "Canadian Dollar"
        case .swissFranc: return "Swiss Franc"
        case .chineseYuan: return "Chinese Yuan"
        case .czechKoruna: return "Czech Koruna"
        case .danishKrone: return "Danish Krone"
        case .euro: return "Euro"
        case .poundSterling: return "Great Britain Pound"
        case .hongKongDollar: return "Hong Kong Dollar"
        case .croatianKuna: return "Croatian Kuna"
        case .hungarianForint: return "Hungarian Forint"
        case .indonesianRupiah: return "Indonesian Rupiah"
        case .israeliNewShekel: return "Israeli New Shekel"
        case .indianRupee: return "Indian Rupee"
        case .icelandicKrona: return "Icelandic Króna"
        case .japaneseYen: return "Japanese Yen"
        case .southKoreanWon: return "South Korean Won"
        case .mexicanPeso: return "Mexican Peso"
        case .malaysianRinggit: return "Malaysian Ringgit"
        case .norwegianKrone: return "Norwegian Krone"
        case .newZealandDollar: return "New Zealand Dollar"
        case .philippinePeso: return "Philippine Peso"
        case .polandZloty: return "Poland Złoty"
        case .romanianLeu: return "Romanian Leu"
        case .russianRuble: return "Russian Ruble"
        case .swedishKrona: return "Swedish Krona"
        case .singaporeDollar: return "Singapore Dollar"
        case .thaiBaht: return "Thai Baht"
        case .unitedStatesDollar: return "United States Dollar"
        case .southAfricanRand: return "South African Rand"
        }
    }

    var code: String {
        rawValue
    }
}
