//
//  RepositoryFilterOptions.swift
//  Repository
//
//  Created by Karol on 29/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import Foundation

// MARK: -
extension RepositoryFilterOptions {
    enum SortOrder: Int {
        case none = 0
        case ascending
        case descending

        static let all: [SortOrder] = [.none, .ascending, .descending]

        func compare<T: Comparable>(_ left: T, _ right: T) -> Bool {
            switch self {
            case .ascending:
                return left < right
            case .descending:
                return left > right
            case .none:
                return false
            }
        }
    }

    enum SortType: Int {
        case name = 0
        case description
        case ownerName

        static let all: [SortType] = [.name, .description, .ownerName]
    }
}

// MARK: -
struct RepositoryFilterOptions {

    // MARK: Properties
    var sortOrder: SortOrder = .none
    var sortType: SortType = .name
    var filterText = ""

    // MARK: Methods
    func filter(repositoryArray: [RepositoryModel]) -> [RepositoryModel] {
        guard filterText != "" else { return repositoryArray }

        return repositoryArray.filter {
            guard $0.name.contains(self.filterText) || $0.description.contains(self.filterText) || $0.ownerName.contains(self.filterText) else { return false }
            return true
        }
    }

    func sort(repositoryArray: [RepositoryModel]) -> [RepositoryModel] {
        guard sortOrder != .none else { return repositoryArray }

        return repositoryArray.sorted {
            switch sortType {
            case .name:
                return sortOrder.compare($0.name.lowercased(), $1.name.lowercased())
            case .description:
                return sortOrder.compare($0.description.lowercased(), $1.description.lowercased())
            case .ownerName:
                return sortOrder.compare($0.ownerName.lowercased(), $1.ownerName.lowercased())
            }
        }
    }
}

// MARK: -
extension Array where Iterator.Element == RepositoryModel {
    func filter(options: RepositoryFilterOptions) -> [Iterator.Element] {
        let filteredEventArray = options.filter(repositoryArray: self)
        let sortedEventArray = options.sort(repositoryArray: filteredEventArray)
        return sortedEventArray
    }
}
