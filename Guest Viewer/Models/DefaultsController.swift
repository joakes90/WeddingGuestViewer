//
//  DefaultsController.swift
//  Guest Viewer
//
//  Created by Justin Oakes on 6/23/21.
//

import Foundation
import GuestData

class DefaultsController {

    static var sortType: Guests.SortType {
        get {
            return Guests.SortType(rawValue: UserDefaults.standard.integer(forKey: "sort")) ?? .alphabetical
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: "sort")
        }
    }
}
