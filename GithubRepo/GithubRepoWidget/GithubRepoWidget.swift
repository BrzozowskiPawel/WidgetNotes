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
        var entries: [RepoEntry] = []


        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct RepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
}

struct GithubRepoWidgetEntryView : View {
    var entry: RepoEntry

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Circle()
                        .frame(width: 50, height: 50)
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
                    StatLabel(value: entry.repo.open_issues, imageName: "exclamationmark.triangle.fill")
                }
            }
            Spacer()
            VStack {
                Text("99")
                    .fontWeight(.bold)
                    .font(.system(size: 70))
                    .frame(width: 90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Text("days ago")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
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
            date: Date(), repo: Repository.placeholder))
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
        } icon: {
            Image(systemName: imageName)
                .foregroundColor(.green)
        }
        .fontWeight(.medium)
    }
}
