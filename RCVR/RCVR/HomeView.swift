//
//  HomeView.swift
//  RCVR
//
//  Created by richard Haynes on 4/12/24.
//

import SwiftUI

struct HomeView: View {
    
    private let quote : String = """
    "It is during our darkest moments that we must focus to see the light." - Aristotle
 """
    var body: some View {
        NavigationStack {
            VStack {
                Image("logo").resizable().frame(width: 100, height: 100)
                Text(quote)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(width:400, height: 300)
                    .background(.ultraThinMaterial.opacity(0.8))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.3), radius: 10)
                
            }
            NavigationLink("My Activity And Trends", destination: MainView())
                .buttonStyle(BorderedProminentButtonStyle())
                .frame(width: 300, height: 50, alignment: .center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            
        }
        
        
    }
}

#Preview {
    HomeView()
}
