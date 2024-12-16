//
//  CustomToastModifier.swift
//  DailyTask
//
//  Created by Dinesh Dev on 19/07/24.
//

import Foundation
import SwiftUI

struct CustomToastModifier: ViewModifier {
    @Binding var toast: CustomToast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: -30)
                }
                    .animation(.spring(), value: toast)
            )
            .onChange(of: toast) { value in
                showToast()
            }
    }
    
    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                Spacer()
                CustomToastView(
                    type: toast.type,
                    title: toast.title,
                    message: toast.message)
                .padding(.bottom,20)
            }
            .transition(.move(edge: .bottom))
        }
    }
    
    private func showToast() {
        guard let toast = toast else { return }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        
        workItem?.cancel()
        workItem = nil
    }
}
