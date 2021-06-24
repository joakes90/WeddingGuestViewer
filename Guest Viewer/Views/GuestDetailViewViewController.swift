//
//  GuestDetailViewViewController.swift
//  Guest Viewer
//
//  Created by Justin Oakes on 6/21/21.
//

import UIKit
import UILabel_Copyable

class GuestDetailViewViewController: UIViewController {

    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let attendingLabel = UILabel()
    private let partySizeLabel = UILabel()
    private let messageLabel = UILabel()
    private let emailRow = UIStackView()
    private let messageRow = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        super.loadView()

        view.backgroundColor = .systemBackground
        title = "Guest info"
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 0.0
        stackView.translatesAutoresizingMaskIntoConstraints = false

        buildNameRow()

        buildEmailRow()

        attendingLabel.font = UIFont.preferredFont(forTextStyle: .body)
        stackView.addArrangedSubview(attendingLabel)

        partySizeLabel.font = UIFont.preferredFont(forTextStyle: .body)
        stackView.addArrangedSubview(partySizeLabel)

        buildMessageRow()

        let spacer = UIView()
        stackView.addArrangedSubview(spacer)

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16.0),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16.0)
        ])
    }

    fileprivate func buildNameRow() {
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        nameLabel.isCopyingEnabled = true
        stackView.addArrangedSubview(nameLabel)
    }

    fileprivate func buildEmailRow() {
        emailRow.axis = .horizontal
        emailRow.alignment = .firstBaseline
        emailRow.distribution = .equalSpacing
        emailRow.spacing = 10.0

        let emailTitleLabel = UILabel()
        emailTitleLabel.text = "Email: "
        emailTitleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        emailRow.addArrangedSubview(emailTitleLabel)

        emailLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        emailRow.addArrangedSubview(emailLabel)

        stackView.addArrangedSubview(emailRow)
    }

    fileprivate func buildMessageRow() {
        messageRow.axis = .horizontal
        messageRow.alignment = .firstBaseline
        messageRow.distribution = .equalSpacing
        messageRow.spacing = 10.0

        let messageTitleLabel = UILabel()
        messageTitleLabel.text = "Message: "
        messageTitleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        messageRow.addArrangedSubview(messageTitleLabel)

        messageLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.numberOfLines = 0
        messageLabel.isCopyingEnabled = true

        let messageWrapper = UIStackView(arrangedSubviews: [messageLabel])
        messageWrapper.axis = .horizontal
        messageWrapper.alignment = .firstBaseline
        messageWrapper.distribution = .fill

        messageRow.addArrangedSubview(messageWrapper)
        let messageSpacer = UIView()
        messageRow.addArrangedSubview(messageSpacer)
        stackView.addArrangedSubview(messageRow)
    }

    func config(with guest: Guest) {
        nameLabel.text = guest.name
        emailLabel.text = guest.email
        emailLabel.isCopyingEnabled = !guest.email.isEmpty
        emailRow.isHidden = guest.email.isEmpty
        attendingLabel.text = "Attending: \(guest.attending ? "True" : "False")"
        partySizeLabel.text = "Party size: \(guest.partySize)"
        messageLabel.text = guest.message
        messageRow.isHidden = guest.message.isEmpty
    }

}
