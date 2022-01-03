//
//  ContentView.swift
//  CombineLab
//
//  Created by Allen on 2021/11/26.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel()
    
    @State var buttonEnabled: Bool = true
    
    @State var itemList: [String] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.outputString)
                .padding()
            /*
             $viewModel.inputString: Binding<String>
             
             Binding (SwiftUI):
             A property wrapper type that can read and write a value owned by a source of truth
             */
            TextField("你的名字", text: $viewModel.inputString)
                .padding()
            Button(action: {
                viewModel.onSubmitDidPressed()
            }, label: {
                Text("Submit")
            }).onChange(of: self.viewModel.inputString, perform: { value in
                print("onChange\(value)")
            })
        }
        
        List(itemList, id: \.self) { item in
            Text("\(item)")
        }.onReceive(viewModel.$itemList) { it in //viewModel.$itemList: Published<[String]>.Publisher
            itemList = it
        }
        
        /*
         onChange vs onReceive
         onReceive invokes when initial view
         */
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
