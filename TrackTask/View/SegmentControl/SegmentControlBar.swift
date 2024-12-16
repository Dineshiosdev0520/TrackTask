//
//  SegmentControlBar.swift
//  TrackTask
//
//  Created by Dinesh Dev on 09/12/24.
//

import Foundation
import SwiftUI
struct SegmentControlItem {
    var name: String? = nil
    var iconString: String? = nil
    var color:Color? = nil
}

public struct SegmentControl: View{
    @Binding var selectedIndex: Int
    
    let options: [SegmentControlItem]
    var inactiveBarColor: Color = .gray.opacity(0.2)
    var imageColor: Color = .black
    var action:()->Void
    
    public var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 6.0)
                    .foregroundColor(.white)
                    .cornerRadius(6.0)
                    .padding(4)
                    .frame(width: geo.size.width / CGFloat(options.count))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
                    .offset(x: geo.size.width / CGFloat(options.count) * CGFloat(selectedIndex), y: 0)
            }
            .frame(height: 40)
            
            HStack(spacing: 0) {
                ForEach((0..<options.count), id: \.self) { index in
                    HStack(spacing: 6) {
                        if let iconString = options[index].iconString {
                            Image(systemName: iconString).foregroundColor(selectedIndex == index ? .black : .white.opacity(0.3))
                        }
                        if let name = options[index].name {
                            Text("\(name)")
                                .foregroundColor(selectedIndex == index ? .black : .white.opacity(0.3))
                        }
                    }
                    .font(Font.custom("Lato-Bold", size: 12))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(selectedIndex == index ? inactiveBarColor : inactiveBarColor)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.150)) {
                            selectedIndex = index
                            action()
                        }
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 9.0).stroke(.white.opacity(0.5),lineWidth: 1)
                .fill(inactiveBarColor)
        )
        .frame(height: 45).cornerRadius(9)
    }
}


enum TaskType: CaseIterable {
    case all
    case active
    case pending
    case completed
    
    // Computed property to map `TaskType` to `SegmentControlItem`
    var segmentItem: SegmentControlItem {
        switch self {
        case .all:
            return SegmentControlItem(name: "All", iconString: "chart.bar.xaxis.ascending", color: .black)
        case .active:
            return SegmentControlItem(name: "Active", iconString: "dot.radiowaves.left.and.right", color: .blue)
        case .pending:
            return SegmentControlItem(name: "Pending", iconString: "exclamationmark.circle.fill", color: .orange)
        case .completed:
            return SegmentControlItem(name: "Completed", iconString: "checkmark.circle.fill", color: .green)
        }
    }
}
