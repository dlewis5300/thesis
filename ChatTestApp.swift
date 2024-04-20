//
//  ChatViewModel.swift
//  EnerGize5
//
//  Created by D'Mitri Lewis on 4/20/24.
//

import Foundation
import Alamofire
import Combine

final class ChatViewModel: ObservableObject {
    @Published var messages: [String] = ["Welcome to EnerGize 2.0!"]
    @Published var messageText: String = ""

    struct APIResponse: Decodable {
        struct Choice: Decodable {
            struct Message: Decodable {
                let role: String
                let content: String
            }
            let message: Message
        }
        let choices: [Choice]
    }

    func sendMessage() {
        let userInput = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userInput.isEmpty else { return }
        messages.append("[USER] \(userInput)")
        messageText = ""

        let headers: HTTPHeaders = [
            "Authorization": "Bearer yourapikey",
            "Content-Type": "application/json"
        ]

        // Assuming the API expects a history of messages or conversational turns
        let chatMessages = [
            ["role": "system", "content": "Welcome to EnerGize 2.0!"],
            ["role": "user", "content": userInput]
        ]

        let parameters: Parameters = [
            "model": "gpt-3.5-turbo",
            "messages": chatMessages,
            "max_tokens": 60,
            "temperature": 0.7
        ]

        sendRequest(headers: headers, parameters: parameters)
    }

    private func sendRequest(headers: HTTPHeaders, parameters: Parameters, retryCount: Int = 0) {
        AF.request("https://api.openai.com/v1/chat/completions", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: APIResponse.self) { [weak self] response in
                DispatchQueue.main.async {
                    self?.handleResponse(response)
                }
            }
    }

    private func handleResponse(_ response: DataResponse<APIResponse, AFError>) {
        switch response.result {
        case .success(let apiResponse):
            if let firstResponse = apiResponse.choices.first {
                // Displaying the assistant's response from the nested 'message' structure
                self.messages.append("Bot: \(firstResponse.message.content)")
            }
        case .failure(let error):
            handleError(response: response, error: error)
        }
    }

    private func handleError(response: DataResponse<APIResponse, AFError>, error: AFError) {
        if let statusCode = response.response?.statusCode {
            print("HTTP Status Code: \(statusCode)")
            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseString)")  // Logs the server's response to help diagnose the issue.
            }

            let errorMessage = "Bot: \(error.localizedDescription)"
            switch statusCode {
            case 400:
                messages.append("Bot: Bad Request - \(errorMessage). Check your request parameters.")
            case 429:
                messages.append("Bot: Too Many Requests - \(errorMessage). Try again later.")
            case 401:
                messages.append("Bot: Unauthorized - \(errorMessage). Check your API key.")
            default:
                messages.append("Bot: \(errorMessage)")
            }
        } else {
            messages.append("Bot: Network or unknown error occurred.")
            print("Request failed with error: \(error.localizedDescription)")
        }
    }
}
