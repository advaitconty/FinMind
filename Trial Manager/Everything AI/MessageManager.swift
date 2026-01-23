//
//  MessageManager.swift
//  Trial Manager
//
//  Created by Milind Contractor on 23/1/26.
//

import FoundationModels
import Foundation

extension AIView {
    func sendMessage() {
        Task {
            conversationHistory.append(ConversationItem(personResponding: .person, text: enteredText))
            generatingContent = true
            
            do {
                let prompt = enteredText
                enteredText = ""
                let stream = session.streamResponse(to: prompt)
                conversationHistory.append(ConversationItem(personResponding: .ai, text: ""))
                for try await response in stream {
                    conversationHistory[0].text = response.content
                }
            } catch let error as LanguageModelSession.GenerationError {
                print(error.localizedDescription)
                errorText = error.localizedDescription
            }
        }
    }
}
