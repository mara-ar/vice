//
//  ContentView.swift
//  vice
//
//  Created by Abhinav Mara on 9/22/26.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Query() var allHabits: [Habit]
    @State private var presentCreateHabitSheet: Bool = false

    var body: some View {
        ScrollView(.vertical) {
            ForEach(allHabits, id: \.id) { habit in
                HabitCardView(habit: habit)
            }
        }
        .padding()
        .overlay(alignment: .bottomTrailing) {
            Button {
                print("create new habit")
                presentCreateHabitSheet = true
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16)
                    .foregroundStyle(.black)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.white)
                            .shadow(radius: 3)
                    )
            }
            .padding()
        }
        .sheet(isPresented: $presentCreateHabitSheet) {
            CreateHabitView(isPresenting: $presentCreateHabitSheet)
        }
    }
}

#Preview {
    ContentView()
}
