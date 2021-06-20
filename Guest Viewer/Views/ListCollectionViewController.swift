//
//  ListCollectionViewController.swift
//  Guest Viewer
//
//  Created by Justin Oakes on 6/19/21.
//

import Combine
import UIKit

class ListCollectionViewController: UIViewController {
    
    private let firebaseManager = FireBaseManager()
    private var guestFuture: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        updateGuests()
    }
    
    private func updateGuests() {
        guestFuture = firebaseManager.getGuests()
            .sink() { guests in
                guests.forEach({ print($0.name) })
            }
            
    }
}
