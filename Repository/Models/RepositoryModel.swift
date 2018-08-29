//
//  RepositoryModel.swift
//  Repository
//
//  Created by Karol on 29/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import Foundation

// MARK: -
enum ServiceSource: Int {
    case bitbucket
    case gitHub
}

// MARK: -
struct RepositoryModel {

    // MARK: Properties
    let name: String
    let ownerName: String
    let ownerAvatarURL: String
    let description: String
    let serviceSource: ServiceSource

    // MARK: Initializations
    init(name: String, ownerName: String, ownerAvatarURL: String, description: String, serviceSource: ServiceSource) {
        self.name = name
        self.ownerName = ownerName
        self.ownerAvatarURL = ownerAvatarURL
        self.description = description
        self.serviceSource = serviceSource
    }
}

// MARK: Coding Keys
extension RepositoryModel {
    enum CodingKeys: String, CodingKey {
        case name
        case ownerName
        case ownerAvatarURL
        case description
        case serviceSource
    }
}

// MARK: Decodable
extension RepositoryModel: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let name = try values.decode(String.self, forKey: .name)
        let ownerName = try values.decode(String.self, forKey: .ownerName)
        let ownerAvatarURL = try values.decode(String.self, forKey: .ownerAvatarURL)
        let description = try values.decode(String.self, forKey: .description)
        let serviceSourceInt = try? values.decode(Int.self, forKey: .serviceSource)
        let serviceSource = ServiceSource(rawValue: serviceSourceInt ?? 0) ?? .bitbucket

        self.init(name: name, ownerName: ownerName, ownerAvatarURL: ownerAvatarURL, description: description, serviceSource: serviceSource)
    }
}

// MARK: Encodable
extension RepositoryModel: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(ownerName, forKey: .ownerName)
        try container.encode(ownerAvatarURL, forKey: .ownerAvatarURL)
        try container.encode(description, forKey: .description)
        try container.encode(serviceSource.rawValue, forKey: .serviceSource)
    }
}
