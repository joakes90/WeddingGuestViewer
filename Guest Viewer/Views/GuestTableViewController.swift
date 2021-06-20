//
//  GuestTableViewController.swift
//  Guest Viewer
//
//  Created by Justin Oakes on 6/19/21.
//

import Combine
import UIKit

class GuestTableViewController: UIViewController {
    // Subviews
    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Section, Item>!

    // Supporting objects
    private let firebaseManager = FireBaseManager()
    private var guestFuture: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateGuests()
        title = "Guests"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        view.addSubview(tableView)

        // Register Cells
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "guest")
        
        // Implement data source
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            switch item {
            case .guest(let guest):
                let cell = tableView.dequeueReusableCell(withIdentifier: "guest")
                cell?.textLabel?.text = guest.name
                cell?.accessoryType = .disclosureIndicator
                return cell
            case .mastheadData(let mastheadData):
                print(mastheadData)
                return UITableViewCell()
            }
        })

        
        // Auto layout
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func updateGuests() {
        guestFuture = firebaseManager.getGuests()
            .sink() { [weak self] guests in
                self?.buildSnap(for: guests)
            }
            
    }
    
    private func buildSnap(for guests: Guests) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        // TODO: implment masthead cell
        
        // adding guests
        snapshot.appendSections([Section.guests])
        snapshot.appendItems(guests.map({ Item.guest($0) }))
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

extension GuestTableViewController {
    enum Section {
        case masthead
        case guests
    }
    
    enum Item: Hashable {
        case guest(Guest)
        case mastheadData(MastheadItem)
    }
}
