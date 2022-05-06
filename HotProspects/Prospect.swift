//
//  Prospect.swift
//  HotProspects
//
//  Created by Peter Hartnett on 5/3/22.
//

import SwiftUI

class Prospect: Identifiable, Codable, Comparable{
    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.name < rhs.name
    }
    
    
    
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    
    let saveKey = "SavedData"
    
    private func save() {
        FileManager.default.encode(people, toFile: saveKey)
//        if let encoded = try? JSONEncoder().encode(people) {
//
//
//            UserDefaults.standard.set(encoded, forKey: saveKey)
//        }
    }
    
    init() {
        if let decoded: [Prospect] = FileManager.default.decode(saveKey){
            people = decoded
            return
        }
        
//        if let data = UserDefaults.standard.data(forKey: saveKey) {
//            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
//                people = decoded
//                return
//            }
//        }
        
        people = []
    }
}
