//
//  Prospect.swift
//  HotProspects
//
//  Created by Peter Hartnett on 5/3/22.
//

import SwiftUI

class Prospect: Identifiable, Codable{
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published var people: [Prospect]

    init() {
        self.people = []
    }
}
