//
//  ProjectDetailView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/27/22.
//

import SwiftUI

struct ProjectDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ProjectDetailVM
    
    init(viewModel: ProjectDetailVM) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    var body: some View {
        ScrollView {
            VStack() {
                if viewModel.appState == .loading {
                    ProgressView()
                }
                
                AsyncImage(url: viewModel.project.photoUrl) { image in
                    image
                        .resizable()
                        .cardImageStyle(width: screenWidth, height: 320)
                } placeholder: {
                    Image(systemName: "photo")
                        .imageScale(.large)
                        .cardImageStyle(width: screenWidth, height: 320)
                        .background(Color(uiColor: .systemGray3))
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.project.title)
                        .font(.headline)
                        .fontWeight(.black)
                    HStack(spacing: 20) {
                        if viewModel.currentTotalDonation == 0.0 {
                            Text("N\(viewModel.project.amount, specifier: "%.2f")")
                                .font(.headline)
                                .padding()
                                .background(Color.blue.opacity(0.3))
                                .cornerRadius(10)
                        } else {
                            ProgressView("N\(viewModel.currentTotalDonation, specifier: "%.2f") out of N\(viewModel.project.amount, specifier: "%.2f") donated",
                                         value: viewModel.currentTotalDonation,
                                         total: viewModel.project.amount)
                                .frame(height: 44)
                        }
                        if viewModel.currentTotalDonation < viewModel.project.amount {
                            Button("Donate") {
                                print("donate")
                                if viewModel.isLoggedIn {
                                    viewModel.isDonateActive.toggle()
                                } else {
                                    viewModel.showLogin.toggle()
                                }
                            }
                            .padding()
                            .background(.blue.opacity(0.3))
                            .cornerRadius(10)
                        }
                    }
                    
                    
                    Text(viewModel.project.school?.name ?? "")
                        .font(.caption)
                        .lineLimit(1)
                    
                    Text(viewModel.project.shortDescription)
                        .lineLimit(3)
                    
                    Text(viewModel.project.authorName)
                        .font(.subheadline.bold())
                        .lineLimit(1)
                        .padding(.bottom)
                    
                    Text("About:")
                        .font(.headline)
                    
                    Text(viewModel.project.description)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom)
                    
                    Text("How Your Donation Will Be Used:")
                        .font(.headline)
                    
                    GeometryReader { proxy in
                        let width = proxy.size.width
                        VStack() {
                            HStack(spacing: 10) {
                                Text("Item")
                                    .frame(width: width * 0.3, alignment: .leading)
                                    .fixedSize()
                                Text("Qty")
                                    .frame(width: width * 0.1, alignment: .trailing)
                                Text("Amount")
                                    .frame(width: width * 0.3, alignment: .trailing)
                                Text("Total")
                                    .frame(width: width * 0.3, alignment: .trailing)
                            }
                            .font(.subheadline.bold())
                            
                            ForEach(viewModel.projectMaterials, id: \.id) { material in
                                Color(uiColor: .systemGray4).frame(width: width, height: 1)
                                HStack(spacing: 10) {
                                    Text(material.item)
                                        .frame(width: width * 0.33, alignment: .leading)
                                        .fixedSize()
                                    Text("\(material.quantity)")
                                        .frame(width: width * 0.07, alignment: .trailing)
                                    Text("\(material.cost, specifier: "%.2f")")
                                        .frame(width: width * 0.3, alignment: .trailing)
                                    Text("\(material.totalAmount, specifier: "%.2f")")
                                        .frame(width: width * 0.3, alignment: .trailing)
                                }
                                .font(.subheadline)
                            }
                        }
                        .frame(width: width)
                    }
                    .padding()
                }
                .padding()
                
                Spacer(minLength: 100)
            }
            .alert(isPresented: .constant(viewModel.appState == .error), content: {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .cancel())
            })
            .alert(isPresented: $viewModel.showDeleteAlert, content: {
                Alert(title: "Are you sure you want to delete this project?", message: nil, primaryButtonTitle: "Yes", secondaryButtonTitle: "Cancel") {
                    viewModel.deleteProject()
                    dismiss()
                } secondaryAction: {
                    viewModel.showDeleteAlert = false
                }
            })
            .sheet(isPresented: $viewModel.showEditView, content: {
                EditProjectView(project: viewModel.project, materials: viewModel.projectMaterials)
            })
            .sheet(isPresented: $viewModel.showLogin, content: {
                AuthView(hasHistory: true, shouldShowLogin: $viewModel.showLogin)
            })
            .onAppear {
                viewModel.getMaterials()
                viewModel.getDonations()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if viewModel.isAuthor {
                        Button{
                            viewModel.showEditView.toggle()
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button{
                            viewModel.showDeleteAlert.toggle()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    } else {
                        Button{
                            print("donate")
                            if viewModel.isLoggedIn {
                                viewModel.isDonateActive.toggle()
                            } else {
                                viewModel.showLogin.toggle()
                            }
                        } label: {
                            Text("Donate")
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
        NavigationLink(isActive: $viewModel.isDonateActive) {
            AddDonationView(viewModel: .init(project: viewModel.project, amountLeft: viewModel.project.amount - viewModel.currentTotalDonation))
        } label: {
            EmptyView()
        }

    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(viewModel: ProjectDetailVM.init(project: Project.sample))
    }
}
