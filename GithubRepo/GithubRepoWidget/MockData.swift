//
//  MockData.swift
//  GithubRepoWidgetExtension
//
//  Created by Paweł Brzozowski on 02/10/2022.
//

import Foundation

struct MockData {
    static let repo1 = Repository(
        name: "Your Repo",
        owner: Owner(avatarUrl: ""),
        hasIssues: true,
        forks: 33,
        watchers: 134,
        openIssues: 30,
        pushedAt: "2022-09-21T15:12:31Z",
        avatarData: Data())
    
    static let repo2 = Repository(
        name: "Your Second",
        owner: Owner(avatarUrl: ""),
        hasIssues: false,
        forks: 10,
        watchers: 78,
        openIssues: 0,
        pushedAt: "2022-07-21T15:12:31Z",
        avatarData: Data())
}
