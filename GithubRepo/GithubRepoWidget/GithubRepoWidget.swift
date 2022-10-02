//
//  GithubRepoWidget.swift
//  GithubRepoWidget
//
//  Created by Paweł Brzozowski on 01/10/2022.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
        RepoEntry(date: Date(), repo: Repository.placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(
            date: Date(),
            repo: Repository.placeholder)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) //12 hours in seconds
            
            do {
                var repo = try await NetworkManager.shared.getRepo(url: RepoURL.swift)
                let avatarData = await NetworkManager.shared.getImage(from: repo.owner.avatarUrl)
                repo.avatarData = avatarData ?? Data()
                let entry = RepoEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ failed to get data from NetworkManager: \(error.localizedDescription)")
            }
        }
    }
}

struct RepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
}

struct GithubRepoWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: RepoEntry
    
    var body: some View {
        switch family {
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
        case .systemLarge:
            VStack(spacing: 16) {
                RepoMediumView(repo: entry.repo)
                RepoMediumView(repo: entry.repo)
            }
            .padding()
        case .systemExtraLarge, .systemSmall, .accessoryCircular, .accessoryRectangular, .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

@main
struct GithubRepoWidget: Widget {
    let kind: String = "GithubRepoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GithubRepoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("GithubRepo Widgets")
        .description("Keep track of your favourites github repos")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct GithubRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        GithubRepoWidgetEntryView(entry: RepoEntry(
            date: Date(),
            repo: Repository.placeholder))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
