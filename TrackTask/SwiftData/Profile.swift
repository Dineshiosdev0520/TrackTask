//
//  Profile.swift
//  TrackTask
//
//  Created by Dinesh Dev on 10/12/24.
//

import Foundation
import SwiftUI
import SwiftData

//Testing

@Model
class Profile {
    @Attribute(.unique) var id: UUID = UUID()
    var username: String
    var password: String
    var number: String
    var email:String
    var image: String = "empty_avatar"

    init(username: String, password: String, number: String, email: String,image: String) {
        self.username = username
        self.password = password
        self.number = number
        self.email = email
        self.image = image
    }
}
