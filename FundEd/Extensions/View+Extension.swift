//
//  View+Extension.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import Foundation
import SwiftUI

extension View {
    func cardImageStyle(width: CGFloat, height: CGFloat = 200) -> some View {
        modifier(CardImage(width: width, height: height))
    }
}
