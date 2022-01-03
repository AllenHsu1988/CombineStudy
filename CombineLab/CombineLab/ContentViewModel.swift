//
//  ContentViewModel.swift
//  CombineLab
//
//  Created by Allen on 2021/11/26.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var itemList: [String] = []
    
    @Published var itemSet: Set<String> = []
    
    @Published var inputString: String = "" {
        didSet{
            print("text update:\(inputString)")
        }
    }
    
    @Published var outputString: String = ""

    let passThroughSubject = PassthroughSubject<String, Never>() //不儲存當前數據
    let _currentValueSubject = CurrentValueSubject<String, Never>("") //儲存當前數據
    let currentValueSubject: AnyPublisher<String, Never>
    
    let connectable = Timer.publish(every: 1000, on: .main, in: .common)
    
    init() {
        currentValueSubject = _currentValueSubject.eraseToAnyPublisher()
        
        $inputString.sink { value in
            self.outputString = "\(value)1"
        }.store(in: &cancellables)
        
        let cancellable = $inputString.sink { value in
            self.outputString = "\(value)1"
        }
        cancellable.cancel()
        
        /*
         Subscriber兩種訂閱方式
         1. sink: 在必包中處理新接收的資料
         2. assign: 直接綁定某Published<T>.Publisher
         */
        passThroughSubject.sink { (value) in
            //接收並處理資料
        }.store(in: &cancellables)
        
        /*
         outputString -> String type
         $outputString -> Published<T>.Publisher type
         &$outputString -> inout Published<T>.Publisher
         */
        passThroughSubject.assign(to: &$outputString)
    }
    
    func onTextFieldChanged(text: String) {
        inputString = text + "s"
    }
    
    func onSubmitDidPressed() {
        itemList.append(inputString)
        inputString = ""
    }
}
