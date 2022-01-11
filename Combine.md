# Combine:
Applying the $ prefix to a property wrapped value returns its projectedValue

## Publisher, Operator, Subscriber:
```Swift
    +------------------+      +--------------+      +------------------+        
    |     Publisher    |      |   Opertaor   |      |    Subscriber    |        
    |                  |      |              |      |                  |        
    |     <Output>     |----->|              |----->|     <Input>      |        
    |     <Failure>    |----->|              |----->|     <Failure>    |        
    +------------------+      +--------------+      +------------------+ 
```

#### Publisher:
具體實作通知subsciber的類別

#### Operator (Publishers):
map, debounce, throttle等等

#### Subscriber:
訂閱者，接收最後送出的數據


### Convenience Publishers:
#### Just:
發射一個值，並且結束
#### Empty:
不發射值，在initial時給予completeImmediately: Bool，假如為true則在subscribe時發送complete，反之則永遠不發送complete
#### Fail:
不發射值，於subscribe時發送Failure，在initial時給予error
#### Future:
發射一個值，並且complete或failure
#### Deferred:
在initial closure提供subscriber publisher

## PropertyWrapper
### projectedValue
    $
The `projectedValue` is the property accessed with the `$` operator.

## @Published
Publishing a property with the `@Published` attribute creates a publisher of this type  
Important: The `@Published` attribute is class constrained. Use it with properties of classes, not with non-class types like structures.

```Swift
@Published var someString: String = ""
$someString -> Published<Value>.Publisher
```

- Subject
    - PassthroughSubject -> 類似Flow (?) 不會保存值，透過send發射value, suitable for event like tap action
    - CurrentValueSubject -> 類似LiveData，有實際的value保存值，suitable for state

AnyPublisher  
    Publisher 的具體實現，其本身沒有任何重要的屬性，並且會傳遞來自其上游發布者的元素和完成值  
currentValuePublisher = _currentValueSubject.eraseToAnyPublisher()  


Published  
@Published var inputString: String = ""  

## subscribe on vs receive on
    /// In contrast with ``Publisher/receive(on:options:)``, which affects downstream messages, ``Publisher/subscribe(on:options:)``
    /// changes the execution context of upstream messages.
如同官方文件所說，subscribeOn影響的對象為upstream，receiveOn影響的為downstream
### subscribeOn
Specifies the scheduler on which to perform subscribe, cancel, and request operations.  
subscribeOn影響的部分有subscribe、cancel、還有request operation，比如：
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

### receiveOn
Specifies the scheduler on which to receive elements from the publisher.  
receiveOn影響的部分為下游
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

Combine expect schedulers to operate as serial queues


Ref:
https://www.appypie.com/observedobject-published-swiftui-how-to 

[State vs Binding] https://medium.com/if-let-swift-programming/swiftui-state-and-binding-5d45ed33f323

[Observe State changed] https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange
https://www.calincrist.com/blog/2020-04-12-how-to-get-notified-for-changes-in-swiftui/

[Publisher與 Subscriber 的 Lifecycle + 彈珠圖] https://ithelp.ithome.com.tw/articles/10217930