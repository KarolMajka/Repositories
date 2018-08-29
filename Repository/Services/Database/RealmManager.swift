//
//  RealmManager.swift
//  Repository
//
//  Created by Karol on 29/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: -
class RealmManager {

    // MARK: Methods
    func save(_ object: [RepositoryModel]) {
        let realm = self.getRealm()
        let realmObjectArray = self.map(object)
        write(realm) {
            realm.deleteAll()
            realm.add(realmObjectArray)
        }
    }

    func getRepositories() -> [RepositoryModel] {
        let realm = self.getRealm()
        let realmObjectResults = realm.objects(RealmRepositoryModel.self)
        let objectArray = map(realmObjectResults)
        return objectArray
    }

    // MARK: Private Methods
    private func getRealm() -> Realm {
        do {
            let realm = try Realm()
            return realm
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func write(_ realm: Realm, action: () -> Void) {
        do {
            try realm.write {
                action()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Mappers
private extension RealmManager {
    // MARK: To Realm Object
    func map(_ object: RepositoryModel) -> RealmRepositoryModel {
        let realmObject = RealmRepositoryModel(name: object.name, ownerName: object.ownerName, ownerAvatarURL: object.ownerAvatarURL, description: object.description, serviceSource: object.serviceSource)
        return realmObject
    }

    func map(_ objectArray: [RepositoryModel]) -> List<RealmRepositoryModel> {
        let realmObjectArray = List(objectArray.map { map($0) })
        return realmObjectArray
    }

    // MARK: From Realm Object
    func map(_ realmObject: RealmRepositoryModel) -> RepositoryModel {
        let object = RepositoryModel(name: realmObject.name, ownerName: realmObject.ownerName, ownerAvatarURL: realmObject.ownerAvatarURL, description: realmObject.description_p, serviceSource: realmObject.serviceSource)
        return object
    }

    func map(_ realmObjectArray: Results<RealmRepositoryModel>) -> [RepositoryModel] {
        let objectArray = Array(realmObjectArray.map { self.map($0) })
        return objectArray
    }
}
