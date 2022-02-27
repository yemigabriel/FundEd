//
//  ProjectDetailView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/27/22.
//

import SwiftUI

struct ProjectDetailView: View {
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
                        
                        Button("Donate") {
                            print("donate")
                            viewModel.isDonateActive.toggle()
                        }
                        .padding()
                        .background(.blue.opacity(0.3))
                        .cornerRadius(10)
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
                        VStack(alignment: .leading) {
                            HStack(spacing: 10) {
                                Text("Item")
                                    .frame(width: width * 0.33, alignment: .leading)
                                Text("Qty")
                                    .frame(width: width * 0.07, alignment: .leading)
                                Text("Amount")
                                    .frame(width: width * 0.3, alignment: .leading)
                                Text("Total")
                                    .frame(width: width * 0.3, alignment: .leading)
                            }
                            .font(.subheadline.bold())
                            
                            ForEach(viewModel.projectMaterials, id: \.id) { material in
                                HStack(spacing: 10) {
                                    Text(material.item)
                                        .frame(width: width * 0.33, alignment: .leading)
                                    Text("\(material.quantity)")
                                        .frame(width: width * 0.07, alignment: .leading)
                                    Text("\(material.amount, specifier: "%.2f")")
                                        .frame(width: width * 0.3, alignment: .leading)
                                    Text("\(material.totalAmount, specifier: "%.2f")")
                                        .frame(width: width * 0.3, alignment: .leading)
                                }
                                .font(.subheadline)
                            }
                        }
                    }.frame(maxWidth: .infinity)
                    
                }
                .padding()
                Spacer(minLength: 100)
            }
            .alert(isPresented: .constant(viewModel.appState == .error), content: {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .cancel())
            })
            .onAppear {
                viewModel.getMaterials(for: viewModel.project.id!)
                viewModel.getDonations(for: viewModel.project.id!)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if viewModel.isAuthor {
                        Button{
                            print("edit")
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button{
                            print("delete")
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    } else {
                        Button{
                            print("donate")
                            viewModel.isDonateActive.toggle()
                        } label: {
                            Text("Donate")
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
        NavigationLink(isActive: $viewModel.isDonateActive) {
            AddDonationView()
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
