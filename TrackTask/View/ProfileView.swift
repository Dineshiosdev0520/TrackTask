//
//  ProfileView.swift
//  TrackTask
//
//  Created by Dinesh Dev on 08/12/24.
//

import SwiftUI

import SwiftUI
import SwiftData
struct ProfileView: View {
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var isUpdateProfile: Bool = false
    @State private var toast:CustomToast?
    @State private var profile:Profile?
    var body: some View {
        VStack(spacing:0){
            VStack{
                Text("Profile")
                Divider()
            }.frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            ScrollView(showsIndicators:false){
                VStack(spacing:10) {
                    Button(action: {
                        isUpdateProfile.toggle()
                    }, label: {
                        AvatarView(avatar: profileVM.profile.first?.image ?? "empty_avatar")
                    })
                    Text(profileVM.profile.first?.username ?? "User Name")
                        .font(Font.custom("Lato-Bold", size: 17))
                    Text(profileVM.profile.first?.number ?? "number")
                        .font(Font.custom("Lato-Regular", size: 15)).foregroundColor(profileVM.profile.isEmpty ? .gray.opacity(0.7) : .white.opacity(0.7))
                }.foregroundColor(profileVM.profile.isEmpty ? .gray.opacity(0.7) : .white)
                .padding(.top)
                HStack(spacing:10){
                    TasksCountView(count: "Active (\(viewModel.todos.filter{ $0.status == .active } .count))")
                        .frame(maxWidth: .infinity)
                        .background()
                        .commonStyle()
                    TasksCountView(count: "Pending (\(viewModel.todos.filter{ $0.status == .pending } .count))")
                        .frame(maxWidth: .infinity)
                        .background()
                        .commonStyle()
                }.font(Font.custom("Lato-Bold", size: 15))
                    .padding()
                
                VStack(alignment:.leading,spacing: 0) {
                    Text("Settings")
                        .font(Font.custom("Lato-Bold", size: 15))
                        .padding(.leading)
                    ProfileRedirectView(image: "gearshape", title: "App Settings")
                        .foregroundColor(Color.white)
                        .padding(.vertical)
                        .background()
                        .commonStyle()
                        .padding()
                }.frame(maxWidth: .infinity)
                
                VStack(alignment:.leading,spacing: 0) {
                    Text("Account")
                        .font(Font.custom("Lato-Bold", size: 15))
                        .padding(.leading)
                    VStack {
                        ProfileRedirectView(image: "gearshape", title: "Change Account Name")
                        ProfileRedirectView(image: "key.viewfinder", title: "Change Account Paasword")
                        ProfileRedirectView(image: "photo.badge.plus", title: "Change Account Image")
                    } .padding(.vertical)
                        .foregroundColor(.white)
                        .background()
                        .commonStyle()
                        .padding()
                }.frame(maxWidth: .infinity)
                
                
                VStack(alignment:.leading,spacing: 0) {
                    Text("Uptodo")
                        .font(Font.custom("Lato-Bold", size: 15))
                        .padding(.leading)
                    VStack {
                        ProfileRedirectView(image: "square.grid.2x2.fill", title: "About us")
                        ProfileRedirectView(image: "exclamationmark.circle", title: "FAQ's")
                        ProfileRedirectView(image: "bolt", title: "Help and feddback")
                        ProfileRedirectView(image: "hand.thumbsup", title: "Support us")
                        ProfileRedirectView(image: "rectangle.portrait.and.arrow.right", title: "Logout")
                            .foregroundColor(.red)
                    }.padding(.vertical)
                        .foregroundColor(Color.white)
                        .background()
                        .commonStyle()
                        .padding()
                }.frame(maxWidth: .infinity)
            }.toastView(toast: $toast)
            .onAppear{
                profileVM.fetchProfiles()
                if let new_profile = profileVM.profile.first {
                    profile = new_profile
                }
            }
        }.sheet(isPresented: $isUpdateProfile, content: {
            AddProfileView(isUpdateProfile: $isUpdateProfile, profile: $profile,toast:$toast)
        })
    }
}

#Preview {
    ProfileView()
}

struct TasksCountView: View {
    var count:String
    var body: some View {
        VStack {
            Text(count)
                .padding()
        }
    }
}

struct ProfileRedirectView: View {
    var image:String
    var title:String
    var body: some View {
        Button(action: {
            
        }, label: {
            HStack(spacing:10){
                Image(systemName: image)
                Text(title)
                    .font(Font.custom("Lato", size: 15))
                Spacer()
                Image(systemName: "chevron.forward")
            }.padding(.horizontal)
                .padding(.vertical,8)
                
        })
       
    }
}
