//
//  AddTaskSheetView.swift
//  TrackTask
//
//  Created by Dinesh Dev on 08/12/24.
//

import SwiftUI

struct AddTaskSheetView: View {
    @EnvironmentObject var profileVM:ProfileViewModel
    @EnvironmentObject var viewModel:TodoViewModel
    @Binding var taskData:Todo?
    @Binding var isAddTaskSheet:Bool
    @Binding var isTabbar:Bool
    @Binding var toast:CustomToast?
    var body: some View {
        VStack(spacing:0){
            HStack{
                if !isTabbar{
                    Button(action: { isAddTaskSheet.toggle() }, label: {
                        Text("Cancel").foregroundColor(.blue).frame(width: 60)
                    })
                }
                Text(!isTabbar ? "Update Event" : "Add New Event").font(Font.custom("Lato-Bold", size: 16)).frame(maxWidth: .infinity,alignment: !isTabbar ? .center : .leading)
                Button(action: {
                    
                    if viewModel.validateFields(){
                        if profileVM.profile.isEmpty{
                            toast = CustomToast(type: .info, title: "Attention.", message: "Task cannot be added without profile.")
                        }else{
                            withAnimation{
                                if let todo = taskData{
                                    viewModel.updateTask(todo: todo){
                                        toast = CustomToast(type: .success, title: "Updated Successfully.", message: "Successfully updated \(todo.task) task.")
                                    }
                                    isAddTaskSheet = false
                                }else{
                                    viewModel.addTask(){
                                        toast = CustomToast(type: .success, title: "Success.", message: "Successfully added new task.")
                                    }
                                }
                            }
                        }
                    }else{
                        toast = CustomToast(type: .error, title: "Failed to add task.", message: viewModel.errorMessage ?? "Please enter all required fields")
                    }}, label: {
                        Text(!isTabbar ? "Update" : "Add").foregroundColor(.blue).frame(width: 60)
                    })
            }.padding()
            Divider()
            ScrollView(showsIndicators:false){
                VStack(spacing:15){
                    CustomTextField(text: $viewModel.taskName, placeHolder: "Task Name")
                    CustomTextField(text: $viewModel.taskDesc, placeHolder: "Task Description")
                    
                    HStack(alignment:.bottom, spacing:15){
                        CustomTextField(text: $viewModel.taskFamily, placeHolder: "Family like home, work,gym etc")
                        Menu(){
                            ForEach(Priority.allCases,id: \.rawValue){ priority_value in
                                Button(action: { viewModel.priority = priority_value  }, label: {
                                    HStack{
                                        Text(priority_value.rawValue)
                                        if viewModel.priority == priority_value { Image(systemName: "checkmark") }
                                    }
                                })
                            }
                        }label: {
                            HStack{
                                Text(viewModel.priority.rawValue)
                                Image(systemName: "chevron.up.chevron.down")
                            }.padding()
                                .padding(.horizontal,5)
                                .font(Font.custom("Lato", size: 14))
                                .foregroundColor(.white)
                                .background(viewModel.priority.color)
                                .cornerRadius(10)
                        }
                    }
                    
                    HStack {
                        DatePicker(selection: $viewModel.date, in:Date()...Date().addingTimeInterval(60 * 60 * 24 * 365)) {}.font(Font.custom("Lato-SemiBold", size: 13)) .datePickerStyle(GraphicalDatePickerStyle()).padding(10)
                    }.commonStyle()
                }.padding()
            }
        }
        .onAppear{
            profileVM.fetchProfiles()
            viewModel.date = taskData?.lastUpdated ?? Date()
            viewModel.taskName = taskData?.task ?? ""
            viewModel.taskDesc = taskData?.desc ?? ""
            viewModel.priority = taskData?.priority ?? .normal
            viewModel.taskFamily = taskData?.family ?? ""
            
        }
    }
}


struct CustomTextField: View {
    @Binding var text:String
    var placeHolder:String
    
    var body: some View {
        VStack(alignment:.leading){
            Text(placeHolder.uppercased())
                .foregroundColor(.gray)
                .font(Font.custom("Lato-Regular", size: 13))
            TextField(placeHolder, text: $text)
                .padding()
                .font(Font.custom("Lato-Regular", size: 16))
                .background(.ultraThinMaterial)
                .commonStyle(radius: 12)
        }
            
    }
}
