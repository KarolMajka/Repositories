//
//  MasterViewModel.swift
//  Repository
//
//  Created by Karol on 29/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: -
class MasterViewModel {

    // MARK: Properties
    lazy var dataSource: Driver<[RepositoryModel]> = {
        return Observable.combineLatest(bitbucketDataSource, gitHubDataSource, repositoryFilterOptions.asObservable()) {
            return ($0 + $1).filter(options: $2)
        }.asDriver(onErrorJustReturn: [])
    }()

    private let disposeBag = DisposeBag()
    private let repositoryService: RepositoryService
    private let realmManager: RealmManager

    lazy private var zipDataSource: Observable<[RepositoryModel]> = {
        return Observable.zip(bitbucketDataSource, gitHubDataSource) {
            return $0 + $1
        }
    }()

    let onFailure = PublishSubject<Error>()
    let repositoryFilterOptions = Variable<RepositoryFilterOptions>(RepositoryFilterOptions())
    private let gitHubDataSource = PublishSubject<[RepositoryModel]>()
    private let bitbucketDataSource = PublishSubject<[RepositoryModel]>()

    // MARK: Initializations
    init(repositoryService: RepositoryService, realmManager: RealmManager) {
        self.repositoryService = repositoryService
        self.realmManager = realmManager
    }

    // MARK: Methods
    func loadCachedData() {
        getFromRealm()
        subscribeForRealm()
    }

    func loadData() {
        loadGitHubData()
        loadBitbucketData()
    }

    // MARK: Private Methods
    private func loadGitHubData() {
        repositoryService.gitHubService.load().map {
            $0.compactMap { RepositoryModel(name: $0.name, ownerName: $0.ownerName, ownerAvatarURL: $0.ownerAvatarURL, description: $0.description, serviceSource: .gitHub) }
        }.subscribe { [weak self] event in
            switch event {
            case .error(let error):
                self?.onFailure.onNext(error)
            case .next(let element):
                self?.gitHubDataSource.onNext(element)
            case .completed:
                break
            }
        }.disposed(by: disposeBag)
    }

    private func loadBitbucketData() {
        repositoryService.bitbucketService.load().map { $0.values.first ?? [] }.map {
            $0.compactMap { RepositoryModel(name: $0.name, ownerName: $0.ownerName, ownerAvatarURL: $0.ownerAvatarURL, description: $0.description, serviceSource: .bitbucket) }
        }.subscribe { [weak self] event in
            switch event {
            case .error(let error):
                self?.onFailure.onNext(error)
            case .next(let element):
                self?.bitbucketDataSource.onNext(element)
            case .completed:
                break
            }
        }.disposed(by: disposeBag)
    }

    // MARK: Configuration
    private func getFromRealm() {
        let repositoryArray = realmManager.getRepositories()
        var gitHubRepositoryArray: [RepositoryModel] = []
        var bitbucketRepositoryArray: [RepositoryModel] = []

        for repository in repositoryArray {
            switch repository.serviceSource {
            case .bitbucket:
                bitbucketRepositoryArray.append(repository)
            case .gitHub:
                gitHubRepositoryArray.append(repository)
            }
        }
        gitHubDataSource.onNext(gitHubRepositoryArray)
        bitbucketDataSource.onNext(bitbucketRepositoryArray)
    }

    private func subscribeForRealm() {
        zipDataSource.bind(onNext: { self.realmManager.save($0) }).disposed(by: disposeBag)
    }
}
