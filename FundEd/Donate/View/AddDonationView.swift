//
//  AddDonationView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/27/22.
//

import SwiftUI

struct AddDonationView: View {
    var body: some View {
        Form {
            Section {
                Text("Classroom Project")
                    .font(.headline)
                
                Text("Amount Remaining: N2000.00")
                
                TextField("Amount:", text: .constant("400"))
                    .keyboardType(.numberPad)
                    
                TextField("Comment:", text: .constant("comment here"))
            }
        }
        .toolbar {
            ToolbarItemGroup {
                Button("Continue"){
                    print("continue") // Paystack stuff - webview?
                }
            }
        }
    }
}

struct AddDonationView_Previews: PreviewProvider {
    static var previews: some View {
        AddDonationView()
    }
}
