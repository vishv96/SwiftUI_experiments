//
//  QuestionaireView.swift
//  Questionare
//
//  Created by Vishnu on 2021-10-01.
//

import SwiftUI

struct Question:Equatable{
    
    var id:Int
    var question:String
    var options:[Option]
    var offset:CGFloat
    
    struct Option:Equatable{
        var id:Int
        var option:String
    }
}

struct QuestionaireView: View {
    
    @State var questions:[Question] = [
        Question(id: 0,
                 question: "Question1",
                 options: [
                    .init(id: 1, option: "Option 1"),
                    .init(id: 2, option: "Option 2"),
                    .init(id: 3, option: "Option 2"),
                    .init(id: 4, option: "Option 2"),
                    .init(id: 5, option: "Option 2")
                 ], offset: 0),
        Question(id: 1,
                 question: "Question2",
                 options: [
                    .init(id: 1, option: "Option 1"),
                    .init(id: 2, option: "Option 2")
                 ], offset: 0),
        Question(id: 2,
                 question: "Question3",
                 options: [
                    .init(id: 1, option: "Option 1"),
                    .init(id: 2, option: "Option 2")
                 ], offset: 0),
        Question(id: 3,
                 question: "Question4",
                 options: [
                    .init(id: 1, option: "Option 1"),
                    .init(id: 2, option: "Option 2")
                 ], offset: 0),
        Question(id: 4,
                 question: "Question5",
                 options: [
                    .init(id: 1, option: "Option 1"),
                    .init(id: 2, option: "Option 2")
                 ], offset: 0)
    ]
    
    @State private var anseredQuestions = [Question]()
    
    @State private var swiped:Int = 0
    
    var questionStatus:String{
        return "Question \(swiped)/\(questions.count)"
    }
    
    var body: some View {
        ZStack{
            Color(UIColor(displayP3Red: 63/255, green: 38/255, blue: 105/255, alpha: 1)).ignoresSafeArea()
            VStack{
                topView()
                
                // Question status
                HStack{
                    Text(questionStatus)
                    Spacer()
                }
                .foregroundColor(.white)
                .frame(maxWidth:.infinity)
                .padding(.top)
                
                // Progress
                ProgressBar(swiped:$swiped, questionsCount: questions.count)
                
                Text("")
                
                ZStack {
                    ForEach(questions.reversed(), id:\.id){ _question in
                        // Card
                        QuestionCard(question: _question, swiped: $swiped)
                            .offset(x:_question.offset)
                            .rotationEffect(.init(degrees: getRotation(offset: _question.offset)))
                            .gesture(
                                DragGesture()
                                    .onChanged{ value in
                                        withAnimation {
                                            questions[_question.id].offset = value.translation.width
                                        }
                                    }
                                    .onEnded{ value in
                                        withAnimation {
                                            if value.translation.width > 150{
                                                questions[_question.id].offset = 1000
                                                swiped = _question.id + 1
                                            }else{
                                                questions[_question.id].offset = 0
                                            }
                                        }
                                    }
                            )
                    }
                }
                
                Spacer()
            }.padding()
                .padding([.leading,.trailing])
        }
        .font(.custom("Inter-Light", size: 20))
    }
    
    // Get rotation value
    func getRotation(offset:CGFloat) -> CGFloat{
        let value = offset / 150
        let angle:CGFloat = 10
        let degree = Double(value * angle)
        return degree
    }
    
    @ViewBuilder
    func topView() -> some View{
        HStack{
            Button {
                
            } label: {
                Image(systemName: "arrow.left").resizable().frame(width: 20, height: 20)
            }
            Spacer()
            Text("Test")
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
            }
        }
        .frame(maxWidth:.infinity)
        .foregroundColor(.white)
    }
}




//MARK:- Question Card
struct QuestionCard: View {
    let question:Question
    @Binding var swiped:Int
    
    @State private var selctedOption:Question.Option = .init(id: -2, option: "")
    
    var body: some View {
        ZStack{
            Color.white
            VStack{
                
                VStack{
                    HStack{
                        Text("Select an answer")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(Color(UIColor.systemGray3))
                        Spacer()
                    }
                    HStack{
                        Text(question.question)
                            .font(.callout)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.top,8)
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                
                ScrollView(.vertical){
                    VStack {
                        
                        // Options
                        ForEach(question.options, id:\.id){ option in
                            OptionView(selctedOption: $selctedOption,
                                       option: option)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                }
                
                
                Spacer()
                
                // Next button
                HStack{
                    Spacer()
                    Button {
                        // Next action
                        
                    } label: {
                        HStack{
                            Text("Next")
                                .font(
                                    .system(size: 18,
                                            weight: .semibold,
                                            design: .rounded)
                                )
                            Image(systemName: "chevron.forward")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal,8)
                        .background(Color(UIColor(red: 230/255, green: 143/255, blue: 67/255, alpha: 1)))
                        .cornerRadius(16)
                    }
                    .padding()
                    .padding(.bottom)
                }
                
            }
        }
        .cornerRadius(12)
        .padding(.top)
        .frame(maxHeight:500)
        .padding(.horizontal, (CGFloat(question.id - swiped)*10))
        .offset(y: (question.id - swiped ) <= 3 ? CGFloat(question.id - swiped)*25 : 50)
        .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 5)
        .contentShape(Rectangle())

    }
}


//MARK: Question option view
struct OptionView:View{
    
    @Binding var selctedOption:Question.Option
    var option:Question.Option
    
    var body: some View{
        VStack{
            HStack{
                // Rounded mark
                roundMark()
            
                Text(option.option)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .padding()
                    .offset(x:selctedOption == option ? 0 : -50)
                Spacer()
            }
            .background(
                (selctedOption == option ) ? Color(UIColor(red: 230/255, green: 143/255, blue: 67/255, alpha: 1)) : Color.white
            )
            .foregroundColor(  (selctedOption == option ) ? .white :  Color(UIColor.systemGray))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(UIColor.systemGray4), lineWidth: (selctedOption == option ) ? 0 : 1)
            )
            .onTapGesture {
                withAnimation(Animation.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5)){
                    selctedOption = option
                }
            }
        }.padding(.top)
    }
    
    func roundMark() -> some View{
        ZStack{
            Image(systemName: "checkmark").resizable().padding(8)
        }
        .frame(width: 30, height: 30)
        .background(
            Color(UIColor(red: 201/255, green: 124/255, blue: 58/255, alpha: 1))
        )
        .clipShape(Circle())
        .padding(.leading)
        .offset(x:selctedOption == option ? 0 : -200)
    }
}


//
//MARK:- Progress bar
struct ProgressBar: View {
    @Binding var swiped:Int
    var questionsCount:Int
    @State var prgz:CGFloat = 0
    var body: some View {
        ZStack(alignment:.leading){
            Color.orange.frame(width:prgz)
            Color.gray.opacity(0.3)
        }
        .frame(width: 300)
        .frame(height: 10)
        .cornerRadius(5)
        .onChange(of: swiped) { newValue in
            let perc:CGFloat = CGFloat(newValue) / CGFloat(questionsCount)
            prgz = CGFloat(300) * perc
            print(prgz)

        }
    }
}


struct QuestionaireView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionaireView()
    }
}
