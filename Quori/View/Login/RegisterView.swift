//
//  RegisterView.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

//Register View
struct RegisterView: View{
    @State var emailID: String = ""
    @State var userName: String = ""
    @State var password: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilePicData: Data?
    
    //View Properties
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    //User Defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_uid") var userUID: String = ""
    var body: some View{
        ZStack {
            
            Circle()
                .fill(.purple.gradient)
                .offset(x:-150, y: -400)
            
            Image("uccLogo")
        
            Circle()
                .fill(.orange.gradient)
                .offset(x:200, y: 350)
            
            BlurView(style: .systemThinMaterialLight)
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text("Create\nyour account")
                    .font(.largeTitle.bold())
                    .hAlign(.leading)
                
                //For Smaller Size Optimization
                ViewThatFits{
                    ScrollView(.vertical, showsIndicators: false){
                        HelperView()
                    }
                    HelperView()
                }
                
                //Register Button
                HStack{
                    Text("Already have an account?")
                        .foregroundColor(Color.gray)
                    
                    Button("Login"){
                        dismiss()
                    }
                    .foregroundColor(Color.black)
                    .fontWeight(.bold)
                }
                .font(.callout)
                .vAlign(.bottom)
            }
            .vAlign(.top)
            .padding(15)
            .overlay(content: {
                LoadingView(show: $isLoading)
            })
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            .onChange(of: photoItem){ newValue in
                //Extracting UI image From Photo Item
                if let newValue{
                    Task{
                        do{
                            guard let imageData = try await newValue.loadTransferable(type: Data.self) else {return}
                            //UI Must Be Updated On Main Thread
                            await MainActor.run(body: {
                                userProfilePicData = imageData
                            })
                        }catch{}
                    }
                }
            }
            
            //Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
        }
    }
    
    @ViewBuilder
    func HelperView()->some View{
        VStack(spacing: 12){
            ZStack{
                if let userProfilePicData, let image = UIImage(data: userProfilePicData){
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }else{
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 85, height: 85)
            .clipShape(Circle())
            .contentShape(Circle())
            .onTapGesture {
                showImagePicker.toggle()
            }
            .padding(.top, 25)
            
            TextField("Username", text: $userName)
                .textContentType(.emailAddress)
                .border(1, Color.gray.opacity(0.5))

            
            TextField("Email", text: $emailID)
                .textContentType(.emailAddress)
                .border(1, Color.gray.opacity(0.5))
            
            SecureField("Password", text: $password)
                .textContentType(.emailAddress)
                .border(1, Color.gray.opacity(0.5))
            
            TextField("About You", text: $userBio, axis: .vertical)
                .frame(minHeight: 100, alignment: .top)
                .textContentType(.emailAddress)
                .border(1, Color.gray.opacity(0.5))
            
            TextField("Bio Link (Optional)", text: $userBioLink)
                .textContentType(.emailAddress)
                .border(1, Color.gray.opacity(0.5))
            Button(action: registerUser){
                //Submit Button
                Text("Sign Up")
                    .foregroundColor(Color.white)
                    .hAlign(.center)
                    //.fillView(Color.black)
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(.linearGradient(colors: [Color.purple, Color.orange], startPoint: .trailing, endPoint: .leading))
                    }
                    .shadow(radius: 10)
            }
            .padding(.top, 10)
            .disableWithOpacity(userName == "" || userBio == "" || emailID == "" || password == "" || userProfilePicData == nil)
        }
    }
    
    func registerUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                //Creating User
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                
                //Uploading Profile Picture To Firebase Storage
                guard let userUID = Auth.auth().currentUser?.uid else {return}
                guard let imageData = userProfilePicData else {return}
                let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
                let _ = try await storageRef.putDataAsync(imageData)
                
                //Downoading Photo URL
                let downloadURL = try await storageRef.downloadURL()
                
                //Create User Firestore Object
                let user = User(username: userName, userBio: userBio, userBioLink: userBioLink, userUID: userUID, userEmail: emailID, userProfileURL: downloadURL)
                
                //Saving User Document Into Firebase Database
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: {
                    error in
                    if error  == nil{
                        //Printing Saved Successfully
                        print("Saved Successfully")
                        userNameStored = userName
                        self.userUID = userUID
                        profileURL = downloadURL
                        logStatus = true
                    }
                })
            }catch{
                //Deleting Created Account In Case Of Failure
                //try await Auth.auth().currentUser?.delete()
                
                await setError(error)
            }
        }
    }
    //Display Errors Via Alert
    func setError(_ error: Error)async{
        //UI Must Be Updated On Main Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
