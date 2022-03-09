//
//  AddDonationView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/27/22.
//

import SwiftUI

struct AddDonationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: AddDonationVM
    
    init(viewModel: AddDonationVM) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        Form {
            Section {
                Text(viewModel.project.title)
                    .font(.headline)
                
                HStack {
                    Text("Amount Remaining:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(viewModel.amountLeft, specifier: "%.2f")")
                }
                
                HStack {
                    Text("Your Donation (N):")
                        .fontWeight(.bold)
                    Spacer()
                    TextField("Your Donation (N):", text: $viewModel.amount)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                
                Section{
                    Text("Any comments or feedback?")
                        .fontWeight(.bold)
                    TextEditor(text: $viewModel.comment)
                        .frame(height: 200)
                }
                
            }
            .alert(isPresented: $viewModel.isDonationSuccessful) {
                Alert(title: Text("You made a successful donation!"), dismissButton: .default(Text("OK"), action: {
                    dismiss()
                }))
            }
            .fullScreenCover(isPresented: $viewModel.proceedToPayment, onDismiss: {
            }, content: {
                PaymentView(viewModel: .init(url: viewModel.paymentUrl,
                                             isPaymentSuccessful: $viewModel.isPaymentSuccessful,
                                             shouldDismiss: !$viewModel.proceedToPayment))
            })
            .onChange(of: viewModel.amount, perform: { newAmount in
                print(viewModel.paymentUrl)
            })
            .onChange(of: viewModel.isPaymentSuccessful) { success in
                if success {
                    print("Payment Successful... Save donation")
                    viewModel.donate()
                }
            }
        }
        .toolbar {
            ToolbarItemGroup {
                Button("Continue"){
                    viewModel.proceedToPayment.toggle()
                }
                .disabled(!viewModel.isValidDonation())
            }
        }
            
        
    }
}

struct AddDonationView_Previews: PreviewProvider {
    static var previews: some View {
        AddDonationView(viewModel: AddDonationVM(project: Project.sample, amountLeft: 100.0))
    }
}
