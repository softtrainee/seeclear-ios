//
//  SquadViewController.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import UIKit

final class SquadViewController:
    UIViewController {

    private let viewModel: SquadViewModel

    private let tableView = UITableView(
        frame: .zero,
        style: .insetGrouped
    )

    private let emptyLabel = UILabel()

    private var searchController:
        UISearchController!

    init(viewModel: SquadViewModel) {
        self.viewModel = viewModel

        super.init(
            nibName: nil,
            bundle: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title

        view.backgroundColor =
            .systemBackground

        setupSearch()
        setupTableView()
        setupEmptyState()
        reload()
    }

    private func setupSearch() {

        searchController =
            UISearchController(
                searchResultsController: nil
            )

        searchController.searchResultsUpdater =
            self

        searchController.obscuresBackgroundDuringPresentation =
            false

        searchController.searchBar.placeholder =
            "Search players"

        navigationItem.searchController =
            searchController

        navigationItem.hidesSearchBarWhenScrolling =
            false
    }

    private func setupTableView() {

        tableView.translatesAutoresizingMaskIntoConstraints =
            false

        tableView.register(
            PlayerCell.self,
            forCellReuseIdentifier:
                PlayerCell.reuseIdentifier
        )

        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo:
                    view.safeAreaLayoutGuide.topAnchor
            ),

            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            )
        ])
    }

    private func setupEmptyState() {

        emptyLabel.text =
            "No players found."

        emptyLabel.textAlignment =
            .center

        emptyLabel.textColor =
            .secondaryLabel

        emptyLabel.numberOfLines = 0

        emptyLabel.translatesAutoresizingMaskIntoConstraints =
            false

        emptyLabel.isHidden = true

        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            emptyLabel.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),

            emptyLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo:
                    view.leadingAnchor,
                constant: 30
            ),

            emptyLabel.trailingAnchor.constraint(
                lessThanOrEqualTo:
                    view.trailingAnchor,
                constant: -30
            )
        ])
    }

    private func reload() {

        tableView.reloadData()

        let empty =
            viewModel.isEmpty

        tableView.isHidden = empty
        emptyLabel.isHidden = !empty
    }
}

import UIKit

extension SquadViewController:
    UITableViewDataSource,
    UITableViewDelegate {

    func numberOfSections(
        in tableView: UITableView
    ) -> Int {

        viewModel.sections.count
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        let position =
            viewModel.sections[section]

        return viewModel.players(
            for: position
        ).count
    }

    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {

        let position =
            viewModel.sections[section]

        return position.title
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier:
                        PlayerCell.reuseIdentifier,
                    for: indexPath
                ) as? PlayerCell
        else {
            return UITableViewCell()
        }

        let position =
            viewModel.sections[indexPath.section]

        let players =
            viewModel.players(
                for: position
            )

        let player =
            players[indexPath.row]

        cell.configure(
            player: player
        )

        return cell
    }
}

import UIKit

extension SquadViewController:
    UISearchResultsUpdating {

    func updateSearchResults(
        for searchController: UISearchController
    ) {

        let text =
            searchController
                .searchBar
                .text ?? ""

        viewModel.updateSearchText(text)

        reload()
    }
}
