//
//  ContentView.swift
//  DungeonDice
//
//  Created by Christopher Kennedy on 2/17/23.
//

import SwiftUI

struct ContentView: View {
    enum Dice: Int, CaseIterable{
        case four = 4
        case six = 6
        case eight = 8
        case ten = 10
        case twelve = 12
        case twenty = 20
        case hundred = 100
        
        func roll() -> Int{
            return Int.random(in: 1...self.rawValue)
        }
    }
    @State private var resultMessage = ""
    @State private var buttonsLeftOver = 0
    let horizontalPadding: CGFloat =  16
    let spacing: CGFloat = 0
    let buttonWidth: CGFloat = 104
    var body: some View {
        GeometryReader{geo in
            VStack {
                titleView
                
                Spacer()
                
                resultMessageView
                
                Spacer()
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: buttonWidth), spacing: spacing)]){
                    ForEach(Dice.allCases.dropLast(buttonsLeftOver), id: \.self) { dice in
                        Button("\(dice.rawValue)-sided"){
                            resultMessage = "You rolled a \(dice.roll()) on a \(dice.rawValue)-sided dice"
                        }
                        .frame(width: buttonWidth)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
                HStack{
                    ForEach(Dice.allCases.suffix(buttonsLeftOver), id: \.self){ dice in
                        Button("\(dice.rawValue)-sided"){
                            resultMessage = "You rolled a \(dice.roll()) on a \(dice.rawValue)-sided dice"
                        }
                        .frame(width: buttonWidth)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
            .padding()
            .onChange(of: geo.size.width){ newValue in
                arrangeGridItems(deviceWidth: geo.size.width)
            }
            .onAppear{
                arrangeGridItems(deviceWidth: geo.size.width)
            }
        }
    }
    func arrangeGridItems(deviceWidth: CGFloat){
        var screenWidth = deviceWidth - horizontalPadding
        if Dice.allCases.count > 1{
            screenWidth += spacing
        }
        let numberOfButtonsPerRow = Int(screenWidth) / Int(buttonWidth + spacing)
        buttonsLeftOver = Dice.allCases.count % numberOfButtonsPerRow
    }
}

extension ContentView{
    private var titleView: some View{
        Text("Dungeon Dice")
            .font(.largeTitle)
            .fontWeight(.black)
            .foregroundColor(.red)
    }
    private var resultMessageView: some View{
        Text(resultMessage)
            .font(.largeTitle)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .frame(height: 150)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
