//
//  AvatarView.swift
//  TrackTask
//
//  Created by Dinesh Dev on 10/12/24.
//

import SwiftUI


struct AvatarView: View {
    let avatar: String
    @State var isSelected: Bool?
    
    var body: some View {
        Image(avatar)
            .resizable()
            .frame(width: 73, height: 68)
            .clipShape(Circle())
            .overlay(Circle().stroke(isSelected ?? true ? Color.indigo : Color.clear, lineWidth: 4))
            .shadow(color:.gray.opacity(0.3), radius: isSelected ?? true ? 5 : 0)
    }
}


struct AvatarSelectionViewTest:View {
    @State private var avatar: String = "avatar_1"
    @State private var isSelectedAvatar:Bool = false
    var body: some View {
        AvatarSelectionView(selectedAvatar: $avatar,isSelectedAvatar: $isSelectedAvatar)
    }
}

struct AvatarSelectionView:View {
    @Binding var selectedAvatar: String
    @Binding var isSelectedAvatar: Bool
    @State private var showAlert:Bool = false
    let avatarImages = ["avatar_1", "avatar_2", "avatar_3", "avatar_4", "avatar_5","empty_avatar"]
    var body: some View {
        ScrollView{
            VStack(spacing:20){
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                    ForEach(avatarImages, id: \.self) { avatar in
                        AvatarView(avatar: avatar, isSelected: selectedAvatar == avatar)
                            .onTapGesture {
                                withAnimation{
                                    selectedAvatar = avatar
                                    isSelectedAvatar = false
                                }
                            }
                    }
                }
            }
            .padding()
        }.background()
    }
}

//Changes testing
struct AddProfileView:View {
    @EnvironmentObject var profileVM: ProfileViewModel
    @State var isAvatarPickerShown: Bool = false
    @State private var showAlert:Bool = false
    @Binding var isUpdateProfile: Bool
    @Binding var profile: Profile?
    
    @Binding var toast:CustomToast?
    var body: some View {
        ScrollView(showsIndicators:false){
            VStack(spacing:20){
                Rectangle().fill(.gray.opacity(0.5)).frame(width:100,height:5).cornerRadius(2.5)
                VStack(spacing:20){
                    Text("Update Profile").font(Font.custom("Lato-Bold", size: 18))
                    Divider()
                }
                
                Button(action: { withAnimation{ isAvatarPickerShown.toggle() }}, label: {
                    AvatarView(avatar: profileVM.image)
                })
                if isAvatarPickerShown{
                    AvatarSelectionView(selectedAvatar: $profileVM.image, isSelectedAvatar: $isAvatarPickerShown)
                }
                VStack(spacing:10){
                    TextField("Name", text: $profileVM.username).padding().commonStyle(radius:2)
                    TextField("Mobile Number", text: $profileVM.number).padding().commonStyle(radius:2).keyboardType(.numberPad)
                    TextField("Email", text: $profileVM.email).padding().commonStyle(radius:2).keyboardType(.emailAddress)
                    SecureField("Password", text: $profileVM.password).padding().commonStyle(radius:2)
                    SecureField("Re Enter Password", text: $profileVM.reEnterPassword).padding().commonStyle(radius:2)
                }
                HStack {
                    TaskAddCustomButtonView(buttonName: "Cancel", isCanceBtn: false,btnColor: .indigo) {
                        isUpdateProfile.toggle()
                    }
                    TaskAddCustomButtonView(buttonName: profile != nil ? "Update" : "Save", isCanceBtn: true,btnColor: .indigo) {
                        if profileVM.validateFields(){
                            if let profile = profile{
                                profileVM.updateProfile(profile: profile){
                                    isUpdateProfile.toggle()
                                    toast = CustomToast(type: .success, title: "Updated", message: "Profile Updated Successfully")
                                }
                            }else{
                                profileVM.addProfile(){
                                    isUpdateProfile.toggle()
                                    toast = CustomToast(type: .success, title: "Updated", message: "Profile Added Successfully")
                                }
                            }
                        }else{
                            toast = CustomToast(type: .error, title: "Failed", message: profileVM.errorMessage ?? "Please fill all required fields")
                        }
                    }
                }
                TaskAddCustomButtonView(buttonName: "Delete", isCanceBtn: false,btnColor: profile != nil ? .red : .gray) {
                    showAlert.toggle()
                }.disabled(profile == nil)
                Spacer()
            }.padding().toastView(toast: $toast)
                .onAppear{
                    profileVM.username = profile?.username ?? ""
                    profileVM.email = profile?.email ?? ""
                    profileVM.number = profile?.number ?? ""
                    profileVM.image = profile?.image ?? "empty_avatar"
                    profileVM.password = profile?.password ?? ""
                    profileVM.reEnterPassword = profile?.password ?? ""
                }
        }.alert("Delete? ", isPresented: $showAlert, actions: {
            Button("Delete", action: {
                if let new_profile = profile{
                    profileVM.deleteProfile(profile: new_profile){
                        isUpdateProfile.toggle()
                        toast = CustomToast(type: .info, title: "Deleted", message: "Profile Deleted Successfully")
                    }
                    
                }
            })
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text("Are you sure you want to delete current profile details?")
        })
    }
}

struct TaskAddCustomButtonView: View {
    var buttonName:String
    var isCanceBtn:Bool = false
    var width:CGFloat?
    var btnColor:Color?
    var action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(buttonName)
                .padding()
                .font(Font.custom("Lato-Bold", size: 18))
                .frame(maxWidth:.infinity)
                .foregroundColor(isCanceBtn ? .white : btnColor ?? .indigo)
        }).background(isCanceBtn ? .indigo : btnColor?.opacity(0.2) ?? .gray.opacity(0.3))
        .cornerRadius(8)
        
    }
}
