### Delegate và callback trong iOS swift
Bài viết được dich từ [nguồn](https://www.bobthedeveloper.io/blog/the-delegate-and-callbacks-in-ios)

#### Câu chuyện của tôi 

Tôi đã từng tin rằng thế giới lập trình là một nơi hiền lành dịu dàng, nơi các đoạn mã được thực hiện từ trên xuống ( Top to bottom) 

```swift 
print("Hello, world")
print("Life is great")
print("How are you?")
```

Tuy nhiên khônng lâu sau đó, tôi đã khám phá ra rằng chúng ta không sống trong thế giới lý tưởng như ta từng nghĩ. Chúng ta có thể phải thực hiện sau một hàm khác.

Tình trạng này thường xảy ra khi bạn làm việc với các tác vụ giao diện người dùng như là ấn một button để kết nối với server.

```swift 
func likePost() {
  // increase "likes" by one
}
```

Chúng ta hãy cùng tạo một `IBAction` cái sẽ chịu trách nhiệm gọi hàm `likePost` khi chúng ta ấn vào button.

```swift 
class MyViewController: UIViewController {  
  @IBAction func didPressLikeButton(sender: UIButton) {
    likePost() // increase like in database/coredata
  }
}
```

Có một chú ý, `likePost` thì được gọi bất cứ khi nào người dùng ấn button. Người dùng có thể spam nó or đợi 30 phút. Hãy nhìn vào hình vẽ dưới đây.

### ---tab---1s---tab---2s---tab---300s---tab--->

Chúng ta có thể khai báo theo một cách khác như sau:

### ---tab---other-tasks---tab---other-tasks---tab--->

- Sự giống nhau: Đoạn mã bất đồng bộ thì giống như việc bạn chờ đợi trong nhà hàng. Khi mà khách hàng gọi món ( ấn button)., Người khách hàng sẽ không phải chờ cả ngày đến khi bếp làm xong món đó. Thay vào đó, Anh/ cô ấy có thể thực hiện các nhiệm vụ khác trong khi chờ bếp làm xong món đó như là làm sạch đĩa hoặc phục vụ món khác. ..

Bạn có thể tìm hiểu thêm về async và sync theo dưới đây

 - [Intro to Grand Dispatch Central in Swift with Bob](https://www.bobthedeveloper.io/blog/intro-to-grand-central-dispatch-in-swift-with-bob)
 - [UI and Network like a boss in Swift](https://www.bobthedeveloper.io/blog/ui-&-networking-like-a-boss-in-swift)

### Điều kiện tiên quyết

Trước khi bắt đầu, thì tutorial này dành cho những developer đã có kinh nghiệm. Những người mà thường xuyên làm việc với `closure` và hiểu rõ cơ chế làm việc của delegate/data source. Nếu bạn chưa có kinh nghiệm với những thứ tôi về kể trên thì hãy bỏ qua bài này và tìm hiểu những mục sau đây.
 - [The complete understand of delegate in Swift](https://www.bobthedeveloper.io/blog/the-complete-understanding-of-swift-delegate-and-data-source)
 - [Completion Handlers in Swift with Bob](https://www.bobthedeveloper.io/blog/completion-handlers-in-swift-with-bob)

Bên cạnh đó, bạn nên có chút kiến thức vê quản lý bộ nhớ ARC(Automatic referencing count) 

## Delegate vs Closure

Theo như tiêu đề, trong lập trình iOS chúng ta có hai cách chính để xử lý bất động bộ đó là 

1: Dlegate 
2: Closure

Note: Chúng ta không kể đến ở đây những cách như `KVO, property observers, notification, sequence, target-action.`

Ở trong tutorial này chúng ta sẽ cùng thảo luận những ưu điểm và nhược điểm của từng cách và có thể giúp bạn quyết định sử dụng cách nào trong khi xử lý bất đồng bộ. Tuy nhiên, dù gì thì bài viết này chỉ là quản điểm cá nhân được đưa ra.

### Delegate

Các kỹ sư đầu tiên của Apple thì từng yêu thích Delegate partent cho việc xử lý các tác vụ bất đồng bộ. ]

** Note : ** Chúng tôi sẽ không giải thích cách làm việc của delegate partent trong tutorial này. Chúng tôi đã đề cập đến nó trong bài viết trước kia. 

#### Design Protocol

Đầu tiên chúng ta sẽ sử dùng một Protocol sẽ được sử dụng như một kiểu mà `UIViewController` sẽ phải tuân theo. 
Chúng tôi có sử dụng ví dụ từ [Why you shouldn’t use delegates in Swift](https://medium.cobeisfresh.com/why-you-shouldn-t-use-delegates-in-swift-7ef808a7f16b) của Marin. 

```swift 
protocol NetworkServiceDelegate {
    func didComplete(result: String)
}
```

### Design Delegator/Sender

Chúng ta hãy cùng tạo class mà sẽ chịu trách nhiệm lấy data từ server.

```swift
class NetworkService {
    var delegate: NetworkServiceDelegate?

    func fetchDataFromUrl(url: String) {
        API.request(.GET, url) { result in
            delegate?.didCompleteRequest(result)
        }
    }
}
```

Phương thức `fetchDataFromUrl()` sẽ được thực hiện bởi `NetworkService`. Khi mà tiên trình hoàn thành , nó sẽ gọi method `didComplete()` từ delegate.

### Design Delegate/Receiver

Bây giờ chúng ta hãy xem mối quan hệ sau:

```swift
class MyViewController: UIViewController, NetworkServiceDelegate {

    let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.delegate = self
    }

    func didCompleteRequest(result: String) {
        print("I got \(result) from the server!")
    }
}
```

Bây giờ chúng ta hãy ấn button:

```swift
@IBAction func didPressButton(sender: UIButton) {
   networkService.fetchDataFromUrl("http://localhost:4000/user")
}
```

Phương thức `didComplete()` thì được gọi bởi `Delegator` và bạn có thể truy cập vào kết quả của request ở bên trong `ViewController.`

Tuyệt vời, đến đây bạn đã biết được cách làm sao truyền dữ liệu giữa hai đống tượng thông qua delegate.

### Retain Cycle

Tuy nhiên ở đây có một liên kết mạnh(strong reference). Thứ nhất, `ViewController` thì có thuộc tính của `NetworkService`. Thứ hai, `NetworkService` thì chứa một thuộc tính delegate được gán bới `ViewController`.

Để ngăn chặn điều này xảy ra bạn phải khai báo delegate theo liên kết yếu [weak]

```swift
weak var delegate: NetworkServiceDelegate?
```
và 

```swift
protocol NetworkServiceDelegate: class {
    func didComplete(result: String)
}
```

Nếu bạn không hiểu những gì tôi vừa nêu ra trên đây thì hãy dừng lại. Bài viết này dành cho những developer đã có kinh nghiệm.

### Closure

Bây giờ chúng ta hãy cùng so sánh với cách dùng closure/callback.

#### Design Network Service

Thay vào sử dụng delegate và protocol. Bạn chỉ cần tạo một optional closure gọi là `onComplete`. Closure này chỉ thực hiện khi bạn đã nhận được call back từ API.request

```swift
class NetworkService {

    var onComplete: ((result: String)->())?

    func fetchDataFromUrl(url: String) {
        API.request(.GET, url) { result in
            onComplete?(result: result)
        }
    }
}
```

Ở trong Controller.

```swift
class MyViewController: UIViewController {

    let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.onComplete = { result in
            print("I got \(result) from the server!")
        }
    }

}
```

Nhận dữ liệu khi ấn button.

```swift
@IBAction func didPressButton(sender: UIButton) {
 networkService.fetchDataFromUrl("http://localhost:4000/user")
}
```

Closure thì là cách cho phép bạn sử dùng `onComplete` function thay cho tạo một function bên trong `ViewController`. Often times, those delegate functions are organized in a way that you can't follow. Just think about those delegate functions within UITableview to handle the user interaction.

### So sánh.

#### Độ dài và Liên kết 
Sử dụng closure thì ngắn hơn. Khi bạn làm việc với delegate, bạn phải implement các function được yêu cầu để phù hợp với delegate.

Khi bạn sử dụng closure, thậm chí nếu `networkService` object gọi phương thức của nó. Thì bạn cũng có thể bỏ qua nó ở trong `ViewController`. Mặc dùn. closure thì thường được gọi . Và liên kết giữa closure vs controller thì thường khá yếu và mỏng manh.

Một số người có ý kiến rằng có thể làm function của delegate protocol là optional. Khi đó chúng sẽ trông như dưới đây.

```swift
@objc protocol MyProtocol {
    @objc optional func doSomething()
}
```

Thực sự là chúng trông không dễ nhìn một chút nào. Closure win. 

#### Quảy lý bộ nhớ.

Khi nói đến quản lý bộ nhớ, bạn phải định nghĩa protocol như class và định nghĩa delegate property `weak` để ngăn chặn retain cycle. 

Khi bạn làm việc với slosure, bạn phải định nghĩa `self` hoặc `unowned` hoặc `weak`. Nếu bạn không sử dụng self, bạn không phải lo về retain cycle.

Ở trong trường hợp này thì cả 2 đền wif. 

#### Backward Communication

Nếu bạn muốn liên lạc trở lại với `NetworkService`, sử dụng delegate, bạn phải dử dụng datasource partent và trả về giá trị như bên dưới.


```swift
func didCompleteRequest(result: String) -> String {
  print("Thanks for the data")
}
```

Nếu bạn muốn sử dụng closure thì bạn phải trả về giá trị đó trong complete.

```swift 
var onComplete: ((result: String)->(String))? // return `String`
networkService.onComplete = { result in
    return "Thank you for helping, network object!"
}
```

Great, không có khá nhiều khác biệt giữa hai cách. Both win.

#### Dryness

Nếu bạn muốn implement một vài delegate protocol khác. Đoạn code của bạn sẽ trông như sau:

```swift 
extension MYViewController: UIViewController, GoogleMapDelegate, GoogleMapDataSource, UITableView, ... {

  let gooleMap = GoogleMap()
  let tableView = UITableView()
  let anotherObject = UIAnotherClass()

  override func viewDidLoad() {
      super.viewDidLoad()
      gooleMap.delegate = self
      tableView.delegate = self
      anotherObject.delegate = self
      }

   }

   func cellForRowAt indexPath: IndexPath) -> UITableViewCell {}
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {}

   // ...
   // ...
   // loads of other delegate functions 
   // that will make you doomed 
}
```

Đoạn code trên thì trông có vẻ có mùi gì đó và bạn sẽ phải tốn khá nhiều thời gian để track và debug lỗi. Tuy nhiên, nếu bạn sử dụng closure thì:

```swift

extension MYViewController {

  let gooleMap = GoogleMaps()
  let tableView = UITableView()
  let anotherObject = UIAnotherClass()

  override func viewDidLoad() {
    super.viewDidLoad()

    googleMap.getCurrentLocation = { location in
      print("Yay, I'm \(location")
    }
  }
}
```

Tuy nhiên `getCurrentLocation` thì là optional, vì vậy bạn không cần phải nhất thiết implement nó. 
Closure is win.

### Tổng kết

Theo những phân tích ở phía trên thì closure dành chiến thắng ở hầu hết trường hợp. Đó cũng là lý do tại sao một vài nền tảng khác bắt đầu chuyển từ delegate sang sử dụng closure. 

### Những nên tảng khác xử lý callback như thế nào.

#### RxSwift 
Chúng ta hãy xem RxSwift xử lý bất đồng bộ như thế nào. 

```swift
buttton.rx.tap
     .debounce(1.0, scheduler: MainScheduler.instance)
     .subscribe(){ event in print("The user pressed the button!") }
     .addDisposableTo(disposeBag)
```

### Swift thì sử dụng cách nào. 

Như tôi đã nói từ đầu, API của swift thì sử dụng cả delegate và closure. Tuy nhiên có một vài sự thay đổi nhỏ gần đây. Ví dụ ở 
`UIAlerView`. Trong quá khứ, thì được định nghĩa protocol gọi là `UIAlertViewDelegate`  cái xử lý hành đọng của user. Tuy nhiên nó đã được huỷ bỏ từ iOS 8.

Hiện tại. thì AlertView API thay vào đó sử dụng closure để nhận các hành động từ người dùng. 

### Tổng kết. 

Đúng vậy, thế giới đang dịch tuyển theo hướng sử dụng closure thay vì `Delegate`. Tuy nhiên, Delegate thì sẽ không dễ dàng bi loại bỏ bởi vì `UIViewController` is là delegate của operation system nó chỉ là không có protocol.

Những method như là `viewDidLoad`, `viewDidApear` thì được quản lý bới UIApplication

Delegate pattern thì là không thể tránh khỏi nếu bạn muón một object được quản lý bởi máy tính, khôgn phải con ngươi. Nó thì áp dụng cho front-end dev và android dev.

Có thể bạn sẽ phải sử dụng delegate or closure để xử lý bất đồng bộ. Tuy nhiên bây giờ thì bạn có thể hiểu tại sao bây giờ lại đang dịch chuyển từ delegate sang closure. 

Một vài thư viện khác như RxSwift, `then`, `Async` .. cho việc xử lý bất đồng bộ. Họ cung cấp các phương thức cho việc xử lý những sự kiện bất đồng bộ. Chỉ có một điều bạn cần ghi nhớ đó là tất cả họ thì sử dụng closure or delegate để xử lý các sự kiện bất đồng bộ. 





