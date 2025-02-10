//
//  ViewModel.swift
//  Dealer
//
//  Created by 秋星桥 on 2/9/25.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var status: Status = .editing
    @Published var text: String = ""
    @Published var searchType: SearchEngine.EngineType = .web
    @Published var searchTitle: String = ""
    @Published var searchTitleAnimation: String = ""
    @Published var searchSessions: [SearchSession] = []
    @Published var searchSessionsAnimation: [SearchSession] = []
    @Published var expendedIndex: Int = -1

    var estimatedSearchSessions: Int {
        max(1, searchSessions.count + searchSessionsAnimation.count)
    }

    struct SearchSession: Identifiable, Equatable {
        let id = UUID()
        let index: Int
        let engine: SearchEngine
        let keyword: String
    }

    enum Status: String, CaseIterable, Codable {
        case editing
        case searching
    }

    init() {}

    func reset(keepText: Bool = false) {
        status = .editing
        if !keepText { text = "" }
        searchTitle = ""
        searchTitleAnimation = ""
        searchSessions = []
        searchSessionsAnimation = []
        expendedIndex = -1
    }

    func submit() {
        status = .searching
        text = text.replacingOccurrences(of: "\n", with: " ")
        while text.contains("  ") {
            text = text.replacingOccurrences(of: "  ", with: " ")
        }
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)

        let title = String(
            format: NSLocalizedString("Search Result - %@", comment: ""),
            text
        )
        searchTitleAnimation = title
            .trimmingCharacters(in: .whitespacesAndNewlines)
        startAnimationLoop()

        var index = 0
        searchSessionsAnimation = SearchEngine.allCases
            .filter { $0.engineType == searchType }
            .map {
                index += 1
                return SearchSession(index: index, engine: $0, keyword: text)
            }
    }

    func startAnimationLoop() {
        DispatchQueue.global().async {
            while true {
                defer { usleep(10000) }
                var shouldContinue = false
                DispatchQueue.main.asyncAndWait {
                    shouldContinue = self.titleAnimationTik()
                }
                guard shouldContinue else { return }
            }
        }
        DispatchQueue.global().async {
            while true {
                defer { usleep(200_000) }
                var shouldContinue = false
                DispatchQueue.main.asyncAndWait {
                    shouldContinue = self.searchViewAnimationTik()
                }
                guard shouldContinue else { return }
            }
        }
    }

    private func titleAnimationTik() -> Bool {
        guard !searchTitleAnimation.isEmpty else { return false }
        let first = searchTitleAnimation.removeFirst()
        searchTitle.append(first)
        return true
    }

    private func searchViewAnimationTik() -> Bool {
        guard !searchSessionsAnimation.isEmpty else { return false }
        let first = searchSessionsAnimation.removeFirst()
        searchSessions.append(first)
        return true
    }

    func nextSearchType() {
        let allCase = SearchEngine.EngineType.allCases
        guard let index = allCase.firstIndex(of: searchType) else {
            assertionFailure()
            return
        }
        DispatchQueue.main.async { [self] in
            if let next = allCase[safe: index + 1] {
                searchType = next
            } else if let first = allCase.first {
                searchType = first
            }
        }
    }

    func previousSearchType() {
        let allCase = SearchEngine.EngineType.allCases
        guard let index = allCase.firstIndex(of: searchType) else {
            assertionFailure()
            return
        }
        DispatchQueue.main.async { [self] in
            if let previous = allCase[safe: index - 1] {
                searchType = previous
            } else if let last = allCase.last {
                searchType = last
            }
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
