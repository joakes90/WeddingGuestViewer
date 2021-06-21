//
//  MastheadView.swift
//  Guest Viewer
//
//  Created by Justin Oakes on 6/20/21.
//

import UIKit

class MastheadView: UIView {
    struct Model: Hashable {
        let numberOfReplies: Int
        let numberOfConfirmedYes: Int
        let numberOfConfirmedNo: Int
        let totalGuests: Int
    }

    private var containerStack = UIStackView()
    private var titleLabel = UILabel()
    private var repliesCountLabel = UILabel()
    private var yesLabel = UILabel()
    private var noLabel = UILabel()
    private var partySizeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func configureStackView() {
        // Set up container
        containerStack.axis = .vertical
        containerStack.alignment = .fill
        containerStack.distribution = .fillProportionally
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up title label and add to stack
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textAlignment = .center
        containerStack.addArrangedSubview(titleLabel)
        
        // Set up yes/no row
        let repliesStack = UIStackView()
        repliesStack.axis = .horizontal
        repliesStack.alignment = .fill
        repliesStack.distribution = .fill
        
        
        yesLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        yesLabel.textAlignment = .left
        repliesStack.addArrangedSubview(yesLabel)
        
        noLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        noLabel.textAlignment = .right
        repliesStack.addArrangedSubview(noLabel)
        
        // Handling stakcview being janky
        let replySpacer = UIView(frame: .zero)
        repliesStack.addArrangedSubview(replySpacer)
        let repliesSpacerConstraint = replySpacer.widthAnchor.constraint(equalToConstant: 24.0)
        repliesSpacerConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            repliesSpacerConstraint
        ])
        containerStack.addArrangedSubview(repliesStack)

        // Set up total count row
        let totalStack = UIStackView(arrangedSubviews: [repliesCountLabel, partySizeLabel])
        totalStack.axis = .horizontal
        totalStack.alignment = .fill
        totalStack.distribution = .fill
                
        repliesCountLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        repliesCountLabel.textAlignment = .left
        partySizeLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        partySizeLabel.textAlignment = .right
        containerStack.addArrangedSubview(totalStack)
        // Handling stakcview being janky
        let totalSpacer = UIView(frame: .zero)
        totalStack.addArrangedSubview(totalSpacer)
        let totalSpacerConstraint = totalSpacer.widthAnchor.constraint(equalToConstant: 24.0)
        totalSpacerConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            totalSpacerConstraint
        ])
        
        addSubview(containerStack)
        
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8.0),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8.0)
        ])
    }
    func configure(with model: Model) {
        titleLabel.text = "By the numbers"
        repliesCountLabel.text = "Replies: \(model.numberOfReplies)"
        yesLabel.text = "RSVP yes: \(model.numberOfConfirmedYes)"
        noLabel.text = "RSVP no: \(model.numberOfConfirmedNo)"
        partySizeLabel.text = "Guest count: \(model.totalGuests)"
    }
}

class MastheadCell: UITableViewCell {
    
    var mastheadView: MastheadView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        mastheadView = MastheadView(frame: frame)
        mastheadView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mastheadView)
        NSLayoutConstraint.activate([
            mastheadView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mastheadView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mastheadView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mastheadView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with model: MastheadView.Model) {
        mastheadView.configure(with: model)
    }
}
