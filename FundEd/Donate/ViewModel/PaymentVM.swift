//
//  PaymentViewModel.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/28/22.
//

import Combine
import SwiftUI

class PaymentVM: ObservableObject {
    @Published var showLoading = true
    var isPaymentSuccessful: Binding<Bool>
    var shouldDismiss: Binding<Bool>
    @Published var url: String = ""//"https://serene-sinoussi-adb657.netlify.app/pystk_funded.html?email=yg@gm.com&amount=2000"
    
    
    init(url: String, isPaymentSuccessful: Binding<Bool>, shouldDismiss: Binding<Bool>) {
        self.url = url
        self.isPaymentSuccessful = isPaymentSuccessful
        self.shouldDismiss = shouldDismiss
    }
}
