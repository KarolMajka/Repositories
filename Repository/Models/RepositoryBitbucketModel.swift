//
//  RepositoryBitbucketModel.swift
//  Repository
//
//  Created by Karol on 29/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import Foundation

// MARK: -
struct RepositoryBitbucketModel {

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
extension RepositoryBitbucketModel {
    enum CodingKeys: String, CodingKey {
        case name
        case owner
        case description
    }

    enum OwnerCodingKeys: String, CodingKey {
        case name = "username"
        case links
    }

    enum LinksCodingKeys: String, CodingKey {
        case avatar
    }

    enum AvatarCodingKeys: String, CodingKey {
        case href
    }
}

// MARK: Decodable
extension RepositoryBitbucketModel: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let name = try values.decode(String.self, forKey: .name)
        let description = try values.decode(String.self, forKey: .description)

        let nestedContainerOwner = try values.nestedContainer(keyedBy: OwnerCodingKeys.self, forKey: .owner)
        let ownerName = try nestedContainerOwner.decode(String.self, forKey: .name)

        let nestedContainerLinks = try nestedContainerOwner.nestedContainer(keyedBy: LinksCodingKeys.self, forKey: .links)
        let nestedContainerAvatar = try nestedContainerLinks.nestedContainer(keyedBy: AvatarCodingKeys.self, forKey: .avatar)
        let ownerAvatarURL = try nestedContainerAvatar.decode(String.self, forKey: .href)

        self.init(name: name, ownerName: ownerName, ownerAvatarURL: ownerAvatarURL, description: description)
    }
}
