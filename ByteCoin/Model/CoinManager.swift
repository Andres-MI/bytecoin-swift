//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(priceCoin: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "14595F6C-A0B3-47FA-8722-1323882FD32E"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
                if(error != nil){
                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    
                }
                if let safeData = data {
                    if let price = parseJson(safeData){
                        let priceString = String(format: "%.4f", price)
                        self.delegate?.didUpdatePrice(priceCoin: priceString, currency: currency)
                    }
                }
            })
            task.resume()
        }
    }
    
    
    func parseJson(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let price = decodedData.rate
            return price
        } catch {
            print(error)
            return nil
        }
    }
}
