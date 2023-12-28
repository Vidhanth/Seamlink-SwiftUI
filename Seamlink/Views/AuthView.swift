//
//  AuthView.swift
//  Seamlink
//
//  Created by Vidhanth on 22/12/23.
//

import SwiftUI
import Auth

struct AuthView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    @State var passwordConfirmation: String = ""
    @State var isLoading: Bool = true
    @State var showSignUp: Bool = false
    @EnvironmentObject var currentSession: CurrentSession
    
    var signInView: some View {
        Group {
            Form {
                TextField("Email", text: $username)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .padding([.horizontal], 15)
                    .padding([.top], 15)
                    .padding([.bottom], 8)
                Divider()
                    .foregroundStyle(.primary)
                    .padding([.horizontal], 5)
                SecureField("Password", text: $password)
                    .submitLabel(.done)
                    .padding([.horizontal], 15)
                    .padding([.top], 8)
                    .padding([.bottom], 15)
            }.formStyle(.columns)
                .background(.secondary.opacity(0.2))
                .clipShape(.rect(cornerRadius: 15))
                .padding([.horizontal], 20)
                .padding([.vertical], 5)
            
            Button {
                withAnimation {
                    showSignUp = true
                }
            } label: {
                Text ("New here? Sign up")
                    .font(.subheadline)
                    .padding(.bottom, 3)
            }
            
            Button {
                
                Task {
                    
                    withAnimation {
                        isLoading = true
                    }
                    
                    let result = await AuthManager.shared.signIn(email: username, password: password)
                    
                    if (result.success) {
                        withAnimation {
                            let session = result.payload as! Session
                            currentSession.createSession(session: session)
                        }
                    } else {
                        withAnimation {
                            isLoading = false
                        }
                    }
                }
                
                
            } label: {
                Text ("Login")
                    .frame(maxWidth: .infinity)
                    .padding(7)
            }.buttonStyle(.borderedProminent)
                .clipShape(.rect(cornerRadius: 15))
                .padding([.horizontal], 20)
                .padding(.top, 0)
            Spacer()
        }
    }
    
    var signUpView: some View {
        Group {
            Form {
                TextField("Email", text: $username)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .padding([.horizontal], 15)
                    .padding([.top], 15)
                    .padding([.bottom], 8)
                Divider()
                    .foregroundStyle(.primary)
                    .padding([.horizontal], 5)
                SecureField("Password", text: $password)
                    .submitLabel(.done)
                    .padding([.horizontal], 15)
                    .padding([.top], 8)
                    .padding([.bottom], 15)
                Divider()
                    .foregroundStyle(.primary)
                    .padding([.horizontal], 5)
                SecureField("Confirm Password", text: $passwordConfirmation)
                    .submitLabel(.done)
                    .padding([.horizontal], 15)
                    .padding([.top], 8)
                    .padding([.bottom], 15)
            }.formStyle(.columns)
                .background(.secondary.opacity(0.2))
                .clipShape(.rect(cornerRadius: 15))
                .padding([.horizontal], 20)
                .padding([.vertical], 5)
            
            Button {
                withAnimation {
                    showSignUp = false
                }
            } label: {
                Text ("Already have an account? Sign in")
                    .font(.subheadline)
                    .padding(.bottom, 3)
            }
            
            
            Button {
                
                Task {
                    
                    
                    withAnimation {
                        isLoading = true
                    }
                    
                    
                    let result = await AuthManager.shared.signUp(email: username, password: password)
                    
                    if (result.success) {
                        withAnimation {
                            let session = result.payload as! Session
                            currentSession.createSession(session: session)
                        }
                    } else {
                        withAnimation {
                            isLoading = false
                        }
                    }
                    
                }
                
            } label: {
                Text ("Login")
                    .frame(maxWidth: .infinity)
                    .padding(7)
            }.buttonStyle(.borderedProminent)
                .clipShape(.rect(cornerRadius: 15))
                .padding([.horizontal], 20)
                .padding(.top, 0)
            Spacer()
        }
    }
    
    var body: some View {
        VStack (alignment: .center) {
            Spacer()
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding([.leading, .trailing], 70)
            if (isLoading) {
                ProgressView()
                    .padding(.top, 20)
                Spacer()
                
            } else {
                Text("Please sign up / sign in to continue.")
                    .font(.subheadline)
                    .foregroundStyle(.foreground.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                if (showSignUp) {
                    signUpView
                } else {
                    signInView
                }
            }
        }
        .onAppear {
            Task {
                let result = await AuthManager.shared.attemptSignIn()
                if (result.success) {
                    withAnimation {
                        let session = result.payload as! Session
                        currentSession.createSession(session: session)
                    }
                } else {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
    }
}

#Preview {
    AuthView()
        .environmentObject(CurrentSession())
}
