//
//  ContentView.swift
//  ProfileEx
//
//  Created by Miller on 3/8/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var graphController = GraphController()
    
    var body: some View {
        VStack{
            HStack {
                Slider(value: $graphController.adjustableValue, in: 0.0...10.0) {
                    Text(String(format: "%.2f", graphController.adjustableValue))
                }
                Text(String(format: "%.2f", graphController.computedValue))
            }
            
            Button("Increment"){graphController.updateData()}
            GraphViewRepresentable(graphController: graphController)
                .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
        }
        .padding()
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
