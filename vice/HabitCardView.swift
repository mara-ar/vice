//
//  HabitCardView.swift
//  vice
//
//  Created by Abhinav Mara on 9/23/26.
//

import SwiftUI

struct HabitCardView: View {
    var habit: Habit

    var body: some View {
        Text(habit.habit)
            .foregroundStyle(.black)
            .padding(1)
    }
}

//#Preview {
//    HabitCardView()
//}
