//
//  HomeView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 8/24/21.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView() {
            VStack {
                List(0 ..< 20) { item in
                    FundCardView(item: item)
                }
                .listStyle(PlainListStyle())
                
            }
            .navigationTitle("Home")
            
            
        }
        
        
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
        VStack ( alignment: .leading, spacing: 20) {
            Image(systemName: "keyboard")
                .resizable()
                .frame(width: .infinity, height: 200, alignment: .top)
                .aspectRatio(contentMode: .fill)
            
            Group {
                Text("\(item) Future Scientist in You")
                    .font(.title)
                    .fontWeight(.black)
                
                Text("Help me give my students supplies to disinfect our room and provide extra masks when necessary so that we can sing safely and continue to have class in-person, and a conductor's music stand big enough for music scores.")
                    .font(.body)
                    .lineLimit(3)
                
                Text("Ms. Jones")
                    .font(.headline)
                    .lineLimit(1)
                
                Text("Ansaruudeen Secondary School, Lagos")
                    .font(.subheadline)
                    .italic()
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
        .background(Color.white)
        .cornerRadius(10.0)
    }
}
