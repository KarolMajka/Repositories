//
//  RepositoryGitHubService.swift
//  Repository
//
//  Created by Karol on 29/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import Foundation
import RxSwift

// MARK: -
class RepositoryGitHubService: APIClient {

    // MARK: Properties
    var baseURL = URL(string: "https://api.github.com/")! // swiftlint:disable:this force_unwrapping

    // MARK: Methods
    func load() -> Observable<[RepositoryGitHubModel]> {
        return load(apiRequest: RepositoryGitHubRequest())
    }
}
