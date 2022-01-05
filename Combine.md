# Combine:
Applying the $ prefix to a property wrapped value returns its projectedValue

### Publisher, Operator, Subscriber:
    +------------------+      +--------------+      +------------------+        
    |     Publisher    |      |   Opertaor   |      |    Subscriber    |        
    |                  |      |              |      |                  |        
    |     <Output>     |----->|              |----->|     <Input>      |        
    |     <Failure>    |----->|              |----->|     <Failure>    |        
    +------------------+      +--------------+      +------------------+ 

Publisher:
具體實作通知subsciber的類別

Operator (Publishers):
map, debounce, throttle等等

Subscriber:
訂閱者，接收最後送出的數據

Combine:

Combine expect schedulers to operate as serial queues

## PropertyWrapper
### projectedValue
    $
The `projectedValue` is the property accessed with the `$` operator.

## @Published
    @Published var someString: String = ""
projectedValue = Published<Value>.Publisher

Publishing a property with the `@Published` attribute creates a publisher of this type
Important: The `@Published` attribute is class constrained. Use it with properties of classes, not with non-class types like structures.

Published
對於一般類別的修飾詞，添加後會擁有Publish的特性
    - Subject
        - PassthroughSubject -> 類似Flow (?) 不會保存值，透過send發射value, suitable for event like tap action
        - CurrentValueSubject -> 類似LiveData，有實際的value保存值，suitable for state



AnyPublisher
    Publisher 的具體實現，其本身沒有任何重要的屬性，並且會傳遞來自其上游發布者的元素和完成值
currentValuePublisher = _currentValueSubject.eraseToAnyPublisher()


Published
@Published var inputString: String = ""




Ref:
https://www.appypie.com/observedobject-published-swiftui-how-to 

[State vs Binding] https://medium.com/if-let-swift-programming/swiftui-state-and-binding-5d45ed33f323

[Observe State changed] https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange
https://www.calincrist.com/blog/2020-04-12-how-to-get-notified-for-changes-in-swiftui/

[Publisher與 Subscriber 的 Lifecycle + 彈珠圖] https://ithelp.ithome.com.tw/articles/10217930