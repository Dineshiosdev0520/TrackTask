//
//  ProfileViewModel.swift
//  TrackTask
//
//  Created by Dinesh Dev on 10/12/24.
//

import Foundation
import SwiftUI
import SwiftData
class ProfileViewModel: ObservableObject {
    
    @Published var username:String = ""
    @Published var number:String = ""
    @Published var email:String = ""
    @Published var password:String = ""
    @Published var reEnterPassword:String = ""
    @Published var image:String = "empty_avatar"
    @Published var isValidated: [String: CustomToastModel] = [:]
    @Published var errorMessage: String?
    
    @Published var profile: [Profile] = []
    @Published var isProfileAddedSuccessfully: Bool = false

    var context: ModelContext?
    
    func fetchProfiles() {
        guard let context = context else { return }
        do {
            profile = try context.fetch(FetchDescriptor<Profile>())
        } catch {
            print("Error fetching todos: \(error.localizedDescription)")
        }
    }
    
    func validateFields() -> Bool {
        var isValid = true
        isValidated = [:]
        if username.isEmpty  {
            errorMessage = "Please Enter User Name."
            isValid = false
        }else if number.isEmpty {
            errorMessage = "Please Enter Phone Number."
            isValid = false
        }else if email.isEmpty {
            errorMessage = "Please Enter Email."
            isValid = false
        }else if password.isEmpty {
            errorMessage = "Please Enter Strong Password."
            isValid = false
        } else if reEnterPassword == "" {
            errorMessage = "Please Enter Re-Enter Password."
            isValid = false
        }else if password != reEnterPassword {
            errorMessage = "Password and Re-Enter Password does not match."
            isValid = false
        }
        return isValid
    }
    
    func getFirstValidationError() -> CustomToastModel? {
        return isValidated.values.first { !$0.isValid }
    }

    // Add a new Profile
    func addProfile(action:@escaping () -> Void) {
        guard let context = context else { return }
        let newTask = Profile(username: username, password: password, number: number,email: email, image: image)
        context.insert(newTask) // Insert the new profile into the context
        saveContext(){
            action()
        }
    }

    // Update an existing Profile
    func updateProfile(profile:Profile,action:@escaping () -> Void) {
        profile.username = username
        profile.password = password
        profile.number = number
        profile.email = email
        profile.image = image
        saveContext(){
            action()
        }
    }

    // Delete a Profile
    func deleteProfile(profile: Profile,action:@escaping () -> Void) {
        guard let context = context else { return }
        context.delete(profile) // Delete the profile from the context
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
            fetchProfiles() // Refresh the todos list
            self.reset()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
    func reset() {
        username = ""
        password = ""
        reEnterPassword = ""
        number = ""
        email = ""
        image = "empty_avatar"
    }
}
