//
//  ViewRouter.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import Foundation
import SwiftUI

class ViewRouter: ObservableObject {
    @AppStorage("IS_NEW_USER") var isNewUser: Bool = true
    @Published var isLoggedIn: Bool = UserDefaults.standard.getUser() != nil
    @Published var currentTabIndex: Int = 0
}
