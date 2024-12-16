//
//  TabbarScreen.swift
//  TrackTask
//
//  Created by Dinesh Dev on 07/12/24.
//

import SwiftUI

struct TabbarScreen: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var taskData:Todo?
    @State private var toast: CustomToast?
    @State private  var isAddTaskSheetView: Bool = false
    @State private  var isTabbar: Bool = true
   
    @State private var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(taskData: $taskData, toast: $toast).environmentObject(viewRouter)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            AddTaskSheetView(taskData:$taskData, isAddTaskSheet: $isAddTaskSheetView, isTabbar: $isTabbar, toast: $toast)
                .tabItem {
                    Label("Edit", systemImage: "plus.square.dashed")
                }
                .tag(1)
            ProfileView().environmentObject(viewRouter)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.dashed")
                }
                .tag(2)
        }.toastView(toast: $toast)
        .onChange(of: selectedTab) { newTab in
            switch newTab {
            case 0:
                viewRouter.currentPage = .home
            case 1:
                viewRouter.currentPage = .addTask
            case 2:
                viewRouter.currentPage = .settings
            default:
                break
            }
        }
        .onChange(of: viewRouter.currentPage) { newPage in
            switch newPage {
            case .home:
                selectedTab = 0
            case .addTask:
                selectedTab = 1
            case .settings:
                selectedTab = 2
            }
        }
        
    }
}


