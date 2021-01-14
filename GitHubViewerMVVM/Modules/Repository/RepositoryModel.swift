//
//  Model.swift
//  GitHubViewerMVC
//
//  Created by Andrei Dobysh on 27.11.20.
//

import Foundation
import Combine

enum Completion<T> {
    case complete(value: T)
    case error(_: Error)
}

enum RepositoryModelError: LocalizedError {
    case url
    case someError(message: String)

    var errorDescription: String? {
        switch self {
        case .url:
            return "Something wrong with url"
        case let .someError(message):
            return message
        }
    }
}

struct RepositoryModel: Codable {
    let name: String?
    let createdAt: String?
    
    static var placeholder: Self {
        return RepositoryModel(name: nil, createdAt: nil)
    }
    
    static func fetch(user: String) -> AnyPublisher<[RepositoryModel], Never> {
        guard let url = absoluteURL(user: user) else {
            return Just([RepositoryModel.placeholder])
                .eraseToAnyPublisher()
        }
        return
            URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [RepositoryModel].self, decoder: JSONDecoder())
            .catch { error in Just([RepositoryModel.placeholder]) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    static func absoluteURL(user: String) -> URL? {
        return URL(string: "https://api.github.com/users/" + user + "/repos")
    }
}
