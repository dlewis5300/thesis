//
//  ContentView.swift
//  EnerGize5
//
//  Created by D'Mitri Lewis on 4/20/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ChatViewModel

    // Initialization with dependency injection
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HStack {
                Text("EnerGize")
                    .font(.largeTitle)
                    .bold()
                
                Image(systemName: "bubble.left.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color.blue)
            }
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.messages, id: \.self) { message in
                        Text(message)
                            .padding()
                            .background(message.contains("[USER]") ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity, alignment: message.contains("[USER]") ? .trailing : .leading)
                    }
                }
            }
            .background(Color.gray.opacity(0.1))

            HStack {
                TextField("Type a message...", text: $viewModel.messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 44) // Ensures adequate touch target size

                Button(action: {
                    viewModel.sendMessage() // Assuming sendMessage does not need parameters
                    viewModel.messageText = "" // Clear the text field after sending
                }) {
                    Image(systemName: "paperplane.fill") // Using an icon for the button
                        .font(.system(size: 22)) // Set the size of the icon
                        .foregroundColor(.blue) // Set the color of the icon
                }
                .buttonStyle(PlainButtonStyle()) // Styling the button
                .padding(.horizontal) // Adding some horizontal padding
            }
            .padding() // Padding around the entire HStack

        }
    }
}

// Ensure the preview uses a default instance of the viewModel
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ChatViewModel())
    }
}
