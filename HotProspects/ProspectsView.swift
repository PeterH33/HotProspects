//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Peter Hartnett on 5/3/22.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    
    //*** QR code scanner section****
    @State private var isShowingScanner = false
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            
            prospects.add(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    //*** End QR code scanner stuff***
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        //very much like a func in a func
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            //  let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            //Using this 5 second trigger to testing purposes
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
    
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
    var sortedProspects: [Prospect] {
        switch sortingOrder{
        case .mostRecent:
            //code
            return filteredProspects
        case .name:
            //code
            return filteredProspects.sorted()
            
        }
    }
    
    @State private var isShowingSortOrderPicker = false
    @State private var sortingOrder: SortOrder = .mostRecent
    enum SortOrder {
        case name, mostRecent
    }
    
    
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(sortedProspects) { prospect in
                    HStack{
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        if filter == .none{
                         (prospect.isContacted) ? Image(systemName: "person.fill.checkmark") : Image(systemName: "person.fill.questionmark")
                        }
                        
                        
                    }//end HStack
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                                
                                
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }//end swipe actions
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                    Button{
                        isShowingSortOrderPicker = true
                    } label: {
                        Label("Change Sorting", systemImage: "arrow.up.arrow.down.square")
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
            .confirmationDialog("Sort order?", isPresented: $isShowingSortOrderPicker){
                Button("Date Added"){
                    sortingOrder = .mostRecent
                }
                Button("Name"){
                    sortingOrder = .name
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

