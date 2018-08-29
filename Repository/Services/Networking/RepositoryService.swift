//
//  RepositoryService.swift
//  Repository
//
//  Created by Karol on 29/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import Foundation
import RxSwift

// MARK: -
class RepositoryService {

    // MARK: Properties
    let gitHubService: RepositoryGitHubService
    let bitbucketService: RepositoryBitbucketService

    // MARK: Initializations
    init(gitHubService: RepositoryGitHubService, bitbucketService: RepositoryBitbucketService) {
        self.gitHubService = gitHubService
        self.bitbucketService = bitbucketService
    }
}
