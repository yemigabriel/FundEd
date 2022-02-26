//
//  ViewRouter.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import Foundation
import SwiftUI

final class ViewRouter: ObservableObject {
    @AppStorage("IS_NEW_USER") var isNewUser: Bool = true
}
