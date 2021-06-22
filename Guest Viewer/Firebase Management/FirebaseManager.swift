//
//  FirebaseManager.swift
//  Guest Viewer
//
//  Created by Justin Oakes on 6/19/21.
//

import Combine
import FirebaseFirestore

class FireBaseManager {
    private enum Constants {
        static let guestCollectionName = "guests"
    }
    private let fireStore = Firestore.firestore()

    func getGuests() -> Future<[Guest], Never> {
        return Future { [fireStore] promise in
            fireStore.collection(Constants.guestCollectionName).getDocuments { snap, _ in
                guard let snap = snap else { return }
                promise(Result.success(snap.documents.compactMap({ try? Guest(dictionary: $0.data()) })))
            }
        }
    }

}
