//
//  PlayerCell.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import UIKit

final class PlayerCell: UITableViewCell {

    static let reuseIdentifier = "PlayerCell"

    private let nameLabel = UILabel()
    private let positionLabel = UILabel()
    private let priceLabel = UILabel()
    private let pointsLabel = UILabel()

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

        positionLabel.font =
            .preferredFont(forTextStyle: .caption1)

        positionLabel.textColor =
            .secondaryLabel

        priceLabel.font =
            .preferredFont(forTextStyle: .subheadline)

        priceLabel.textColor =
            .secondaryLabel

        pointsLabel.font =
            UIFont.monospacedDigitSystemFont(
                ofSize: 17,
                weight: .semibold
            )

        let detailsStack = UIStackView(
            arrangedSubviews: [
                positionLabel,
                priceLabel
            ]
        )

        detailsStack.axis = .horizontal
        detailsStack.spacing = 12

        let leftStack = UIStackView(
            arrangedSubviews: [
                nameLabel,
                detailsStack
            ]
        )

        leftStack.axis = .vertical
        leftStack.spacing = 4

        let mainStack = UIStackView(
            arrangedSubviews: [
                leftStack,
                pointsLabel
            ]
        )

        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 16

        contentView.addSubview(mainStack)

        mainStack.translatesAutoresizingMaskIntoConstraints =
            false

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),

            mainStack.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
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

    func configure(player: FPLPlayer) {

        nameLabel.text = player.fullName

        if let position =
            FPLPosition(
                elementType: player.elementType
            ) {

            positionLabel.text =
                position.title.replacingOccurrences(
                    of: "s",
                    with: ""
                )
        } else {
            positionLabel.text = "Player"
        }

        priceLabel.text = player.price

        pointsLabel.text =
            "\(player.totalPoints)"
    }
}
