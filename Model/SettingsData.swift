//
//  File.swift
//  Money Manager
//
//  Created by Ismoil Khojiakbarov on 8/8/20.
//  Copyright © 2020 Ismoil Khojiakbarov. All rights reserved.
//

import Foundation
import RealmSwift

class SettingsData: Object {
    @objc dynamic var language: String = ""
    @objc dynamic var currency: String = ""
}
