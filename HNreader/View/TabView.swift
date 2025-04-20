//
//  TabView.swift
//  HNreader
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            TabView() {
                ListView(viewModel: ListModel(feedType: .top))
                .tabItem {
                    Label("Top", systemImage: "apple.terminal")
                }
                ListView(viewModel: ListModel(feedType: .new))
                .tabItem {
                    Label("New", systemImage: "sparkles")
                }
                ListView(viewModel: ListModel(feedType: .show))
                .tabItem {
                    Label("Show", systemImage: "eye")
                }
                ListView(viewModel: ListModel(feedType: .ask))
                .tabItem {
                    Label("Ask", systemImage: "questionmark")
                }
            }
        }
    }
}

#Preview {
    MainView()
}
