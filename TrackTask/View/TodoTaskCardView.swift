//
//  TodoTaskCardView.swift
//  TrackTask
//
//  Created by Dinesh Dev on 08/12/24.
//

import SwiftUI

struct TodoTaskCardView: View {
    @EnvironmentObject var viewModel: TodoViewModel
    @FocusState private var isActive: Bool
    @State var isEditableTask:Bool = false
    @State var isTabbar:Bool = false
    @State private var isDeleteTask:Bool = false
    @Binding var toast:CustomToast?
    @Binding var taskData:Todo?
    
    var body: some View {
        HStack(alignment: .top) {
            Button(action: {
                withAnimation(.snappy){
                    taskData?.status = (taskData?.status == .completed) ? .pending : .completed
                }
            }, label: {
                Image(systemName: taskData?.status == .completed ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18))
                    .padding(.horizontal, 3)
                    .foregroundColor(taskData?.status == .completed ? .green : .accentColor)
                    .contentTransition(.symbolEffect(.replace))
            }) .buttonStyle(PlainButtonStyle())
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment:.top) {
                    Text(taskData?.task ?? "")
                        .font(Font.custom("Lato-Bold", size: 15))
                        .strikethrough(taskData?.status == .completed)
                        .foregroundColor(taskData?.status == .completed ? .gray : .primary)
                        .focused($isActive)
                    if taskData?.status != .completed && taskData?.lastUpdated ?? Date() < Date.now{
                        Image(systemName: "exclamationmark.circle.fill") .font(Font.custom("Lato", size: 14))
                            .foregroundColor(.orange)
                    }
                    Spacer()
                    
                    Menu{
                        ForEach(Priority.allCases,id: \.rawValue){ priority in
                            Button(action: { taskData?.priority = priority }, label: {
                                HStack{
                                    Text(priority.rawValue)
                                    if taskData?.priority == priority { Image(systemName: "checkmark") }
                                }
                            })
                        }
                    }label: {
                        HStack{
                            Text(taskData?.priority.rawValue ?? "")
                            Image(systemName: "chevron.up.chevron.down")
                        }.padding(4)
                            .padding(.horizontal,10)
                            .font(Font.custom("Lato", size: 14))
                            .foregroundColor(taskData?.priority.color)
                            .background(taskData?.priority.color.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                
                HStack{
                    Text(taskData?.desc ?? "")
                        .font(Font.custom("Lato-Regular", size: 15))
                        .strikethrough(taskData?.status == .completed)
                    Spacer()
                    Text(displaySelectedDateAndTime(taskDate: taskData?.lastUpdated ?? Date()))
                        .font(Font.custom("Lato", size: 14))
                }.foregroundColor(.gray)
                
                HStack{
                    HStack{
                        Image(systemName: "flag")
                        Text(taskData?.family ?? "")
                    }.padding(4)
                        .padding(.horizontal,10)
                        .font(Font.custom("Lato", size: 14))
                        .foregroundColor(.indigo)
                        .background(.indigo.opacity(0.2))
                        .cornerRadius(10)
                   
                    Spacer()
                    
                    Button(action: {
                        isEditableTask = true
                    }, label: {
                        Image(systemName: "pencil.and.list.clipboard")
                            .font(Font.custom("Lato", size: 18))
                            .foregroundColor(.indigo)
                    })
                    
                    Button(action: {
                        isDeleteTask.toggle()

                    }, label: {
                        HStack{
                            Image(systemName:"trash").foregroundColor(.red).font(Font.custom("Lato", size: 18))
                            
                        }
                    })
                    
                }
                
            }
            .font(Font.custom("Lato-Regular", size: 14))
        }
        .padding()
        .background(.ultraThinMaterial)
        .commonStyle(radius: 10)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .animation(.snappy,value: isActive)
        .onAppear{
            isActive = taskData?.status == .completed
            if taskData?.status != .completed && taskData?.lastUpdated ?? Date() < Date.now{
                taskData?.status = .pending
            }
        }
        .sheet(isPresented: $isEditableTask, content: {
            AddTaskSheetView(taskData: $taskData, isAddTaskSheet: $isEditableTask, isTabbar: $isTabbar, toast: $toast)
        })
        
        .alert("Delete", isPresented: $isDeleteTask) {
            Button("Confirm", role: .destructive) {
                if let todo = taskData{
                    withAnimation{
                        viewModel.deleteTask(todo:  todo){
                            toast = CustomToast(type: .success, title: "Successfully deleted.", message: "Given task has been deleted successfully.")
                        }
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this task.")
        }
    }
}




