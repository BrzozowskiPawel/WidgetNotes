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
        RepoEntry(date: Date(), repo: Repository.placeholder, avatarImageData: Data())
    }

    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(
            date: Date(),
            repo: Repository.placeholder,
            avatarImageData: Data())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) //12 hours in seconds
            
            do {
                let repo = try await NetworkManager.shared.getRepo(url: RepoURL.swift)
                let avatar = await NetworkManager.shared.getImage(from: repo.owner.avatarUrl)
                let entry = RepoEntry(date: .now, repo: repo, avatarImageData: avatar ?? Data())
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
    let avatarImageData: Data
}

struct GithubRepoWidgetEntryView : View {
    var entry: RepoEntry
    let formatter = ISO8601DateFormatter()
    var daysSinceLastActivity: Int {
        calculateDays(from: entry.repo.pushedAt)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(uiImage: UIImage(data: entry.avatarImageData) ?? UIImage(systemName: "person.fill")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    Text(entry.repo.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .padding(.bottom, 6)
                
                HStack {
                    StatLabel(value: entry.repo.watchers, imageName: "star.fill")
                    StatLabel(value: entry.repo.forks, imageName: "tuningfork")
                    if entry.repo.hasIssues {
                        StatLabel(value: entry.repo.openIssues, imageName: "exclamationmark.triangle.fill")
                    }
                }
            }
            Spacer()
            VStack {
                Text("\(daysSinceLastActivity)")
                    .fontWeight(.bold)
                    .font(.system(size: 70))
                    .frame(width: 90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundColor(daysSinceLastActivity > 30 ? .pink : .green)
                Text("days ago")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
    
    func calculateDays(from dateString: String) -> Int {
        let activityDate = formatter.date(from: dateString) ?? .now
        return Calendar.current.dateComponents([.day], from: activityDate, to: .now).day ?? 0
    }
}

@main
struct GithubRepoWidget: Widget {
    let kind: String = "GithubRepoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GithubRepoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct GithubRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        GithubRepoWidgetEntryView(entry: RepoEntry(
            date: Date(), repo: Repository.placeholder, avatarImageData: Data()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

fileprivate struct StatLabel: View {
    let value: Int
    let imageName: String
    
    var body: some View {
        Label {
            Text("\(value)")
                .font(.footnote)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        } icon: {
            Image(systemName: imageName)
                .foregroundColor(.green)
        }
        .fontWeight(.medium)
    }
}
