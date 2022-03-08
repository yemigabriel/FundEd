//
//  EditProjectView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 3/7/22.
//

import SwiftUI
import Combine

struct EditProjectView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: EditProjectVM
    
    init(project: Project, materials: [ProjectMaterial]) {
        self._viewModel = .init(wrappedValue: EditProjectVM(project: project, projectMaterials: materials))
    }
    var body: some View {
        NavigationView {
            ZStack {
            VStack {
                Form {
                    Section {
                        HStack(alignment: .top) {
                            Text("Project Title:")
                                .fontWeight(.bold)
                            Spacer()
                            TextField("Project Title", text: $viewModel.project.title)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Summary:")
                                .fontWeight(.bold)
                            TextEditor(text: $viewModel.project.shortDescription)
                        }
                        
                        VStack {
                            Picker(selection: $viewModel.project.school) {
                                SearchBar(text: $viewModel.schoolFilter, placeholder: "Search Schools")
                                ForEach(viewModel.filteredSchools, id: \.id) { school in
                                    Text(school.name)
                                        .font(.caption)
                                        .multilineTextAlignment(.leading)
                                        .tag(school)
                                }
                            } label: {
                                Text("Select School").fontWeight(.bold)
                            }
                        }
                    }
                    
                    Section{
                        Text("Tell us more about this project:")
                            .fontWeight(.bold)
                        TextEditor(text: $viewModel.project.description)
                            .frame(height: 200)
                    }
                    
                    Section{
                        HStack(alignment: .top) {
                            Button("Upload an image") {
                                viewModel.choosesImage.toggle()
                            }
                            Spacer()
                            //TODO: Review and improve this block
                            if let imageUrl = viewModel.project.photoUrl {
                                AsyncImage(url: imageUrl) { image in
                                    image
                                        .resizable()
                                        .cardImageStyle(width: 44, height: 44)
                                } placeholder: {
                                    Image(systemName: "photo")
                                        .imageScale(.large)
                                        .cardImageStyle(width: 44, height: 44)
                                        .background(Color(uiColor: .systemGray3))
                                }
                            } else {
                                EmptyView()
                            }
                        }
                    }
                    
                    Section {
                        ForEach($viewModel.projectMaterials) { $material in
                            VStack(alignment: .trailing) {
                                HStack {
                                    Text("Material:")
                                        .fontWeight(.bold)
                                    Spacer()
                                    TextField("Material", text: $material.item, prompt: Text("Material"))
                                        .multilineTextAlignment(.trailing)
                                }
                                HStack {
                                    Text("Quantity:")
                                        .fontWeight(.bold)
                                    Spacer()
                                    TextField("Quantity", value: $material.quantity, formatter: NumberFormatter(), prompt: Text("Quantity"))
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.trailing)
                                }
                                HStack {
                                    Text("Cost per item:")
                                        .fontWeight(.bold)
                                    Spacer()
                                    TextField("Cost per item", value: $material.cost, formatter: NumberFormatter(), prompt: Text("Cost per item"))
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.trailing)
                                }
                            
                                Button{
                                    withAnimation {
                                        viewModel.removeMaterial(material)
                                    }
                                } label: {
                                    Label("Remove", systemImage: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle()) // for swiftui bug
                                .padding()
                                .disabled(viewModel.projectMaterials.count == 1)
                                
                            }
                        }
                    } header: {
                        Text("What materials do you need?")
                    } footer: {
                        HStack {
                            Text("TOTAL: N\(viewModel.totalAmount, specifier: "%.2f")").fontWeight(.bold)
                            Spacer()
                            Button{
                                withAnimation{
                                viewModel.addMaterial()
                                }
                            } label: {
                                Label("Add more", systemImage: "plus")
                            }
                            .disabled(viewModel.projectMaterials.contains(where: {$0.item.isEmpty}))
                        }
                    }
                }
            }
            .onChange(of: viewModel.selectedImageData, perform: { imageData in
                if let _ = imageData {
                    viewModel.uploadImage()
                }
            })
            .sheet(isPresented: $viewModel.choosesImage) {
                PhotoPickerController(imageData: $viewModel.selectedImageData)
            }
            .alert(isPresented: .constant(viewModel.appState == .error)) {
                Alert(title: "Error", message: viewModel.errorMessage)
            }
            .alert(isPresented: $viewModel.isSuccessful) {
                Alert(title: "Your project has been successfully updated", message: nil) {
                    dismiss()
                }
            }
            .navigationTitle("Edit Project")
            .toolbar {
                ToolbarItem {
                    Button ("Finish") {
                        viewModel.update()
                    }
                    .disabled(!viewModel.isValidProject())
                }
            }
                
                if viewModel.appState == .loading {
                    ProgressView(viewModel.loadingMessage)
                        .padding()
                        .foregroundColor(.white)
                        .tint(.white)
                        .background(.black.opacity(0.7))
                        .cornerRadius(10)
                }
            }
        }
        
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.sample, materials: [ProjectMaterial.empty])
    }
}
