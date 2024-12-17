//
//  TrackTaskApp.swift
//  TrackTask
//
//  Created by Dinesh Dev on 07/12/24.
//

import SwiftUI
import SwiftData
@main
struct TrackTaskApp: App {
    @StateObject private var viewRouter = ViewRouter()
    var body: some Scene {
        WindowGroup {
            SplashScreenView().modelContainer(for: [Todo.self,Profile.self])
                .environmentObject(viewRouter)
        }
    }
}


class ViewRouter:ObservableObject{
    @Published var currentPage : Page = .home
}
enum Page: String {
    case home
    case addTask
    case settings
}

