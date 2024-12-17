//
//  SplashScreenView.swift
//  TrackTask
//
//  Created by Dinesh Dev on 17/12/24.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var isOpenCustomTabbar:Bool = false
    var body: some View {
        VStack{
            Image("icon").resizable().aspectRatio(contentMode: .fit).frame(width: 100,height: 100)
            Text("TrackTask").font(Font.custom("Lato-Bold", size: 30))
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                isOpenCustomTabbar.toggle()
            }
        }
        .fullScreenCover(isPresented: $isOpenCustomTabbar, content: {
            ContentView().environmentObject(viewRouter)
        })
    }
}

#Preview {
    SplashScreenView()
}
