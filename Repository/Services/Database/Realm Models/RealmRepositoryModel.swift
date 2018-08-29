//
//  RealmRepositoryModel.swift
//  Repository
//
//  Created by Karol on 29/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: -
class RealmRepositoryModel: Object {

    // MARK: Properties
    @objc dynamic var name: String = ""
    @objc dynamic var ownerName: String = ""
    @objc dynamic var ownerAvatarURL: String = ""
    @objc dynamic var description_p: String = ""
    @objc dynamic var serviceSourceInt: Int = 0

    var serviceSource: ServiceSource {
        return ServiceSource(rawValue: serviceSourceInt) ?? .bitbucket
    }

    // MARK: Initializations
    convenience init(name: String, ownerName: String, ownerAvatarURL: String, description: String, serviceSource: ServiceSource) {
        self.init()
        self.name = name
        self.ownerName = ownerName
        self.ownerAvatarURL = ownerAvatarURL
        self.description_p = description
    }
}
