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
        tableView.delegate = self
        view.addSubview(tableView)

        // Register Cells
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "guest")
        tableView.register(MastheadCell.self, forCellReuseIdentifier: "masthead")
        
        // Implement data source
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            switch item {
            case .guest(let guest):
                let cell = tableView.dequeueReusableCell(withIdentifier: "guest")
                cell?.textLabel?.text = guest.name
                cell?.accessoryType = .disclosureIndicator
                return cell
            case .mastheadData(let mastheadData):
                let cell = tableView.dequeueReusableCell(withIdentifier: "masthead") as? MastheadCell
                cell?.configure(with: mastheadData)
                return cell
            }
        })
    }

    private func updateGuests() {
        guestFuture = firebaseManager.getGuests()
            .sink() { [weak self] guests in
                self?.buildSnap(for: guests)
            }
            
    }
    
    private func buildSnap(for guests: Guests) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([Section.masthead, Section.guests])
        // Adding masthead
        let item = MastheadItem(numberOfReplies: guests.count,
                                numberOfConfirmedYes: guests.filter( { $0.attending == true} ).count,
                                numberOfConfirmedNo: guests.filter( { $0.attending == false } ).count,
                                totalGuests: (guests.compactMap( { $0.partySize } )).reduce(0, +) )
        snapshot.appendItems([Item.mastheadData(item)], toSection: .masthead)
        
        // Adding guests
        
        snapshot.appendItems(guests.map({ Item.guest($0) }), toSection: .guests)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

extension GuestTableViewController {
    enum Section: Int {
        case masthead
        case guests
    }
    
    enum Item: Hashable {
        case guest(Guest)
        case mastheadData(MastheadItem)
    }
}

extension GuestTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section) {
        case .masthead:
            return 115.0
        case .guests:
            return UITableView.automaticDimension
        case .none:
            return 0.0
        }
    }
}
