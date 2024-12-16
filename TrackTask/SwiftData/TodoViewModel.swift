//
//  TodoViewModel.swift
//  TrackTask
//
//  Created by Dinesh Dev on 08/12/24.
//

import Foundation
import SwiftData
import SwiftUICore

class TodoViewModel: ObservableObject {
    
    @Published var taskName:String = ""
    @Published var taskDesc:String = ""
    @Published var taskFamily:String = ""
    @Published var date:Date = Date()
    @Published var taskStatus:TaskStatus = .active
    @Published var priority:Priority = .normal
    @Published var isValidated: [String: CustomToastModel] = [:]
    @Published var errorMessage: String?
    
    @Published var todos: [Todo] = []
    @Published var isTaskAddedSuccessfully: Bool = false

    var context: ModelContext?
    
    func fetchTodos() {
        guard let context = context else { return }
        do {
            todos = try context.fetch(FetchDescriptor<Todo>())
            print(todos)
        } catch {
            print("Error fetching todos: \(error.localizedDescription)")
        }
    }
    
    func validateFields() -> Bool {
        var isValid = true
        isValidated = [:]
        if taskName.isEmpty  {
            errorMessage = "Please Enter Task Title"
            isValid = false
        } else if taskDesc.isEmpty {
            errorMessage = "Please Enter Task Description"
            isValid = false
        } else if taskFamily == "" {
            errorMessage = "Please Enter Task Family like Gym, Work, Travel, ect."
            isValid = false
        }
        return isValid
    }
    
    func getFirstValidationError() -> CustomToastModel? {
        return isValidated.values.first { !$0.isValid }
    }

    // Add a new task
    func addTask(action:@escaping () -> Void) {
        guard let context = context else { return }
        let newTask = Todo(task: taskName, desc: taskDesc, priority: priority,family: taskFamily, date:date, status: taskStatus)
        print("Before Insert")
        context.insert(newTask) // Insert the new task into the context
        print("After Insert")
        saveContext(){
            action()
        }
    }

    // Update an existing task
    func updateTask(todo:Todo,action:@escaping () -> Void) {
        todo.task = taskName
        todo.desc = taskDesc
        todo.priority = priority
        todo.family = taskFamily
        todo.status = taskStatus
        todo.lastUpdated = date
        saveContext(){
            action()
        }
    }

    // Delete a task
    func deleteTask(todo: Todo,action:@escaping () -> Void) {
        guard let context = context else { return }
        context.delete(todo) // Delete the task from the context
        saveContext(){
            action()
        }
    }

    // Save the changes to the database
    private func saveContext(action:@escaping () -> Void) {
        guard let context = context else { return }
        do {
            try context.save()
            action()
            fetchTodos() // Refresh the todos list
            self.reset()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
    func reset() {
        taskName = ""
        taskDesc = ""
        priority = .normal
        taskFamily = ""
        taskStatus = .active
        date = Date()
    }
}
