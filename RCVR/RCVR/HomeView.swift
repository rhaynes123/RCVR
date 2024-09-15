//
//  HomeView.swift
//  RCVR
//
//  Created by richard Haynes on 4/12/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showDisclaimer : Bool = false
    private var acknowledgedDisclaimer = UserDefaults.standard.bool(forKey: "acknowledgedDisclaimer")
    
    private let disclaimer : String = """
                IMPORTANT:Before beginning any exercise or fitness program, it is recommended that you.Consult with your primary care physician or a qualified healthcare professional.By engaging in any exercise or fitness program, you agree that you do so at your own risk, are voluntarily participating in these activities, and assume all risk of injury to yourself. The developers, and distributors of this product will not be held liable for any injury or damage sustained while following this program. Stay safe, stay healthy, and enjoy your recovery!
    """
    
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
        .onAppear {
            if !self.acknowledgedDisclaimer {
                showDisclaimer.toggle()
            }
        }
        .alert("Disclaimer", isPresented: $showDisclaimer){
            Button("Confirm") {
                UserDefaults.standard.setValue(true, forKey: "acknowledgedDisclaimer")
                showDisclaimer.toggle()
            }
            Button("Cancel", role: .cancel){
                showDisclaimer.toggle()
            }
            
        } message: {
            Text(disclaimer)
        }
        
        
    }
}

#Preview {
    HomeView()
}
