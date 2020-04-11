//
//  Test.swift
//  moyOutlet
//
//  Created by Stepan Stepanov on 17.06.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

import Foundation

struct OfferItemViewConfig {
    let name : String
    let price : String
    let brand : String
    init(model: OfferItem) {
        self.name = model.name
        self.price = String(format:"%.0f ₽",model.price)
        self.brand = ""
        
    }
}

