//
//  RepositoryPresenter.swift
//  GitHubViewerMVVM
//
//  Created by Andrei Dobysh on 1.12.20.
//

import Foundation
import Combine

class RepositoryViewModel: ObservableObject { // todo: combine or didSet or bond
    
    // input
    @Published var name: String = ""
    // output
    @Published var repos: [RepositoryModel] = []
    
    public var count: Int {
        return repos.count
    }
    
    init() {
        $name
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { (name: String) -> AnyPublisher<[RepositoryModel], Never> in
                RepositoryModel.fetch(user: name)
            }
            .assign(to: \.repos, on: self)
            .store(in: &self.cancellableSet)
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func item(for index: Int) -> RepositoryCellModel? {
        if let repositoryModel = repos[safe: index] {
            return RepositoryCellModel(titleMessage: repositoryModel.name ?? "", descriptionMessage: repositoryModel.createdAt ?? "")
        } else {
            return nil
        }
    }
    
}
