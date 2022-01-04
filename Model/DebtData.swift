//
//  DebtData.swift
//  Money Manager
//
//  Created by Ismoil Khojiakbarov on 8/4/20.
//  Copyright © 2020 Ismoil Khojiakbarov. All rights reserved.
//

import Foundation
import RealmSwift

class DebtData: Object {
    @objc dynamic var debt: Bool = false
    @objc dynamic var dateDebt: String = ""
    @objc dynamic var moneyDebt: String = ""
    @objc dynamic var sourceDebt: String = ""
}
