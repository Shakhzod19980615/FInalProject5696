//
//  MoneyData.swift
//  Money Manager
//
//  Created by Ismoil Khojiakbarov on 8/1/20.
//  Copyright © 2020 Ismoil Khojiakbarov. All rights reserved.
//

import Foundation
import RealmSwift

class MoneyData: Object {
    @objc dynamic var categorys: Double = 0
    @objc dynamic var addMoney: Double = 0
    @objc dynamic var spendMoney: Double = 0
    @objc dynamic var moneyDate: String = ""
    
    let adds = List<Double>()
    convenience init(add: Double, addArr: Double) {
        self.init()
        self.addMoney = add
        self.adds.append(addArr)
    }
    
    let spends = List<Double>()
    convenience init(spend: Double, spendArr: Double) {
        self.init()
        self.spendMoney = spend
        self.spends.append(spendArr)
    }
    
    let dates = List<String>()
    convenience init(date: String, addArr: String) {
        self.init()
        self.moneyDate = date
        self.dates.append(addArr)
    }
}

