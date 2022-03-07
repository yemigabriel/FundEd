//
//  ProjectCardView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/26/22.
//

import SwiftUI

struct ProjectCardView: View {
    @StateObject private var viewModel: ProjectCardVM
    
    init(viewModel: ProjectCardVM) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            VStack ( alignment: .leading, spacing: 10) {
                
                AsyncImage(url: viewModel.project.photoUrl) { image in
                    image
                        .resizable()
                        .cardImageStyle(width: size.width)
                } placeholder: {
                    Image(systemName: "photo")
                        .imageScale(.large)
                        .cardImageStyle(width: size.width)
                        .background(Color(uiColor: .systemGray3))
                }
                
                Group {
                    Text(viewModel.project.title)
                        .font(.headline)
                        .fontWeight(.black)
                    
                    Text(viewModel.project.shortDescription)
                        .font(.body)
                        .lineLimit(2)
                    
                    Text(viewModel.project.authorName)
                        .font(.subheadline)
                        .lineLimit(1)
                    
                    Text(viewModel.project.school?.name ?? "")
                        .font(.caption)
//                        .italic()
                        .lineLimit(1)
                        .padding(.bottom)
                }
                .padding(.horizontal)
            }
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(20.0)
            
        }
        .frame(height: 320)
        .padding(.bottom)
        
    }
}


struct ProjectCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectCardView(viewModel: ProjectCardVM(project: Project.sample))
    }
}

struct CardImage: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: width, height: height)
            .clipped()
    }
}

struct OnboardingButtonStyle<T: Shape>: ViewModifier {
    let shape: T
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.purple)
            .padding()
            .background(Color.white)
            .clipShape(shape)
    }
}
