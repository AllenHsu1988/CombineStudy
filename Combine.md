Combine:
Applying the $ prefix to a property wrapped value returns its projectedValue

SwiftUI:
State
StateObject
Binding
ObjectBinding
EnvironmentObject
ObservedObject

Combine:
Published & Publisher


SwiftUI:
1.
State:
A property wrapper type that can read and write a value managed by SwiftUI.
var projectedValue: Binding<Value>

如同Compose，Apple官方建議State所屬範圍應局限於單個View，也就是任為State應被設定為private value
實際儲存value
2.
Binding:
A property wrapper type that can read and write a value owned by a source of truth
var projectedValue: Binding<Value>

只為一個綁定的通道，"並沒有實際的儲存value"，通常應用於parent view帶給child view的State (parent顯示slide value, slider綁定binder後set/get)

/*
//Child view
struct PlayButton: View {
    //透過Binding set/get value，但實際value由parent擁有
    @Binding var isPlaying: Bool

    var body: some View {
        Button(action: {
            self.isPlaying.toggle()
        }) {
            Image(systemName: isPlaying ? "pause.circle" : "play.circle")
        }
    }
}

//Parent view
struct PlayerView: View {
    var episode: Episode
    @State private var isPlaying: Bool = false

    var body: some View {
        VStack {
            Text(episode.title)
            Text(episode.showTitle)
            PlayButton(isPlaying: $isPlaying)
        }
    }
}
*/

Combine:

Combine expect schedulers to operate as serial queues

1. 
$ = projectedValue
The `projectedValue` is the property accessed with the `$` operator.

2. Published
projectedValue = Published<Value>.Publisher

Publishing a property with the `@Published` attribute creates a publisher of this type
Important: The `@Published` attribute is class constrained. Use it with properties of classes, not with non-class types like structures.

Published
對於一般類別的修飾詞，添加後會擁有Publish的特性
    - Subject
        - PassthroughSubject -> 類似Flow (?) 不會保存值，透過send發射value, suitable for event like tap action
        - CurrentValueSubject -> 類似LiveData，有實際的value保存值，suitable for state

Publisher
    具體實作通知subsciber的類別

Publishers
    map, debounce, throttle等等

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