//  D'Mitri Lewis
//  ContentView.swift


import SwiftUI

struct ContentView: View {
    @State private var messageText = ""
    @State var messages: [String] = ["Welcome to EnerGize 2.0!"]
    
    var body: some View {
        VStack {
            HStack {
                Text("EnerGize")
                    .font(.largeTitle)
                    .bold()
                
                Image(systemName: "bubble.left.fill")
                    .font(.system(size: 26))
                    .foregroundColor(Color.blue)
            }
            .padding(.bottom)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages, id: \.self) { message in
                        // Adjust alignment and style based on whether it's a user or bot message
                        if message.contains("[USER]") {
                            let userMessage = message.replacingOccurrences(of: "[USER]", with: "")
                            HStack {
                                Spacer()
                                Text(userMessage)
                                    .padding()
                                    .foregroundColor(Color.white)
                                    .background(Color.blue.opacity(0.8))
                                    .cornerRadius(10)
                            }
                        } else {
                            HStack {
                                Text(message)
                                    .padding()
                                    .background(Color.gray.opacity(0.15))
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Message bar at the bottom
            HStack {
                TextField("Type something", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    sendMessage(message: messageText)
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 26))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal, 10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    func sendMessage(message: String) {
        withAnimation {
            messages.append("[USER]\(message)")
            self.messageText = "" // Clear the text field after sending
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    // Here, add your logic for generating the bot's response
                    messages.append(getBotResponse(message: message))
                }
            }
        }
    }
    
    func getBotResponse(message: String) -> String {
        // This is a placeholder for your response logic
        // Return a dynamic response based on the message
        return "Echo: \(message)" // Example response
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
