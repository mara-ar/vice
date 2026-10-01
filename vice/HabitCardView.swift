//
//  HabitCardView.swift
//  vice
//
//  Created by Abhinav Mara on 9/23/26.
//

import SwiftUI

struct HabitCardView: View {
    @EnvironmentObject private var router: Router
    var habit: Habit

    var body: some View {
        HStack {
            Text(habit.habit)
                .foregroundStyle(.black)
                .padding(1)
            Spacer()
            Button {
                router.path.append(.motivation(url: habit.motivation))
                print(router.path)
            } label: {
                Image(systemName: "chevron.right")
            }
            .foregroundStyle(.gray)
        }
    }
}

//#Preview {
//    HabitCardView()
//}
