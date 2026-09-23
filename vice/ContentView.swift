//
//  ContentView.swift
//  vice
//
//  Created by Abhinav Mara on 9/22/26.
//

import SwiftUI

struct ContentView: View {
    @State private var presentCreateHabitSheet: Bool = false

    var body: some View {
        ScrollView(.vertical) {
            HabitCardView(habit: "cigarettes", habitId: UUID())
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
            CreateHabitView()
        }
    }
}

#Preview {
    ContentView()
}
