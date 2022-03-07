//
//  PaymentView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/28/22.
//

import SwiftUI

struct PaymentView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: PaymentVM
    
    init(viewModel: PaymentVM) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            HStack{
                Button{
                    dismiss()
                } label: {
                    Label("Close", systemImage: "xmark")
                }
                Spacer()
            }
            .padding()
            if viewModel.showLoading {
                ProgressView("loading..")
            }
            Webview(showLoading: $viewModel.showLoading,
                    isPaymentSuccessful: viewModel.isPaymentSuccessful,
                    shouldDismiss: viewModel.shouldDismiss,
                    url: viewModel.url)
        }

    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(viewModel: .init(url: "https://serene-sinoussi-adb657.netlify.app/pystk_funded.html?email=yg@gm.com&amount=2000", isPaymentSuccessful: .constant(false), shouldDismiss: .constant(false)))
        
    }
}
