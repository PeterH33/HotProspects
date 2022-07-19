//
//  ContentView.swift
//  HotProspects
//
//  Created by Peter Hartnett on 4/28/22.
//

//Day 85 Challenges
//
//1) ☑️Add an icon to the “Everyone” screen showing whether a prospect was contacted or not.
//2) ☑️Use JSON and the documents directory for saving and loading our user data.
//3) ☑️Use a confirmation dialog to customize the way users are sorted in each tab – by name or by most recent.

//TODO: Highlight the parts of the code where the challenges exist.

import SwiftUI


struct ContentView: View {
    @StateObject var prospects = Prospects()
    
    var body: some View {
        TabView{
            ProspectsView(filter: .none)
                .tabItem{
                    Label("Everyone", systemImage: "person.3")
                }
            ProspectsView(filter: .contacted)
                .tabItem{
                    Label("Contacted", systemImage: "checkmark.circle")
                }
            ProspectsView(filter: .uncontacted)
                .tabItem{
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            MeView()
                .tabItem{
                    Label("Me", systemImage: "person")
                }
        }
        .environmentObject(prospects)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
