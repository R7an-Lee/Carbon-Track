//
//  DatabaseChange.swift
//  CT
//
//  Created by Osman Balci on 3/20/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import Combine
import SwiftUI

final class DatabaseChange: ObservableObject {

    /*
     The 'indicator' value will be toggled to indicate that the Core Data database
     has changed upon which all subscribing views shall refresh their views.
     */
    @Published var indicator = false
}
