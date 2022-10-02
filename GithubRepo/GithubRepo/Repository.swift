//
//  Repository.swift
//  GithubRepo
//
//  Created by Paweł Brzozowski on 01/10/2022.
//

import Foundation

struct Repository: Decodable {
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: String
    
    static let placeholder = Repository(
        name: "Your Repo",
        owner: Owner(avatarUrl: ""),
        hasIssues: true,
        forks: 13,
        watchers: 134,
        openIssues: 30,
        pushedAt: "2022-09-21T15:12:31Z")
}

struct Owner: Decodable {
    let avatarUrl: String
}
