//
//  ListCollectionViewController.swift
//  Guest Viewer
//
//  Created by Justin Oakes on 6/19/21.
//

import Combine
import UIKit

class ListCollectionViewController: UIViewController {

    enum Section {
        case main
        case masthead
    }
    
    // Subviews
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Guest>!

    // Supporting objects
    private let firebaseManager = FireBaseManager()
    private var guestFuture: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateGuests()
        title = "Guests"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureCollection()

        // Register Cells
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "main")
//        collectionView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellWithReuseIdentifier: "masthead")

        
        // Auto layout
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureCollection() {
        // Build collection view
        let layoutConf = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConf)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
    }

    private func updateGuests() {
        guestFuture = firebaseManager.getGuests()
            .sink() { guests in
                guests.forEach({ print($0.name) })
            }
            
    }
}
