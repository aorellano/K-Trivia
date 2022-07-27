//
//  GameOption.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/12/22.
//

import SwiftUI

struct GameOption: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>

    @StateObject var viewModel: UsersViewModel
    @State var isActive = false
    @State var buttonColor = Color.gray
//    @State var user: UserInfo?
//                    let users = UserInfo(id: "J3B50hAQClczwhv9vsSPHw4uRJF2", profile_pic: "https://firebasestorage.googleapis.com:443/v0/b/ktrivia-2d450.appspot.com/o/J3B50hAQClczwhv9vsSPHw4uRJF2?alt=media&token=dc674710-24de-41de-9213-dc5be942377a", username: "Coco")

    init(viewModel: UsersViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
//        if user != UserInfo(id: "", profile_pic: "", username: "") {
////                                NavigationLink(destination: TriviaView(groupName: selectedCategory ?? "", viewModel: TriviaViewModel(groupName: selectedCategory ?? "", session: sessionService)), isActive: $isActive) {
////                                        EmptyView()
////                                }.isDetailLink(false)
//            NavigationLink(destination: NavigationLazyView(CategoryListView(user:user ?? UserInfo(id: "", profile_pic: "", username: ""))).environmentObject(sessionService), isActive: $isActive) {
//                                                    EmptyView()
//            }.isDetailLink(false)
//        }
        VStack {
            HStack {
                Title(text: "Game Options", size: 30)
                    .padding(.leading, 25)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.top, -40)
            Text("Choose a player")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .padding(.top, 40)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                ForEach(viewModel.users, id: \.id) { info in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .foregroundColor(Color.secondaryColor)
                            .frame(width: 125, height: 180)
                            .shadow(radius: 4, x: 1, y: 1)

                        VStack {
                            Text(info.username)
                                .fontWeight(.bold)
                            ProfilePictureView(profilePic: info.profilePic, size: 80, cornerRadius: 40)
                        }
                    }
                    .onTapGesture {

//                        self.user = UserInfo(id: info.id, profile_pic: info.profilePic, username: info.username)

                        isActive = true

                    }
                    .foregroundColor(.white)
                }
            }
            }
            .padding()
            Spacer()


            ButtonView(title: "Random Player", background: Color.secondaryColor) {
                   // self.user = UserInfo(id: "", profile_pic: "", username: "x")
                    isActive = true
            }
                .padding()


        }.onAppear {
            //viewModel.getUsers()
        }
        .foregroundColor(.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//struct GameOption_Previews: PreviewProvider {
//    static var previews: some View {
//        GameOption()
//    }
//}
