//
//  TeamsViewController.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import UIKit

final class TeamsViewController: UIViewController {

    private let viewModel: TeamsViewModel

    private let tableView = UITableView(
        frame: .zero,
        style: .insetGrouped
    )

    private let activityIndicator =
        UIActivityIndicatorView(
            style: .large
        )

    private let emptyLabel = UILabel()

    private let refreshControl =
        UIRefreshControl()

    private var errorView: UIView?

    init(viewModel: TeamsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Premier League"

        view.backgroundColor =
            .systemBackground

        setupTableView()
        setupLoading()
        setupEmptyState()
        bindViewModel()

        Task {
            await viewModel.load()
        }
    }

    private func setupTableView() {

        tableView.translatesAutoresizingMaskIntoConstraints =
            false

        tableView.register(
            TeamCell.self,
            forCellReuseIdentifier:
                TeamCell.reuseIdentifier
        )

        tableView.dataSource = self
        tableView.delegate = self

        refreshControl.addTarget(
            self,
            action: #selector(refreshPulled),
            for: .valueChanged
        )

        tableView.refreshControl =
            refreshControl

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
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

    private func setupLoading() {

        activityIndicator.translatesAutoresizingMaskIntoConstraints =
            false

        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }

    private func setupEmptyState() {

        emptyLabel.text =
            "No teams available."

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

    private func bindViewModel() {

        viewModel.onStateChange = {
            [weak self] state in

            DispatchQueue.main.async {
                self?.render(state)
            }
        }

        viewModel.onRefreshError = {
            [weak self] message in

            DispatchQueue.main.async {
                self?.showRefreshError(message)
            }
        }
    }

    private func render(
        _ state: TeamsViewModel.State
    ) {

        switch state {

        case .idle:
            break

        case .loading:

            activityIndicator.startAnimating()
            tableView.isHidden = true
            emptyLabel.isHidden = true

        case .loaded:

            activityIndicator.stopAnimating()
            tableView.isHidden = false
            emptyLabel.isHidden = true

            refreshControl.endRefreshing()

            tableView.reloadData()

        case .refreshing:

            tableView.isHidden = false
            activityIndicator.stopAnimating()

        case .empty:

            activityIndicator.stopAnimating()
            tableView.isHidden = true
            emptyLabel.isHidden = false

            refreshControl.endRefreshing()

        case .failed(let message):

            activityIndicator.stopAnimating()
            tableView.isHidden = true
            emptyLabel.isHidden = true

            refreshControl.endRefreshing()

            showInitialError(message)
        }
    }

    private func showInitialError(
        _ message: String
    ) {

        errorView?.removeFromSuperview()

        let container = UIView()
        container.backgroundColor =
            .systemBackground

        let titleLabel = UILabel()
        titleLabel.text = "Unable to load teams"
        titleLabel.font =
            .preferredFont(forTextStyle: .headline)
        titleLabel.textAlignment = .center

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor =
            .secondaryLabel
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        let retryButton =
            UIButton(type: .system)

        retryButton.setTitle(
            "Retry",
            for: .normal
        )

        retryButton.titleLabel?.font =
            .preferredFont(forTextStyle: .headline)

        retryButton.addTarget(
            self,
            action: #selector(retryTapped),
            for: .touchUpInside
        )

        let stack = UIStackView(
            arrangedSubviews: [
                titleLabel,
                messageLabel,
                retryButton
            ]
        )

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16

        container.addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints =
            false

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(
                equalTo: container.centerYAnchor
            ),

            stack.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 30
            ),

            stack.trailingAnchor.constraint(
                equalTo: container.trailingAnchor,
                constant: -30
            )
        ])

        view.addSubview(container)

        container.translatesAutoresizingMaskIntoConstraints =
            false

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(
                equalTo:
                    view.safeAreaLayoutGuide.topAnchor
            ),

            container.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            container.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            container.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            )
        ])

        errorView = container
    }

    private func showRefreshError(
        _ message: String
    ) {

        let alert =
            UIAlertController(
                title: "Refresh Failed",
                message: message,
                preferredStyle: .alert
            )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(
            alert,
            animated: true
        )
    }

    @objc private func retryTapped() {

        errorView?.removeFromSuperview()
        errorView = nil

        Task {
            await viewModel.load()
        }
    }

    @objc private func refreshPulled() {

        Task {
            await viewModel.refresh()
        }
    }
}

import UIKit

extension TeamsViewController:
    UITableViewDataSource,
    UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        viewModel.teams.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier:
                        TeamCell.reuseIdentifier,
                    for: indexPath
                ) as? TeamCell
        else {
            return UITableViewCell()
        }

        let team =
            viewModel.teams[indexPath.row]

        let playerCount =
            viewModel.players.filter {
                $0.team == team.id
            }.count

        cell.configure(
            team: team,
            playerCount: playerCount
        )

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(
            at: indexPath,
            animated: true
        )

        let team =
            viewModel.teams[indexPath.row]

        let squadViewModel =
            SquadViewModel(
                team: team,
                players: viewModel.players
            )

        let controller =
            SquadViewController(
                viewModel: squadViewModel
            )

        navigationController?.pushViewController(
            controller,
            animated: true
        )
    }
}
