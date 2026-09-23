//
//  HabitCardView.swift
//  vice
//
//  Created by Abhinav Mara on 9/23/26.
//

import SwiftUI

struct HabitCardView: View {
    var habit: String
    var habitId: UUID
    
    var body: some View {
        Button {
            print("tapped \(habit): \(habitId)")
        } label: {
            Text("cigarettes")
                .foregroundStyle(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.black)
                )
        }
        .padding(1)
    }
}

//#Preview {
//    HabitCardView()
//}
