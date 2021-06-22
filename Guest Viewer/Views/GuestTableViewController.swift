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
    private var activityIndicator: UIActivityIndicatorView!

    // Supporting objects
    private let firebaseManager = FireBaseManager()
    private var guestFuture: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateGuests()
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGroupedBackground
        title = "Guests"
        navigationController?.navigationBar.prefersLargeTitles = true
        addBarButtons()
        
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        activityIndicator = UIActivityIndicatorView(style: .large)
        tableView.backgroundView = activityIndicator
        activityIndicator.startAnimating()
        
        // Add refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateGuests), for: .valueChanged)
        tableView.refreshControl = refreshControl

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
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc private func updateGuests() {
        guestFuture = firebaseManager.getGuests()
            .sink() { [weak self] guests in
                self?.tableView.refreshControl?.endRefreshing()
                self?.activityIndicator.stopAnimating()
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
    
    private func addBarButtons() {
        let size = UIAction(title: "Sort by party size",
                            image: UIImage(systemName: "person.3")) { [weak self] _ in
            guard let items = self?.dataSource.snapshot().itemIdentifiers(inSection: .guests) else { return }
            let guests: [Guest] = items.compactMap({ item in
                switch item {
                case .guest(let guest): return guest
                case _: return nil
                }
            })
            self?.buildSnap(for: guests.sorted(by: { $0.partySize > $1.partySize }))
        }
        
        let alphabetical = UIAction(title: "Sort by name",
                            image: UIImage(systemName: "person.circle")) { [weak self] _ in
            guard let items = self?.dataSource.snapshot().itemIdentifiers(inSection: .guests) else { return }
            let guests: [Guest] = items.compactMap({ item in
                switch item {
                case .guest(let guest): return guest
                case _: return nil
                }
            })
            self?.buildSnap(for: guests.sorted(by: { $0.name < $1.name }))
        }
        let dateAdded = UIAction(title: "Sort by date added",
                                 image: UIImage(systemName: "calendar.circle")) { [weak self] _ in
            guard let items = self?.dataSource.snapshot().itemIdentifiers(inSection: .guests) else { return }
            let guests: [Guest] = items.compactMap({ item in
                switch item {
                case .guest(let guest): return guest
                case _: return nil
                }
            })

            self?.buildSnap(for: guests.sorted(by: { $0.submittedDate ?? Date.distantPast < $1.submittedDate ?? Date.distantFuture}))
        }
        
        let menu = UIMenu(title: "Sort", options: .displayInline, children: [size, alphabetical, dateAdded])
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.circle"), menu: menu)
        navigationItem.rightBarButtonItem = sortButton
    }
    
    @objc func setSort() {
        print("set sort")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Section(rawValue: indexPath.section) {
        case .guests:
            if case .guest(let guest) = dataSource.itemIdentifier(for: indexPath) {
                let detailView = GuestDetailViewViewController()
                detailView.config(with: guest)
                navigationController?.pushViewController(detailView, animated: true)
            }
        default:
            return
        }
    }
}
