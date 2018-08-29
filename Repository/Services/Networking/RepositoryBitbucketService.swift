//
//  RepositoryBitbucketService.swift
//  Repository
//
//  Created by Karol on 29/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import Foundation
import RxSwift

// MARK: -
class RepositoryBitbucketService: APIClient {

    // MARK: Properties
    var baseURL = URL(string: "https://api.bitbucket.org/2.0/")! // swiftlint:disable:this force_unwrapping

    // MARK: Methods
    func load() -> Observable<[String: [RepositoryBitbucketModel]]> {
        return load(apiRequest: RepositoryBitbucketRequest())
    }
}
