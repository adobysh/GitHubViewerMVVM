//
//  RepositoryPresenter.swift
//  GitHubViewerMVVM
//
//  Created by Andrei Dobysh on 1.12.20.
//

import Foundation

class RepositoryViewModel {
    
    public var count: Int {
        return repositories.count
    }
    private var repositories: [RepositoryModel] = []
    
    func show(user: String, completion: @escaping (Error?) -> Void) {
        RepositoryModel.load(user: user) { [weak self] result in
            switch result {
            case .complete(let value):
                self?.repositories = value
                completion(nil)
            case .error(let error):
                self?.repositories = []
                completion(error)
            }
        }
    }
    
    func item(for index: Int) -> RepositoryModel {
        return repositories[index]
    }
    
}
