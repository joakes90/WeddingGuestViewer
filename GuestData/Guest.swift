//
//  Guest.swift
//  Guest Viewer
//
//  Created by Justin Oakes on 6/18/21.
//

import Foundation
import Firebase

public typealias Guests = [Guest]

public struct GuestData: Hashable {

    public init(numberOfReplies: Int,
                numberOfConfirmedYes: Int,
                numberOfConfirmedNo: Int,
                totalGuests: Int) {
        self.numberOfReplies = numberOfReplies
        self.numberOfConfirmedYes = numberOfConfirmedYes
        self.numberOfConfirmedNo = numberOfConfirmedNo
        self.totalGuests = totalGuests
    }

    public let numberOfReplies: Int
    public let numberOfConfirmedYes: Int
    public let numberOfConfirmedNo: Int
    public let totalGuests: Int
}

public enum VaccinationStatus: String, Codable {
    case hasVax
    case needsTest
    case notAttending = ""


    public var formatedStatus: String {
        switch self {
        case .hasVax:
            return "Vaccination status:  Fully vaccinated"
        case .needsTest:
            return "Vaccination status:  Will provide negitive test"
        case .notAttending:
            return "Vaccination status:  Will not be attending"
        }
    }

    private enum CodingKeys: String, CodingKey {
        case hasVax
        case needsTest
        case notAttending = ""
    }
}

public struct Guest: Hashable {
    public let attending: Bool
    public let vaccinated: VaccinationStatus?
    public let email: String
    public let message: String
    public let name: String
    public let partySize: Int
    private (set) var submittedDate: Date?
}

extension Guest: Codable {
    init(dictionary: [String: Any]) throws {
        var dictionary = dictionary
        let submittedDate = (dictionary.removeValue(forKey: "submittedDate") as? Timestamp)?.dateValue()
        self = try JSONDecoder().decode(Guest.self, from: JSONSerialization.data(withJSONObject: dictionary))
        self.submittedDate = submittedDate
    }

    private enum CodingKeys: String, CodingKey {
        case attending
        case email
        case message
        case name
        case partySize
        case vaccinated
    }
}

public extension Guests {

    enum SortType: Int {
        case partySize
        case dateAdded
        case alphabetical
    }

    func sortedBy(_ sortType: SortType) -> Guests {
        switch sortType {
        case .alphabetical:
            return self.sorted(by: { $0.name < $1.name })
        case .dateAdded:
            return self.sorted(by: { ($0.submittedDate ?? .distantPast) < ($1.submittedDate ?? .distantFuture)})
        case .partySize:
            return self.sorted(by: { $0.partySize > $1.partySize })
        }
    }
}
