//
//  ContentView.swift
//  GeminiAPITest
//
//  Created by user on 06/02/24.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    
    @State private var answer = "Hello! How can I help you today?"
    @State private var prompt = ""
    @State private var promptScreen = ""
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
            
            Spacer()
                Text(promptScreen)
                ScrollView {
                    Text(answer)
                }
                .frame(maxWidth: .infinity, maxHeight: 600)
                .font(.title)
                .frame(alignment: .topTrailing)
                
                Spacer()
                
                HStack {
                    TextField("Enter a Prompt", text: $prompt)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .foregroundColor(.black)
                    
                    Button(action: sendMessage) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding(.horizontal)
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "paperplane.fill")
                                .padding()
                                .font(.title)
                        }
                    }
                }
            }
            .padding()
        }
        .foregroundColor(.white)
    }
    
    func sendMessage() {
        answer = ""
        isLoading = true
        
        Task {
            do {
                if prompt.isEmpty {
                    answer = "Please enter a prompt."
                } else {
                    let generatedResponse = try await model.generateContent(prompt)
                    guard let text = generatedResponse.text else {
                        answer = "Sorry, I could not process that"
                        return
                    }
                    promptScreen = prompt
                    answer = text
                }
            } catch {
                answer = "\(error.localizedDescription)"
            }
            
            isLoading = false // Hide loading indicator after response is received
        }
    }
}

#Preview {
    ContentView()
}
