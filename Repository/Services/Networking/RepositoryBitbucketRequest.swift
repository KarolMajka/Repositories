//
//  RepositoryBitbucketRequest.swift
//  Repository
//
//  Created by Karol on 29/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import Foundation

// MARK: -
class RepositoryBitbucketRequest: APIRequest {

    // MARK: Properties
    let method: RequestType = .get
    let path = "repositories"
    let parameters: [String: String] = {
        var parameters: [String: String] = [:]
        parameters["fields"] = "values.name,values.owner,values.description"
        return parameters
    }()
}
