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
    let has_issues: Bool
    let forks: Int
    let watchers: Int
    let open_issues: Int
    let pushed_at: String
    
    static let placeholder = Repository(
        name: "Your Repo",
        owner: Owner(
            avatar_url: ""),
        has_issues: true,
        forks: 13,
        watchers: 134,
        open_issues: 30,
        pushed_at: "2022-08-09T15:12:31Z")
}

struct Owner: Decodable {
    let avatar_url: String
}
