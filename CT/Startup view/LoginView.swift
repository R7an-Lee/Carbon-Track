//
//  LoginView.swift
//
// This class generates the login view of the app
//

import SwiftUI

struct LoginView : View {
    
    // Binding input parameter
    @Binding var canLogin: Bool
    
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
    
    // State variables
    @State private var enteredPassword = ""
    @State private var showInvalidPasswordAlert = false
    @State private var showNoBiometricCapabilityAlert = false
    
    @State private var index = 0
    /*
     Create a timer publisher that fires 'every' 3 seconds and updates the view.
     It runs 'on' the '.main' runloop so that it can update the view.
     It runs 'in' the '.common' mode so that it can run alongside other
     common events such as when the ScrollView is being scrolled.
     */
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            // Background View
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                
            // Foreground View
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Image("Welcome")
                        .padding()
                    
                    Text("Personal Information Manager")
                        .font(.headline)
                        .padding()
                    
                    // This public function is given in UtilityFunctions.swift
                    Image("Co2circle")
                        .padding()
                    
                    SecureField("Password", text: $enteredPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300, height: 36)
                        .padding()
                    
                    HStack {
                        Button("Login") {
                            /*
                             UserDefaults provides an interface to the user’s defaults database,
                             where you store key-value pairs persistently across launches of your app.
                             */
                            // Retrieve the password from the user’s defaults database under the key "Password"
                            let validPassword = UserDefaults.standard.string(forKey: "Password")
                            
                            /*
                             If the user has not yet set a password, validPassword = nil
                             In this case, allow the user to login.
                             */
                            if validPassword == nil || enteredPassword == validPassword {
                                canLogin = true
                            } else {
                                showInvalidPasswordAlert = true
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .padding()
                        
                        if UserDefaults.standard.string(forKey: "SecurityQuestion") != nil {
                            NavigationLink(destination: ResetPassword()) {
                                Text("Forgot Password")
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .padding()
                        }
                    }   // End of HStack
                    
                    /*
                     *********************************************************
                     *   Biometric Authentication with Face ID or Touch ID   *
                     *********************************************************
                     */
                    
                    // Enable biometric authentication only if a password has already been set
                    if UserDefaults.standard.string(forKey: "Password") != nil {
                        Button("Use Face ID or Touch ID") {
                            // authenticateUser() is given in UserAuthentication
                            authenticateUser() { status in
                                switch (status) {
                                case .Success:
                                    canLogin = true
                                    print("case .Success")
                                case .Failure:
                                    canLogin = false
                                    print("case .Failure")
                                case .Unavailable:
                                    canLogin = false
                                    showNoBiometricCapabilityAlert = true
                                    print("case .Unavailable")
                                }
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        HStack {
                            Image(systemName: "faceid")
                                .font(.system(size: 40))
                                .padding()
                            Image(systemName: "touchid")
                                .font(.system(size: 40))
                                .padding()
                        }
                    }
                }   // End of VStack
            }   // End of ScrollView
            .onAppear() {
                startTimer()
            }
            .onDisappear() {
                stopTimer()
            }
                
            }   // End of ZStack
            .alert(isPresented: $showInvalidPasswordAlert, content: { invalidPasswordAlert })
            .navigationBarHidden(true)
            
        }   // End of NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showNoBiometricCapabilityAlert, content: { noBiometricCapabilityAlert })
        
    }   // End of body var
    
    func startTimer() {
        timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
    //-----------------------
    // Invalid Password Alert
    //-----------------------
    var invalidPasswordAlert: Alert {
        Alert(title: Text("Invalid Password!"),
              message: Text("Please enter a valid password to unlock the app!"),
              dismissButton: .default(Text("OK")) )
        // Tapping OK resets showInvalidPasswordAlert to false
    }
    
     //------------------------------
     // No Biometric Capability Alert
     //------------------------------
    var noBiometricCapabilityAlert: Alert{
        Alert(title: Text("Unable to Use Biometric Authentication!"),
              message: Text("Your device does not support biometric authentication!"),
              dismissButton: .default(Text("OK")) )
        // Tapping OK resets showNoBiometricCapabilityAlert to false
    }
    
}

