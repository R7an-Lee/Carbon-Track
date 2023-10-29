//
//  SearchTips.swift
//  CT
//
//  Created by Yuxuan Li on 4/3/23.
//

import SwiftUI

struct SearchTips: View {
    
    // ✳️ Core Data managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var searchFieldValue = ""
    @State private var searchCompleted = false
    
    //---------------
    // Alert Messages
    //---------------
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    let searchCategories = ["Tip Title Contains", "Tip Content Contains"]
    @State private var selectedIndex = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                Form {
                    Section(header: Text("Select A Search Category")) {
                        Picker("", selection: $selectedIndex) {
                            ForEach(0 ..< searchCategories.count, id: \.self) {
                                Text(searchCategories[$0])
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    }
                    
                    Section(header: Text("Search Query under selected category"))
                    {
                        HStack {
                            TextField("Enter Search Query", text: $searchFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                            Button(action: {
                                searchFieldValue = ""
                                showAlertMessage = false
                                searchCompleted = false
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }   // End of HStack
                    }   //End of Section
                    
                    Section(header: Text("Search Database")) {
                        HStack {
                            Spacer()
                            Button(searchCompleted ? "Search Completed" : "Search") {
                                if inputDataValidated() {
                                    searchData()
                                    searchCompleted = true
                                } else {
                                    showAlertMessage = true
                                    alertTitle = "Missing Input Data!"
                                    alertMessage = "Please enter a database search query!"
                                }
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            Spacer()
                        }   // End of HStack
                    }
                    //when click search
                    if searchCompleted {
                        Section(header: Text("List Tips Found")) {
                            NavigationLink(destination: showSearchResults) {
                                HStack {
                                    Image(systemName: "list.bullet")
                                        .imageScale(.medium)
                                        .font(Font.title.weight(.regular))
                                    Text("List Tips Found")
                                        .font(.system(size: 16))
                                }
                                .foregroundColor(.blue)
                            }
                        }   //End of section
                        Section(header: Text("Clear")) {
                            HStack {
                                Spacer()
                                Button("Clear") {
                                    searchCompleted = false
                                    searchFieldValue = ""
                                }
                                .tint(.blue)
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                                
                                Spacer()
                            }
                        }   //End of Section
                        
                    }   //End of if
                }   //End of Form
                .navigationBarTitle(Text("Search Database"), displayMode: .inline)
                .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                      Button("OK") {}
                    }, message: {
                      Text(alertMessage)
                    })
                
            }   // End of ZStack
        }   // End of NavigationView
            .customNavigationViewStyle()  // Given in NavigationStyle
    }   // End of body var
    
    /*
     ---------------------
     MARK: Search Database
     ---------------------
     */
    func searchData() {
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        searchCategory = searchCategories[selectedIndex]
        searchQuery = queryTrimmed
        // Public function conductDatabaseSearch is given in DatabaseSearch.swift
        conductDatabaseSearch()
    }
    
    /*
     -------------------------
     MARK: Show Search Results
     -------------------------
     */
    var showSearchResults: some View {
        // Global array databaseSearchResults is given in DatabaseSearch.swift
        if databaseSearchResults.isEmpty {
            return AnyView(
                NotFound(message: "Database Search Produced No Results!\n\nThe database did not return any value for the given search query!")
            )
        }
        return AnyView(SearchTipsList())
    }
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if queryTrimmed.isEmpty {
            return false
        }
        return true
    }
}



struct SearchTips_Previews: PreviewProvider {
    static var previews: some View {
        SearchTips()
    }
}
