//
//  ContentView.swift
//  vice
//
//  Created by Abhinav Mara on 9/22/26.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query() var allHabits: [Habit]
    @State private var presentCreateHabitSheet: Bool = false

    var body: some View {
        List {
            ForEach(allHabits, id: \.id) { habit in
                HabitCardView(habit: habit)
            }
            .onDelete(perform: deleteItem)
        }
        .listStyle(.plain)
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
                    .foregroundStyle(.white)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.black)
                            .shadow(color: Color.black.opacity(0.5), radius: 12)
                    )
            }
            .padding()
        }
        .sheet(isPresented: $presentCreateHabitSheet) {
            CreateHabitView(isPresenting: $presentCreateHabitSheet)
        }
    }

    func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = allHabits[index]
            modelContext.delete(item)
        }
    }
}

#Preview {
    ContentView()
}
