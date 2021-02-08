//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Михаил Зиновьев on 07.02.2021.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let rate: Double
    var rateString : String {
        String(format: "%0.0f", rate)
    }
}
