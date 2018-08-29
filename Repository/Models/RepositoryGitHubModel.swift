//
//  RepositoryGitHubModel.swift
//  Repository
//
//  Created by Karol on 29/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import Foundation

// MARK: -
struct RepositoryGitHubModel {

    // MARK: Properties
    let name: String
    let ownerName: String
    let ownerAvatarURL: String
    let description: String

    // MARK: Initializations
    init(name: String, ownerName: String, ownerAvatarURL: String, description: String) {
        self.name = name
        self.ownerName = ownerName
        self.ownerAvatarURL = ownerAvatarURL
        self.description = description
    }
}

// MARK: Coding Keys
extension RepositoryGitHubModel {
    enum CodingKeys: String, CodingKey {
        case name
        case owner
        case description
    }

    enum OwnerCodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}

// MARK: Decodable
extension RepositoryGitHubModel: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let name = try values.decode(String.self, forKey: .name)
        let description = try values.decode(String?.self, forKey: .description) ?? ""

        let nestedContainer = try values.nestedContainer(keyedBy: OwnerCodingKeys.self, forKey: .owner)
        let ownerName = try nestedContainer.decode(String.self, forKey: .login)
        let ownerAvatarURL = try nestedContainer.decode(String.self, forKey: .avatarUrl)

        self.init(name: name, ownerName: ownerName, ownerAvatarURL: ownerAvatarURL, description: description)
    }
}
