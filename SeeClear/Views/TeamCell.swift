//
//  TeamCell.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import UIKit

final class TeamCell: UITableViewCell {

    static let reuseIdentifier = "TeamCell"

    private let nameLabel = UILabel()
    private let shortNameLabel = UILabel()
    private let playerCountLabel = UILabel()
    private let arrowImageView = UIImageView()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        nameLabel.font =
            .preferredFont(forTextStyle: .headline)

        shortNameLabel.font =
            .preferredFont(forTextStyle: .subheadline)

        shortNameLabel.textColor =
            .secondaryLabel

        playerCountLabel.font =
            .preferredFont(forTextStyle: .subheadline)

        playerCountLabel.textColor =
            .secondaryLabel

        arrowImageView.image =
            UIImage(
                systemName: "chevron.right"
            )

        arrowImageView.tintColor =
            .tertiaryLabel

        let textStack = UIStackView(
            arrangedSubviews: [
                nameLabel,
                shortNameLabel
            ]
        )

        textStack.axis = .vertical
        textStack.spacing = 4

        let mainStack = UIStackView(
            arrangedSubviews: [
                textStack,
                playerCountLabel,
                arrowImageView
            ]
        )

        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 12

        textStack.setContentHuggingPriority(
            .defaultLow,
            for: .horizontal
        )

        playerCountLabel.setContentHuggingPriority(
            .required,
            for: .horizontal
        )

        arrowImageView.setContentHuggingPriority(
            .required,
            for: .horizontal
        )

        contentView.addSubview(mainStack)

        mainStack.translatesAutoresizingMaskIntoConstraints =
            false

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 12
            ),

            mainStack.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -12
            ),

            mainStack.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 20
            ),

            mainStack.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -20
            )
        ])
    }

    func configure(
        team: FPLTeam,
        playerCount: Int
    ) {

        nameLabel.text = team.name
        shortNameLabel.text = team.shortName

        playerCountLabel.text =
            "\(playerCount) players"
    }
}
