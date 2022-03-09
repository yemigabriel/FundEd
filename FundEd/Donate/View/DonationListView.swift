//
//  DonationListView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 3/9/22.
//

import SwiftUI

struct DonationListView: View {
    @StateObject private var viewModel: DonationListVM
    
    init(viewModel: DonationListVM) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            if viewModel.appState == .loading {
                ProgressView("Fetching donations...")
            }
            ForEach(viewModel.filteredDonations) { donation in
                DonationCardView(viewModel: .init(donation: donation))
            }
        }
        .searchable(text: $viewModel.searchFilter)
        .task {
            if viewModel.isAdmin {
                viewModel.getDonations()
                return
            }
            if viewModel.isUser {
                viewModel.getUserDonations()
                return
            }
        }
    }
}

struct DonationListView_Previews: PreviewProvider {
    static var previews: some View {
        DonationListView(viewModel: .init())
    }
}

