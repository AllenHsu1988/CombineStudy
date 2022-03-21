# Combine:
Customize handling of asynchronous events by combining event-processing operators.  
iOS 13+
## Publisher, Operator, Subscriber:
```Swift
    +------------------+      +--------------+      +------------------+        
    |     Publisher    |      |   Opertaor   |      |    Subscriber    |        
    |                  |      |              |      |                  |        
    |     <Output>     |----->|              |----->|     <Input>      |        
    |     <Failure>    |----->|              |----->|     <Failure>    |        
    +------------------+      +--------------+      +------------------+ 
```

### Publisher:
具體實作通知subsciber的類別

### Operator (Publishers):
map, debounce, throttle等等

### Subscriber:
訂閱者，接收最後送出的數據
### Convenience Publishers:
 - #### Just: 發射一個值，並且結束
 - #### Empty: 不發射值，在initial時給予completeImmediately: Bool，假如為true則在subscribe時發送complete，反之則永遠不發送complete
 - #### Fail: 不發射值，於subscribe時發送Failure，在initial時給予error
 - #### Future: 發射一個值，並且complete或failure
 - #### Deferred: 在initial closure提供subscriber publisher

## PropertyWrapper
### projectedValue
```Swift
$
```
The `projectedValue` is the property accessed with the `$` operator.  
Applying the $ prefix to a property wrapped value returns its projectedValue.

## @Published
Publishing a property with the `@Published` attribute creates a publisher of this type  
Important: The `@Published` attribute is class constrained. Use it with properties of classes, not with non-class types like structures.

```Swift
@Published var someString: String = ""
$someString //Published<Value>.Publisher
```

- ### Subject
    - PassthroughSubject -> 類似Flow (?) 不會保存值，透過send發射value, suitable for event like tap action
    - CurrentValueSubject -> 類似LiveData，有實際的value保存值，suitable for state

### AnyPublisher  
Publisher 的具體實現，其本身沒有任何重要的屬性，並且會傳遞來自其上游發布者的元素和完成值   
```Swift
//使用AnyPublisher來封裝Subject，防止調用者呼叫send方法
currentValuePublisher = _currentValueSubject.eraseToAnyPublisher()  
```

## subscribe on & receive on
```Swift
/// In contrast with ``Publisher/receive(on:options:)``, which affects downstream messages, ``Publisher/subscribe(on:options:)``
/// changes the execution context of upstream messages.
```
如同官方文件所說，subscribe on影響的對象為upstream，receive on影響的為downstream
### subscribeOn
Specifies the scheduler on which to perform subscribe, cancel, and request operations.  
subscribe on影響的部分有subscribe、cancel、還有request operation，比如：
```Swift
struct SomePublisher: Publisher {
    typealias Output = String
    typealias Failure = Never
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, String == S.Input {
        debugPrint("IsMainThread: \(Thread.isMainThread)")
        //此處會因subscribeOn給的Scheduler不同而執行在不同的執行緒中
        subscriber.receive(subscription: Subscriptions.empty)
        _ = subscriber.receive("test")
    }
}
```
```Swift
Deferred { () -> Future<String, Never> in
    //還有這邊
    Future { promise in
        //以及這邊
        promise(.success(""))
    }
}
```
<b>重要: subscribeOn只有第一次使用有實際效果</b>

### receiveOn
Specifies the scheduler on which to receive elements from the publisher.  
receive on影響的部分為下游
```Swift
SomePublisher()                                        
.receive(on: backgroundQueue) // -+                  
.map { val in                 //  |                  
    //background queue        //  |  作用區域            
    val                       //  |                  
}                             // -+                  
.receive(on: mainQueue)       // -+                  
.sink { val in                //  |  作用區域            
    // main queue             //  |                  
}                             // -+   
```

## subscribe on & receive on 閱讀方式
```Swift
                                ^    Deferred { () -> Future<String, Never> in                                              
                                |        Future { promise in                                                                    
                                |            print("Subscribe: Thread:\(Thread.current)")                                       
                                |            promise(.success("abc"))                                                           
                                |        }                                                                                      
                                |    }                                                                                      
                                |    .subscribe(on: backgroundQueue)                                                        
                                |    .subscribe(on: mainQueue) //無作用                                                        
                                |    .receive(on: RunLoop.main)                                 |                           
                                |    .map { val -> String in                                    |                           
subscribe on閱讀方向             |        print("map1: Thread:\(Thread.current), val:\(val)")    |  receive on閱讀方向           
最後看到 (最先執行到）者為實際有效用  |        return "\(val)\(val)"                                  |  影響範圍為至下個receive on       
                                |    }                                                          v                           
                                |    .receive(on: backgroundQueue)                              |                           
                                |    .map { val -> String  in                                   |                           
                                |        print("map2: Thread:\(Thread.current), val:\(val)")    |                           
                                |        return "\(val)\(val)"                                  |                           
                                |    }                                                          v                           
                                |    .receive(on: DispatchQueue.main)                           |                           
                                |    .sink { val in                                             |                           
                                |        print("sink: Thread:\(Thread.current), val:\(val)")    |                           
                                |    }                                                          v                           


輸出為:
    Subscribe: Thread:<NSThread: 0x600000148740>{number = 1, name = main}
    map1: Thread:<NSThread: 0x600000148740>{number = 1, name = main}, val:abc
    map3: Thread:<NSThread: 0x600000118e80>{number = 3, name = (null)}, val:abcabc
    sink: Thread:<NSThread: 0x600000148740>{number = 1, name = main}, val:abcabcabcabc
```

Combine expect schedulers to operate as serial queues


Ref:
https://www.appypie.com/observedobject-published-swiftui-how-to 

[State vs Binding] https://medium.com/if-let-swift-programming/swiftui-state-and-binding-5d45ed33f323

[Observe State changed] https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange
https://www.calincrist.com/blog/2020-04-12-how-to-get-notified-for-changes-in-swiftui/

[Publisher與 Subscriber 的 Lifecycle + 彈珠圖] https://ithelp.ithome.com.tw/articles/10217930

[Swift — Combine Publishers] https://medium.com/jeremy-xue-s-blog/swift-combine-publishers-299a5b0e2860