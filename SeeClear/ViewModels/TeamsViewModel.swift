//
//  TeamsViewModel.swift
//  SeeClear
//
//  Created by Mohit Gupta on 30/09/26.
//

import Foundation

@MainActor
final class TeamsViewModel {

    enum State {
        case idle
        case loading
        case loaded
        case refreshing
        case failed(String)
        case empty
    }

    private let repository: FPLRepositoryProtocol

    private(set) var teams: [FPLTeam] = []
    private(set) var players: [FPLPlayer] = []

    private(set) var state: State = .idle {
        didSet {
            onStateChange?(state)
        }
    }

    var onStateChange: ((State) -> Void)?

    init(repository: FPLRepositoryProtocol) {
        self.repository = repository
    }

    func load() async {

        if !teams.isEmpty {
            return
        }

        state = .loading

        // First attempt to show cached data.
        if let cached = repository.loadCached() {
            teams = cached.teams
            players = cached.players

            if teams.isEmpty {
                state = .empty
            } else {
                state = .loaded
            }
        }

        do {

            let response =
                try await repository.fetch(forceRefresh: false)

            teams = response.teams
            players = response.players

            state =
                teams.isEmpty
                ? .empty
                : .loaded

        } catch {

            // If cached data exists, keep showing it.
            if !teams.isEmpty {
                state = .loaded
            } else {
                state = .failed(
                    errorMessage(error)
                )
            }
        }
    }

    func refresh() async {

        state = .refreshing

        do {

            let response =
                try await repository.fetch(forceRefresh: true)

            teams = response.teams
            players = response.players

            state =
                teams.isEmpty
                ? .empty
                : .loaded

        } catch {

            // Existing data remains visible.
            state = .loaded

            onRefreshError?(
                errorMessage(error)
            )
        }
    }

    var onRefreshError: ((String) -> Void)?

    private func errorMessage(_ error: Error) -> String {

        if let networkError = error as? NetworkError {
            return networkError.localizedDescription
        }

        return "Something went wrong. Please try again."
    }
}
