//
//  ContentView.swift
//  ProfessorToDo
//
//  Created by SDGKU on 10/11/25.
//

import SwiftUI

struct ContentView: View {
    
    var storageKey: String
    var profileTitle: LocalizedStringKey
    
    @State private var selection: SidebarSelection? = nil
    @State private var taskGroups: [TaskGroup] = []
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var isManagingGroups = false
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("profileName") private var profileName = "Default Profile"
    
    private var appAccentColor = Color.cyan
    
    init(storageKey: String, profileTitle: LocalizedStringKey) {
        self.storageKey = storageKey
        self.profileTitle = profileTitle
    }
    var body: some View {
        
        NavigationSplitView(columnVisibility: $columnVisibility) {
            
            List(selection: $selection) {
                Section {
                    ForEach(taskGroups) { group in
                        NavigationLink(value: SidebarSelection.group(group.id)) {
                            Label(group.title, systemImage: group.symbolName)
                                .padding(.vertical, 4)
                        }
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                deleteGroup(group)
                            }
                        }
                    }
                } header: {
                    Text(profileTitle)
                        .font(.headline)
                        .foregroundStyle(appAccentColor)
                }

                
                Section("Account") {
                    NavigationLink(value: SidebarSelection.profile) {
                        Label(profileName, systemImage: "person.crop.circle")
                            .padding(.vertical, 4)
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("My TODO Tracker")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isManagingGroups = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(appAccentColor)
                            .padding(6)
                            .background(appAccentColor.opacity(0.15))
                            .clipShape(Circle())
                    }
                }
            }
            
        } detail: {
            
            switch selection {
                
            case .group(let groupID):
                if let index = taskGroups.firstIndex(where: { $0.id == groupID }) {
                    TaskGroupDetailView(group: $taskGroups[index], appAccentColor: appAccentColor)
                } else {
                    ContentUnavailableView(
                        "Group Deleted",
                        systemImage: "nosign",
                        description: Text("The selected group no longer exists. Please select another one."))
                    .foregroundStyle(.secondary)
                }
                
            case .profile:
                ProfileView(appAccentColor: appAccentColor)
                
            case nil:
                ContentUnavailableView(
                    "Welcome",
                    systemImage:"checklist.unchecked",
                    description: Text("subtitle_groups"))
                .foregroundStyle(.secondary)
            }
        }
        .sheet(isPresented: $isManagingGroups) {
            ManageGroupsView(groups: $taskGroups, appAccentColor: appAccentColor)
        }
        .tint(appAccentColor)
        .onAppear {
            loadTaskGroups()
        }
        //added
        .onChange(of: taskGroups) { _, _ in
            saveTasksGroups()
        }
        .onChange(of: scenePhase) {oldPhase, newPhase in
            if newPhase == .background {
                saveTasksGroups()
            }
            
        }
    }
    
    private func deleteGroup(_ group: TaskGroup) {
        if selection == .group(group.id) {
            selection = nil
        }
        taskGroups.removeAll { $0.id == group.id }
    }
    
    private func loadTaskGroups() {
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            if let decodedGroups = try? JSONDecoder().decode([TaskGroup].self, from: data) {
                self.taskGroups = decodedGroups
                print("Successfully loaded task groups")
                
                if selection == nil, let firstGroup = taskGroups.first {
                    selection = .group(firstGroup.id)
                }
                return
            }
        }
        print("No saved data found")
        self.taskGroups = []
    }
    
    private func saveTasksGroups() {
        if let encodedData = try? JSONEncoder().encode(taskGroups) {
            UserDefaults.standard.set(encodedData, forKey: storageKey)
            print("Succesfully saved task groups for \(storageKey)")
            
        } else {
            print("Failed to save groups")
        }
    }
}
