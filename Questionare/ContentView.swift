//
//  ContentView.swift
//  Questionare
//
//  Created by Vishnu on 2021-09-30.
//

import SwiftUI

struct ContentView: View {
    
    @State
    private var showQuestionare = false
    
    var body: some View {
        VStack{
            Text("Hello, world!")
                .padding()
            Button {
                showQuestionare = true
            } label: {
                Text("Click me")
            }

        }.sheet(isPresented: $showQuestionare) {
            QuestionaireView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
