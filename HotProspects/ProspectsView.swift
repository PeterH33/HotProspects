//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Peter Hartnett on 5/3/22.
//

import SwiftUI

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { word in word.isContacted }
        case .uncontacted:
            return prospects.people.filter { word in !word.isContacted }
        }
    }
    
    
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                }
            }
                .navigationTitle(title)
                .toolbar {
                    Button {
                        let prospect = Prospect()
                        prospect.name = "Paul Hudson"
                        prospect.emailAddress = "paul@hackingwithswift.com"
                        prospects.people.append(prospect)
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
        }
        
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none).environmentObject(Prospects())
           
    }
}
    
