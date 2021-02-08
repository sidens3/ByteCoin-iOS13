//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    
    var delegate : CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "10506D2B-E271-443E-A936-F1B9986CE269"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    

    func getCoinPrice(for currency: String){
        let urlString = baseURL + "/" + currency + "?apikey=" + apiKey
        performRequest(for : urlString)
    }
    
    func performRequest(for urlString: String)  {
        print(urlString)
        if let url = URL(string: urlString) {
//            print("performRequest: create URl")
            let session = URLSession(configuration: .default)
//            print("performRequest: create session")
            let task = session.dataTask(with: url) { (data, response, error) in
                print("performRequest: take request")
                if error != nil {
                    print("performRequest: error")
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    print("performRequest: parse data")
                    let str = String(decoding: safeData, as: UTF8.self)
                    print(str)
                    
                    if let coinModel = parseJson(safeData){
                        
                        self.delegate?.didUpdateCoin(self, coin: coinModel)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(_ data : Data) -> CoinModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let coinRate = decodedData.rate
            return CoinModel(rate: coinRate)
        } catch {
            print("parse error")
            print(error)
            return nil
        }
    }
    
}
protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError( error: Error)
}
