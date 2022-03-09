//
//  DonationCardView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 3/9/22.
//

import SwiftUI

struct DonationCardView: View {
    @StateObject private var viewModel = DonationCardVM(donation: .sample)
    
    init(viewModel: DonationCardVM) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("N\(viewModel.amount)")
                .fontWeight(.bold)
            Text(viewModel.projectTitle)
                .font(.headline)
            Text(viewModel.donorName)
            Text(viewModel.createdAt)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct DonationCardView_Previews: PreviewProvider {
    static var previews: some View {
        DonationCardView(viewModel: .init(donation: .sample))
    }
}
