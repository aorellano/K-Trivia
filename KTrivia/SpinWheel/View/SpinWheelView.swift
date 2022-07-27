import SwiftUI
import FortuneWheel
import FirebaseAuth
import Introspect

struct SpinWheelView: View {
    @StateObject var viewModel: TriviaViewModel
   // @State var group: String
    @State private var didFinishChooshingCategory: Bool = false
    @State var isActive: Bool = false
    @State var selectedCategory: String? = nil
    var players  = ["Choice", "Lyrics", "Choice", "MV", "Choice", "Song", "Performance"]
    @State var viewHasAppeared = 0
    @State var showingAlert1 = false
    @State var buttonColor: Color = Color.gray
    @State var isBlocked = false
    @State var spinEnded = false
    @State var tabBarController: UITabBarController?
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    
//    init(groupName: String, viewModel: TriviaViewModel) {
//        self.group = groupName
//        _viewModel = StateObject(wrappedValue: viewModel)
//    }
    
    init(viewModel: TriviaViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack{
            VStack {
                HStack {
                    Text("Spin the Wheel")
                        .font(.system(size: 26))
                        .fontWeight(.bold)
                        .padding(.top, -30)
                        .padding(.leading, 20)
                        Spacer()
                }
                HStack(alignment: .center, spacing: 40) {
                    VStack {
                        ProfilePictureView(profilePic: viewModel.game?.player1["profile_pic"], size: 100, cornerRadius: 100)
                       
                        Text(viewModel.game?.player1["username"] ?? "")
                            .fontWeight(.medium)
                        QuestionBombs(totalScore: Int(viewModel.game?.player1TotalScore ?? "0") ?? 0)
                            .padding(.top, -5)

                    }
                    Text("VS")
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    VStack {
                        ProfilePictureView(profilePic: viewModel.game?.player2["profile_pic"], size: 100, cornerRadius: 100)
                        Text(viewModel.game?.player2["username"] ?? "")
                            .fontWeight(.medium)
                       QuestionBombs(totalScore: Int(viewModel.game?.player2TotalScore ?? "0") ?? 0)
                            .padding(.top, -5)
                    }
                }
                .foregroundColor(.black)
                
                .padding(.top, -15)
                FortuneWheel(titles: players, size: 320, onSpinEnd: { index in
                    spinEnded = true
                    selectedCategory = players[index]
                    
                    print("The Game is about to start for \(players[index])")
                
                    viewModel.getQuestions(for: viewModel.game?.groupName ?? "", and: selectedCategory ?? "")
                    buttonColor = Color.secondaryColor
                    
                }, colors: [.red, Color.secondaryColor, .teal, .green, .red, Color.secondaryColor, .teal])
                
                .disabled(viewModel.checkForGameStatus())
                .disabled(spinEnded)
                            
                Text(viewModel.gameNotification)
            
                .padding()
                
                if viewModel.sessionService.userDetails?.id == viewModel.game?.player1["id"] {
                    if viewModel.game?.player1Score == "0" || viewModel.game?.player1Score == ""  {
                        ScoreIndicatorView(colors: [.gray, .gray, .gray])
                    } else if viewModel.game?.player1Score == "1" {
                        ScoreIndicatorView(colors: [Color.secondaryColor, .gray, .gray])
                    } else if viewModel.game?.player1Score == "2"  {
                        ScoreIndicatorView(colors: [Color.secondaryColor, Color.secondaryColor, .gray])
                    } else {
                        ScoreIndicatorView(colors: [Color.secondaryColor, Color.secondaryColor, Color.secondaryColor])
                    }
                } else {
                    if viewModel.game?.player2Score == "0" || viewModel.game?.player2Score == "" {
                        ScoreIndicatorView(colors: [.gray, .gray, .gray])
                    } else if viewModel.game?.player2Score == "1" {
                        ScoreIndicatorView(colors: [Color.secondaryColor, .gray, .gray])
                    } else if viewModel.game?.player2Score == "2"  {
                        ScoreIndicatorView(colors: [Color.secondaryColor, Color.secondaryColor, .gray])
                    } else {
                        ScoreIndicatorView(colors: [Color.secondaryColor, Color.secondaryColor, Color.secondaryColor])
                    }
                }
                NavigationLink(destination: NavigationLazyView(MultipleChoiceView( selectedCategory: selectedCategory ?? "", viewModel: viewModel)), isActive: $isActive){
//                    if selectedCategory != nil {
//                        buttonColor = Color.secondaryColor
//                    }
                    ButtonView(title: "Play", background: buttonColor) {
                        isActive = true
                    }
                    .padding()
                }.isDetailLink(false)
                    .disabled(selectedCategory == nil)
                .alert("Would you like to recieve a question bomb or challenge your opponent for their question bomb?", isPresented: $showingAlert1) {
                        Button("Recieve") { viewModel.updateTotalScore() }
                        Button("Challenge"){ print("Challenging for Question Bomb")}
                }
                
                
            }
            .foregroundColor(.black)
            .introspectTabBarController { (UITabBarController) in
                UITabBarController.tabBar.isHidden = true
                tabBarController = UITabBarController
            }
            .onAppear {
               
                selectedCategory = nil
                buttonColor = Color.gray
                viewModel.checkGameState()
                //UITabBar.appearance().isHidden = true
                
//                if viewHasAppeared == 0 && viewModel.gameId == "" && viewModel.friend.id == "" {
//                    viewModel.startRandomGame()
//                    print("starting random game")
//                    print(viewModel.friend.username)
//                } else if viewModel.gameId != "" {
//                    viewModel.resumeGame(with: viewModel.gameId)
//                    print("resuming game")
//                } else if viewModel.friend.id != "" {
//                    viewModel.startGameWithFriend()
//                    print("friend game")
//
//                }
//
                if viewHasAppeared > 0 {
                    spinEnded = false
                }
                viewHasAppeared += 1
                
                
//                if viewModel.game?.player1Score == "3" || viewModel.game?.player2Score == "3" && viewModel.reachedEnd != true {
//                    print("gonna show this")
//                    showingAlert1.toggle()
//                }
                

            }
            if viewModel.gameNotification == GameNotfication.gameHasFinished {
                VisualEffectView(effect: UIBlurEffect(style: .light))
                    .ignoresSafeArea()
                ResultsView(viewModel: viewModel)
                    .cornerRadius(30)
                    .frame(width: 350, height: 550)
                   
                Text("X")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .padding(.leading, 280)
                    .padding(.bottom, 475)
                    
                    .onTapGesture {
                        viewModel.deleteGame()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        
                    }
            }
            
            

            //.padding(.top, -50)

        
//        .environment(\.rootPresentationMode, self.$isActive)
//        .navigationViewStyle(StackNavigationViewStyle())
    }

    //.frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.white)
        

    }
     
}

//struct SpinWheel_Previews: PreviewProvider {
//    static var previews: some View {
//        SpinWheelView(groupName: "Twice", viewModel: SpinWheelViewModel(groupName: "Twice", sessionService: SessionServiceImpl()))
//    }
//}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
