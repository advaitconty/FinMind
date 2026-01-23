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
            generatingContent = true
            liveGeneratingResponseText = ""
            do {
                let prompt = enteredText
                enteredText = ""
                let stream = session.streamResponse(to: prompt)
                for try await response in stream {
                    // Show partial content while streaming; transcript observer will update the chat when complete
                    liveGeneratingResponseText = response.content
                }
                generatingContent = false
                liveGeneratingResponseText = ""
            } catch let error as LanguageModelSession.GenerationError {
                print(error.localizedDescription)
                errorText = error.localizedDescription
                generatingContent = false
            } catch {
                print(error.localizedDescription)
                errorText = error.localizedDescription
                generatingContent = false
            }
        }
    }
}
