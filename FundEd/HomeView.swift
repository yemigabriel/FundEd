//
//  HomeView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 8/24/21.
//

import SwiftUI

struct HomeView: View {
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 50)
    ]
    var body: some View {
        NavigationView() {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 50) {
                    ForEach(0 ..< 20) { item in
                        FundCardView(item: item)
                    }
                }
//                List(0 ..< 20) { item in
//                    FundCardView(item: item)
//                }
//                .listStyle(PlainListStyle())
                
            }
            .padding()
            .background(Color(uiColor: .systemGray6))
            .navigationTitle("Home")
            
            
            
        }
        .navigationViewStyle(.stack)
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct FundCardView: View {
    @State var item: Int
        
    var body: some View {
                
        GeometryReader { proxy in
            let size = proxy.size
            
            
            VStack ( alignment: .leading, spacing: 10) {
                
                Image("classroom")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: 200)
                    .clipped()
                
                
                
                Group {
                    Text("\(item) Future Scientist in You")
                        .font(.title)
                        .fontWeight(.black)
                    
                    Text("Help me give my students supplies to disinfect our room and provide extra masks when necessary so that we can sing safely and continue to have class in-person, and a conductor's music stand big enough for music scores.")
                        .font(.body)
                        .lineLimit(2)
                    
                    Text("Ms. Jones")
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text("Ansaruudeen Secondary School, Lagos")
                        .font(.subheadline)
                        .italic()
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
