//
//  Binding+Extension.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/28/22.
//

import Foundation
import SwiftUI

//extension Binding {
prefix func !(_ lhs: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool> {
        !lhs.wrappedValue
    } set: {
        lhs.wrappedValue = !$0
    }
}

//}
