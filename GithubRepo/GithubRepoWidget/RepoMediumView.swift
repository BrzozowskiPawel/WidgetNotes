//
//  RepoMediumView.swift
//  GithubRepoWidgetExtension
//
//  Created by Paweł Brzozowski on 02/10/2022.
//

import SwiftUI
import WidgetKit

struct RepoMediumView: View {
    let repo: Repository
    let formatter = ISO8601DateFormatter()
    var daysSinceLastActivity: Int {
        calculateDays(from: repo.pushedAt)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(uiImage: UIImage(data: repo.avatarData) ?? UIImage(systemName: "person.fill")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    Text(repo.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .padding(.bottom, 6)
                
                HStack {
                    StatLabel(value: repo.watchers, imageName: "star.fill")
                    StatLabel(value: repo.forks, imageName: "tuningfork")
                    if repo.hasIssues {
                        StatLabel(value: repo.openIssues, imageName: "exclamationmark.triangle.fill")
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

struct RepoMediumView_Previews: PreviewProvider {
    static var previews: some View {
        RepoMediumView(repo: MockData.repo1)
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
