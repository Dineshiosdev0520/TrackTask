//
//  ContentView.swift
//  TrackTask
//
//  Created by Dinesh Dev on 07/12/24.
//

import SwiftUICore
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = TodoViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        TabbarScreen().environmentObject(viewRouter)
            .environmentObject(viewModel).environmentObject(profileViewModel)
            .onAppear {
                // Replace the placeholder with the actual modelContext provided by the environment
                viewModel.context = modelContext
                viewModel.fetchTodos()
                
                profileViewModel.context = modelContext
                profileViewModel.fetchProfiles()
            }
    }
}

