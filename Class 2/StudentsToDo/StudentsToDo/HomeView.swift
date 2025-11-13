//
//  HomeView.swift
//  ToDo App
//
//  Created by SDGKU on 11/11/25.
//

import SwiftUI

struct HomeView: View {
    
    // TODO: STEP 1 - Create the Data Source
    // Create an array named 'profiles' containing 3 ProfileCategory items:
    // 1. School (Image: "SchoolCover", Key: "school_data")
    // 2. Work (Image: "WorkCover", Key: "work_data")
    // 3. Personal (Image: "PersonalCover", Key: "personal_data")
    private let profiles = [
        // Add here your properties
        // 1. School (name: "School", Image: "SchoolCover", Key: "school_data")
        // 2. Work (name: "Workk", Image: "WorkCover", Key: "work_data")
        // 3. Personal (name: "Personal", Image: "PersonalCover", Key: "personal_data")
        ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    welcomeHeader
                    profileGrid
                }
            }
            .navigationTitle("Home")
            .navigationBarHidden(true)
        }
    }
        
    private var welcomeHeader: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.crop.circle.badge.checkmark")
                .font(.system(size: 80))
                .foregroundStyle(.cyan)
            
            Text("Welcome Back")
                .font(.largeTitle.bold())
            
            Text("Select a workspace to begin")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 50)
    }
    private var profileGrid: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(profiles) { profile in
                // This grid automatically uses the 'profiles' array you created above.
                // If you see errors here, it means Step 2 is not finished yet.
                NavigationLink(destination: ContentView(storageKey: profile.storageKey, profileTitle: profile.name)) {
                    ProfileCard(profile: profile)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 80) 
    }
}

struct ProfileCard: View {
    // This accepts the data model your created in TaslModels file
    let profile: ProfileCategory
    
    var body: some View {
        VStack {
            // TODO: STEP 3 - Build the Card UI
            // 1. Use a VStack.
            // 2. Add the Image (profile.imageName) with .resizable(), .aspectRatio(.fill), etc.
            // 3. Add an HStack with Text(profile.name) and a Spacer.
            
            Image(systemName: "chevron.right.circle.fill")
                .font(.title2)
                .foregroundStyle(.cyan)
        }
        
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
    }
    .clipShape(RoundedRectangle(cornerRadius: 15))
    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    .overlay(
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color.white.opacity(0.5), lineWidth: 1)
    )
}
