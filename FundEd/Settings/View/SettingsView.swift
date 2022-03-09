//
//  SettingsView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 3/8/22.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsVM()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(viewModel.userRole != .admin ? "Account" : "Admin") {
                    NavigationLink {
                        ScrollView{
                            if viewModel.userRole == .admin {
                                ProjectListView(viewModel: .init(isAdmin: true))
                                    .navigationBarTitle("All Projects")
                            } else {
                                ProjectListView(viewModel: .init(isUser: true))
                                    .navigationBarTitle("My Projects")
                            }
                        }
                    } label: {
                        Text(viewModel.userRole != .admin ? "My Projects" : "All Projects")
                    }
                    NavigationLink {
                        //donations list
                        if viewModel.userRole == .admin {
                            DonationListView(viewModel: .init(isAdmin: true))
                                .navigationBarTitle("All Donations")
                        } else {
                            DonationListView(viewModel: .init(isUser: true))
                                .navigationBarTitle("My Donations")
                        }
                    } label: {
                        Text(viewModel.userRole != .admin ? "My Donations" : "All Donations")
                    }
                    if viewModel.userRole == .admin {
                        Text("Export Data")
                    }
                    Button("Log out") {
                        print("log out")
                        viewModel.signOut()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                Section("About") {
                    Text("Terms of Use")
                        .onTapGesture {
                            if let url = URL(string: viewModel.termsOfUse) {
                                UIApplication.shared.open(url, options: [:])
                            }
                        }
                    Text("Privacy Policy")
                        .onTapGesture {
                            if let url = URL(string: viewModel.privacyPolicy) {
                                UIApplication.shared.open(url, options: [:])
                            }
                        }
                    VStack {
                        Text("FundEd 1.0.0")
                        Text("Copyright 2022")
                            .font(.footnote)
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
