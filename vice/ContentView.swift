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
    @State private var openHabit: Habit? = nil
    @StateObject private var router: Router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                ForEach(allHabits, id: \.id) { habit in
                    Button {
                        openHabit = habit
                    } label: {
                        HabitCardView(habit: habit)
                    }
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
                HabitView()
            }
            .sheet(item: $openHabit) { habit in
                HabitView(originalHabit: habit)
            }
            .task {
                NotificationManager.instance.requestAuthorization()
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .motivation(let url):
                    MotivationView(videoURL: url)
                        .navigationBarBackButtonHidden()
                }
            }
        }
        .environmentObject(router)
    }

    func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = allHabits[index]
            item.reminders.forEach { r in
                NotificationManager.instance.deleteNotification(id: r.id)
            }
            modelContext.delete(item)
            try? modelContext.save()
        }
    }
}

// #Preview {
//     ContentView()
// }
