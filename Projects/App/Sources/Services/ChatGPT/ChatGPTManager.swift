//
//  ChatRequestManager.swift
//  SYM
//
//  Created by 변상필 on 2/19/24.
//  Copyright © 2024 Mogong. All rights reserved.
//

import Foundation
import Combine

class ChatGPTManager: ObservableObject {
    
    static let shared = ChatGPTManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var responseData: Data?
    @Published var responseError: Error?
    
    @Published var contentString: String?
    
    func makeRequest(text: String) -> AnyPublisher<String?, Error>? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_KEY") as? String else { return nil }
        let model = "gpt-3.5-turbo-0125"
        let prompt = text
        let temperature = 0.9
        let maxTokens = text.count + 200
        let topP = 1
        let frequencyPenalty = 0.0
        let presencePenalty = 0.6
        
        // requestBody
        let requestBody : [String : Any] = [
            "model": model,
            "messages": [
                [
                    "role": "user", "content": "\(prompt)"
                ]
            ],
            "temperature": temperature,
            "max_tokens": maxTokens,
            "top_p": topP,
            "frequency_penalty": frequencyPenalty,
            "presence_penalty": presencePenalty,
        ]
        
        let endPoint = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)
        
        var request = URLRequest(url: endPoint)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .map { self.getContentFromData(data: $0)}
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    private func getContentFromData(data: Data) -> String? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            if let jsonDict = jsonObject as? [String: Any],
               let choices = jsonDict["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String {
                
                return content
                
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
