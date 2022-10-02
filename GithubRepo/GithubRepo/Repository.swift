//
//  Repository.swift
//  GithubRepo
//
//  Created by Paweł Brzozowski on 01/10/2022.
//

import Foundation

struct Repository {
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: String
    var avatarData: Data
    
    static let placeholder = Repository(
        name: "Your Repo",
        owner: Owner(avatarUrl: ""),
        hasIssues: true,
        forks: 13,
        watchers: 134,
        openIssues: 30,
        pushedAt: "2022-09-21T15:12:31Z",
        avatarData: Data())
}

extension Repository {
    struct CodingData: Decodable {
        let name: String
        let owner: Owner
        let hasIssues: Bool
        let forks: Int
        let watchers: Int
        let openIssues: Int
        let pushedAt: String
        
        var repo: Repository {
            Repository(name: name,
                       owner: owner,
                       hasIssues: hasIssues,
                       forks: forks,
                       watchers: watchers,
                       openIssues: openIssues,
                       pushedAt: pushedAt,
                       avatarData: Data())
        }
    }
}
struct Owner: Decodable {
    let avatarUrl: String
}
