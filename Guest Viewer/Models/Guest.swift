//
//  Guest.swift
//  Guest Viewer
//
//  Created by Justin Oakes on 6/18/21.
//

import Foundation
import Firebase

typealias Guests = [Guest]

struct Guest: Hashable {
    let attending: Bool
    let email: String
    let message: String
    let name: String
    let partySize: Int
    private (set) var submittedDate: Date? = nil
}

extension Guest: Codable {
    init(dictionary: [String: Any]) throws {
        var dictionary = dictionary
        submittedDate = (dictionary.removeValue(forKey: "submittedDate") as? Timestamp)?.dateValue()
        self = try JSONDecoder().decode(Guest.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }

    private enum CodingKeys: String, CodingKey {
        case attending
        case email
        case message
        case name
        case partySize
    }
}

struct MastheadItem: Hashable {
    let numberOfReplies: Int
    let numberOfConfirmedYes: Int
    let numberOfConfirmedNo: Int
    let totalGuests: Int
}
