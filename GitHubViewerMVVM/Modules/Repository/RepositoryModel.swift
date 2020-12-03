//
//  Model.swift
//  GitHubViewerMVC
//
//  Created by Andrei Dobysh on 27.11.20.
//

import Foundation

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
    
    static func load(user: String, completion: @escaping (Completion<[RepositoryModel]>) -> Void) {
        DispatchQueue.global().async {
            guard let url = URL(string: "https://api.github.com/users/" + user + "/repos") else {
                DispatchQueue.main.async {
                    completion(.error(RepositoryModelError.url))
                }
                return
            }
            
            do {
                let jsonData = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let repositories = try decoder.decode([RepositoryModel].self, from: jsonData)
                print(repositories)
                DispatchQueue.main.async {
                    completion(.complete(value: repositories))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.error(error))
                }
            }
        }
    }
}
