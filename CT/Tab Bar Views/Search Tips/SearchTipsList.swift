//
//  SearchTipsList.swift
//  CT
//
//  Created by Yuxuan Li on 5/3/23.
//

import SwiftUI

struct SearchTipsList: View {
    var body: some View {
        List {
            ForEach(databaseSearchResults) { aTip in
                NavigationLink(destination: SearchTipsDetails(tip: aTip)) {
                    SearchTipsItem(tip: aTip)
                }
            }
        }
        .navigationBarTitle(Text("Datebase Search Results"), displayMode: .inline)
    }
}

struct SearchTipsList_Previews: PreviewProvider {
    static var previews: some View {
        SearchTipsList()
    }
}
