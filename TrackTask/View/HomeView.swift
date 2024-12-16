//
//  HomeView.swift
//  TrackTask
//
//  Created by Dinesh Dev on 07/12/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var viewModel : TodoViewModel
    @State private  var isAddTaskSheetView: Bool = false
    @State private  var isTabbar: Bool = false
    @State private var searchText: String = ""
    @Binding var taskData:Todo?
    @State private var profile:Profile?
    @Binding var toast:CustomToast?
    @State var selectedIndex = 0
    
    let options: [SegmentControlItem] = TaskType.allCases.map { $0.segmentItem }
    
    var filteredTasks: [Todo] {
        let filteredBySearch: [Todo] = {
            if searchText.isEmpty {
                return viewModel.todos
            } else {
                return viewModel.todos.filter { task in
                    task.task.localizedCaseInsensitiveContains(searchText) ||
                    task.desc.localizedCaseInsensitiveContains(searchText) ||
                    task.priority.rawValue.localizedCaseInsensitiveContains(searchText)
                }
            }
        }()
        let filtered: [Todo]
        switch TaskType.allCases[selectedIndex] {
        case .all:
            filtered = filteredBySearch
        case .active:
            filtered = filteredBySearch.filter { $0.status == .active }
        case .pending:
            filtered = filteredBySearch.filter { $0.status == .pending }
        case .completed:
            filtered = filteredBySearch.filter { $0.status == .completed }
        }
        
        // Sort by default order: pending > active > completed
        return filtered.sorted {
            let order: [TaskStatus: Int] = [.pending: 0, .active: 1, .completed: 2]
            return (order[$0.status] ?? 3) < (order[$1.status] ?? 3)
        }
    }
    
    var body: some View {
        VStack(spacing:0){
            HStack(){
                Button(action: {withAnimation{viewRouter.currentPage = .settings}}, label: {
                    Image(profile?.image ?? "empty_avatar").resizable().frame(width: 40 ,height: 40).aspectRatio(contentMode: .fit).cornerRadius(22.5)
                })
                VStack(alignment:.leading,spacing:4){
                    Text(profile?.username ?? "Dashboard").font(Font.custom("Lato-Bold", size: 17))
                    Text(profile?.email ?? "Add Your profile.").font(Font.custom("Lato-Bold", size: 13)).foregroundColor(.gray)
                }
                Spacer()
                Button(action: { withAnimation{ viewRouter.currentPage = .addTask }}, label: {
                    Image(systemName: "widget.large.badge.plus").font(.system(size: 20))
                })
                
            }.padding(.horizontal).padding(.vertical,10).background(.ultraThinMaterial)
            ScrollView(showsIndicators:false){
                if viewModel.todos.isEmpty{
                    VStack{
                        if profileVM.profile.isEmpty{
                            UpdateRequreView(title: "STEP 1 : Update Profile", message: "Profile Update Require to add your tasks", btnTitle: "Update", imageName: "person.fill"){
                                viewRouter.currentPage = .settings
                            }
                        }else{
                            UpdateRequreView(title: "STEP 2 : Task Update", message: "Now, You can add your tasks", btnTitle: "Add", imageName: "plus.circle.fill"){
                                viewRouter.currentPage = .addTask
                            }
                        }
                        EmptyTaskView(isAddTaskSheetView: $isAddTaskSheetView)
                    }
                }else{
                    SearchBarView(text: $searchText).padding()
                    SegmentControl(
                        selectedIndex: $selectedIndex,
                        options: options,imageColor: .orange
                    ){
                        
                    }.padding(.horizontal)
                    VStack{
                        Section(header: Text("".uppercased()).font(Font.custom("Lato", size: 12)).frame(maxWidth: .infinity,alignment: .leading).foregroundColor(.gray)) {
                            if viewModel.todos.isEmpty || filteredTasks.isEmpty{
                                VStack(spacing:0){
                                    Image("empty")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100)
                                    Text("No more active tasks")
                                        .font(Font.custom("Lato-Regular", size: 16))
                                }.padding()
                            }else{
                                ForEach(filteredTasks, id: \.id) { task in
                                    TodoTaskCardView(toast: $toast,
                                                     taskData: Binding(
                                                        get: { task },
                                                        set: { updatedTask in
                                                            if let index = viewModel.todos.firstIndex(where: { $0.id == task.id }) {
                                                                viewModel.todos[index] = updatedTask ?? task
                                                            }
                                                        }
                                                        
                                                     ))
                                }
                            }
                        }
                    }.padding()
                }
            }
        }.onAppear{
            viewModel.fetchTodos()
            profileVM.fetchProfiles()
            if let new_profile = profileVM.profile.first{
                profile = new_profile
            }
        }
        .sheet(isPresented: $isAddTaskSheetView, content: {
            AddTaskSheetView(taskData:$taskData,isAddTaskSheet: $isAddTaskSheetView, isTabbar: $isTabbar,toast: $toast)
        })
        
    }
    
    func binding(for task: Todo) -> Binding<Todo> {
        Binding(
            get: { task },
            set: { updatedTask in
                if let index = viewModel.todos.firstIndex(where: { $0.id == task.id }) {
                    viewModel.todos[index] = updatedTask
                }
            }
        )
    }
}



struct EmptyTaskView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var isAddTaskSheetView: Bool
    var body: some View {
        VStack(spacing:0){
            VStack{
                Image("empty")
                    .resizable()
                    .frame(width: 300,height: 280)
                VStack(spacing:7) {
                    Text("What do you want to do today?")
                        .font(Font.custom("Lato-Regular", size: 16))
                    Button(action: {
                        withAnimation {
                            viewRouter.currentPage = .addTask
                        }
                    }, label: {
                        Text("Tap + to add your tasks")
                            .font(Font.custom("Lato-Regular", size: 16))
                    })
                }
            }.padding(.bottom,0)
        }
    }
}


struct UpdateRequreView:View{
    var title:String
    var message:String
    var btnTitle:String
    var imageName:String
    var action:()->Void
    var body:some View{
        HStack(alignment:.top,spacing:10){
            Image(systemName: imageName).font(Font.custom("Lato-Bold", size: 19)).foregroundColor(.indigo)
            VStack(alignment:.leading,spacing: 10){
                Text(title) .font(Font.custom("Lato-Bold", size: 16))
                Text(message) .font(Font.custom("Lato-Regular", size: 14))
            }
            Spacer()
            Button(action: {
                action()
            }, label: {
                Text(btnTitle).font(Font.custom("Lato-Bold", size: 13))
            }).padding(.horizontal).padding(.vertical,5).background(.blue.opacity(0.2)).cornerRadius(10)
        }.padding().frame(maxWidth: .infinity,alignment: .leading).background(.ultraThinMaterial).cornerRadius(10).padding()
       
    }
}
