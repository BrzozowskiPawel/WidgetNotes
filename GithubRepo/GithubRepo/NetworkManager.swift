//
//  NetworkManager.swift
//  GithubRepo
//
//  Created by Paweł Brzozowski on 02/10/2022.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getRepo(url urlString: String) async throws -> Repository {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try decoder.decode(Repository.self, from: data)
        } catch {
            throw NetworkError.invalidRepoDecoding
        }
    }
    
    func getImage(from urlString: String) async -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            return nil
        }
    }
}

enum NetworkError: Error{
    case invalidURL
    case invalidRepoDecoding
    case invalidResponse
}

enum RepoURL {
    static let swift = "https://api.github.com/repos/apple/swift"
    static let openstack = "https://api.github.com/repos/openstack/swift"
    static let googleSignIn = "https://api.github.com/repos/google/GoogleSignIn-iOS"
}
