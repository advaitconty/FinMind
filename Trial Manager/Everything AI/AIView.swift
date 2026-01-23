//
//  AIView.swift
//  Trial Manager
//
//  Created by Milind Contractor on 23/1/26.
//

import SwiftUI
import FoundationModels
import Forever

struct AIView: View {
    @Binding var userData: UserData
    @State var modelReady: Bool = false
    @State var liveGeneratingResponseText: String = ""
    @State var session = LanguageModelSession {
        basePrompt
    }
    @State var errorText: String? = nil
    @State var modelAvailability: AIAvailabilityInformation? = nil
    @AppStorage("warning") var showWarningPopup: Bool = true
    @Environment(\.colorScheme) var colorScheme
    @Forever("conversationHistory") var conversationHistory: [ConversationItem] = []
    @State var enteredText: String = "i"
    @State var showSendButton: Bool = true
    @State var generatingContent: Bool = false
    let debug: Bool = true
    
    // Map session transcript -> conversation items (user prompts and AI responses only)
    private func rebuildConversationFromTranscript() {
        let entries = session.transcript
        var items: [ConversationItem] = []
        for entry in entries {
            switch entry {
            case .prompt(let prompt):
                let text = prompt.segments.compactMap { segment -> String? in
                    if case let .text(textSegment) = segment { return textSegment.content }
                    return nil
                }.joined()
                if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    items.append(ConversationItem(personResponding: .person, text: text))
                }
            case .response(let response):
                let text = response.segments.compactMap { segment -> String? in
                    if case let .text(textSegment) = segment { return textSegment.content }
                    return nil
                }.joined()
                if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    items.append(ConversationItem(personResponding: .ai, text: text))
                }
            default:
                // Ignore instructions, tool calls, and tool outputs for chat display
                break
            }
        }
        conversationHistory = items
    }
    
    func warningPopupView(reader: GeometryProxy) -> some View {
        ZStack {
            Color.accentColor.opacity(0.2)
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.largeTitle.bold())
                    Text("WARNING")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    Spacer()
                    Button {
                        showWarningPopup = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .adaptiveProminentButtonStyle()
                    
                }
                .padding()
                .frame(minWidth: reader.size.width - 20)
                .background(Color.accentColor)
                
                Text("This feature is powered by Artificial Intelligence (AI). It is not intended to replace human judgment or decision-making. Always verify information from multiple sources before making important decisions. We will not be liable for any information that has caused you financial harm, as you have been warned adequately. You can access this warning anytime by pressing on the warning triangle next to the heading of the analyst. By dismissing this popup, you have effectively agreed to this disclaimer.")
                
                    .padding()
                    .frame(minWidth: reader.size.width - 20)
                    .background(colorScheme == .dark ? .black : .white)
            }
            .clipShape(RoundedRectangle(cornerRadius: 35.0))
            .padding()
            .frame(maxWidth: reader.size.width - 20, maxHeight: reader.size.height)
            .presentationDetents([.fraction(0.5)])
        }
        .ignoresSafeArea()
    }
    
    func whatMattersView(reader: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Financial Analyst")
                    .font(.title)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "exclamationmark.triangle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.title)
                    .onTapGesture {
                        showWarningPopup = true
                    }
            }
            .padding()
            .frame(minWidth: reader.size.width - 20)
            .background(Color.accentColor)
            .sheet(isPresented: $showWarningPopup) {
                warningPopupView(reader: reader)
            }
            // Conversation view
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(conversationHistory, id: \.id) { conversation in
                        if conversation.personResponding == .person {
                            VStack {
                                HStack {
                                    Image(systemName: conversation.iconForPerson)
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                    
                                    Text("YOU")
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                                Text(conversation.text)
                                    .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
                                    .foregroundStyle(.white)
                            }
                            .padding()
                            .background(Color.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        } else {
                            VStack {
                                HStack {
                                    Image(systemName: conversation.iconForPerson)
                                        .font(.caption)
                                    
                                    Text("ADVISOR")
                                        .font(.caption)
                                    Spacer()
                                }
                                Text(conversation.text)
                                    .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
                            }
                            .padding()
                            .background(Color.accentColor.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        }
                    }
                    
                    if generatingContent {
                        VStack {
                            HStack {
                                Image(systemName: "apple.intelligence")
                                    .font(.caption)
                                
                                Text("ADVISOR")
                                    .font(.caption)
                                Spacer()
                            }
                            HStack {
                                ProgressView()
                                Text("Generating response...")
                                    .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
                            }
                            Text(liveGeneratingResponseText)
                                .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
                        }
                        .padding()
                        .background(Color.accentColor.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    }
                    Color.clear
                        .id("BOTTOM")
                }
                .onAppear {
                    proxy.scrollTo("BOTTOM", anchor: .bottom)
                    // Initialize from transcript if available, otherwise show debug or empty
                    if session.transcript.isEmpty {
                        if debug {
                            conversationHistory = Array.conversation5_savingsGoal
                        } else {
                            conversationHistory = []
                        }
                    } else {
                        rebuildConversationFromTranscript()
                    }
                }
                .onChange(of: conversationHistory.count) {
                    proxy.scrollTo("BOTTOM", anchor: .bottom)
                }
                .onChange(of: session.transcript) { _ in
                    rebuildConversationFromTranscript()
                    proxy.scrollTo("BOTTOM", anchor: .bottom)
                }
            }
            .padding([.top, .leading, .trailing])
            .frame(minWidth: reader.size.width - 20)
            .background(colorScheme == .dark ? .black : .white)
            
            if errorText != nil {
                HStack {
                    Image(systemName: "exclamationmark.octagon.fill")
                        .symbolRenderingMode(.multicolor)
                    Text("Error: \(errorText!)")
                    
                }
                .padding()
                .frame(minWidth: reader.size.width - 20)
                .background(colorScheme == .dark ? .black : .white)
            }
            
            HStack {
                TextField("Ask something...", text: $enteredText)
                    .padding()
                    .glassEffect()
                    .onChange(of: enteredText) { newValue in
                        if enteredText.isEmpty {
                            withAnimation {
                                showSendButton = false
                            }
                        } else {
                            withAnimation {
                                showSendButton = true
                            }
                        }
                    }
                    .onAppear {
                        if enteredText.isEmpty {
                            withAnimation {
                                showSendButton = false
                            }
                        } else {
                            withAnimation {
                                showSendButton = true
                            }
                        }
                    }
                
                if showSendButton {
                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "paperplane")
                            .padding([.all], 10)
                    }
                    .adaptiveButtonStyle()
                }
                
            }
            .padding()
            .frame(minWidth: reader.size.width - 20)
            .background(Color.accentColor)
        }
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color.accentColor.opacity(0.2)
                VStack(spacing: 0) {
                    if modelAvailability == nil {
                        HStack {
                            ProgressView()
                                .tint(.white)
                            Text("Loading model...")
                                .font(.largeTitle)
                                .padding()
                                .foregroundStyle(.white)
                        }
                        .padding()
                        .frame(minWidth: reader.size.width - 20)
                        .background(Color.accentColor)
                        .onAppear {
                            modelAvailability = checkAIAvailability()
                        }
                    } else if let modelAvailability = modelAvailability {
                        if !modelAvailability.availability {
                            ContentUnavailableView(modelAvailability.reasonForNotWorking!, systemImage: "apple.intelligence.badge.xmark")
                        } else {
                            if !modelReady {
                                HStack {
                                    ProgressView()
                                        .tint(.white)
                                    Text("Preparing model...")
                                        .font(.largeTitle)
                                        .padding()
                                        .foregroundStyle(.white)
                                }
                                .padding()
                                .frame(minWidth: reader.size.width - 20)
                                .background(Color.accentColor)
                                .onAppear {
                                    session.prewarm()
                                    modelReady = true
                                }
                            } else {
                                // MARK: Main view code goes here
                                whatMattersView(reader: reader)
                            }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .padding()
                .frame(maxWidth: reader.size.width - 20, maxHeight: reader.size.height)
            }
            .ignoresSafeArea()
            .onAppear {
                session = LanguageModelSession(tools: [GetUserProfileTool(userData: userData),
                                                       AnalyseRecentTransactionsTool(userData: userData),
                                                       AnalyseSubscriptionTool(userData: userData),
                                                       GetSpendingInsightsTotalTool(userData: userData)]) {
                    basePrompt
                }
            }
        }
    }
}

#Preview {
    AIView(userData: .constant(UserData.freelancer()))
}
