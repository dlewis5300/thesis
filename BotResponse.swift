//  D'Mitri Lewis
//  BotResponse.swift


import UIKit
import Alamofire

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var messages: [String] = [] // Placeholder for the messages data source

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!

    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
    
    // SendMessage Action
    @IBAction func sendMessageButtonPressed(_ sender: UIButton) {
        guard let userMessage = inputTextField.text, !userMessage.isEmpty else { return }
        addMessage("You: \(userMessage)")
        generateBotResponse(for: userMessage)
    }
    
    // Add new message to the chat
    func addMessage(_ message: String) {
        messages.append(message)
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    // Bot Response Decodable Structure
    struct BotResponse: Decodable {
        let sentiment: String
        // Add other properties based on your JSON response
    }
    
    // Generate Bot Response
    func generateBotResponse(for userMessage: String) {
        let apiKey = " api key "
        let endpoint = "https://api.sentiment-analysis.com/analyze"
        
        let parameters: [String: Any] = ["text": userMessage, " api key ": apiKey]
        
        AF.request(endpoint, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseDecodable(of: BotResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let botResponse):
                    self.handleBotResponse(botResponse)
                    
                case .failure(let error):
                    print("Error: \(error)")
                    self.handleUnknownResponse()
                }
            }
    }
    
    // Handle Bot Response
    func handleBotResponse(_ response: BotResponse) {
        let botMessage = "Bot: Sentiment - \(response.sentiment)"
        addMessage(botMessage)
    }
    
    // Handle Unknown Response
    func handleUnknownResponse() {
        let errorMessage = "Bot: I'm not sure how to respond to that."
        addMessage(errorMessage)
    }
}
