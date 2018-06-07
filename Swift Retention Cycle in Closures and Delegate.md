### Swift Retention Cycle in Closures and Delegate
Bài viết được dịch từ [nguồn](https://blog.bobthedeveloper.io/swift-retention-cycle-in-closures-and-delegate-836c469ef128) 

***

#### Vấn đề. 
Lần đầu tiên tôi đã gặp mọi người sử dụng [weak self] trong closure và weak var đứng trước thuộc tính của delegate. Tôi tự hỏi tại sao ?

#### Điều kiện tiên quyết. 
Cái này thì không dành cho những beginers. Bạn hãy chắc chắn rằng bạn hiểu rõ những mục dưới đây trước khi bắt đầu tiếp tục bài này:

1. Pass data between view controller with Delegate.
2. Memory management in Swift with ARC
3. Closures capture list
4. Protocol as Type 

#### Objectives
Thứ nhất, bạn sẽ học tại sao chúng tôi sử dụng weak var trong delegate. 
Thứ hai, bạn sẽ học khi nào sử dụng [weak self] và khi nào thì sử dụng [unowned self]

#### Retention Cycle in Delegate
Thứ nhất, bạn hãy tạo protocol gọi là `SendDataDelegate`
```swift
protocol SendDataDelegate: class { }
```

Sau đó bạn hãy tạo một class gọi là `SendingVC` có thuộc tính thì là loại của `SendDataDelegate?` như sau:

```swift
class SendingVC {
  var delegate: SendDataDelegate?
}
```

Sau đó chúng ta hãy gán delegate cho một class khác:

```swift 
class ReceivingVC: SendDataDelegate {
 lazy var sendingVC: SendingVC = {
  let vc = SendingVC()
  vc.delegate = self // self refers to ReceivingVC object
  return vc
 }()
deinit {
 print("I'm well gone, bruh")
 }
}
```

Có thể bạn sẽ có chút bối rối với từ khoá `lazy`. Chúng ta có thể tìm hiểu sau loạt bài này. 
Bây giờ chúng ta hãy cùng tạo thể hiện của class:

```swift
var receivingVC: ReceivingVC? = ReceivingVC()
```

#### Tóm lại 
Thứ nhất, `receivingVc` thì là khởi tạo của `ReceivingVC()`. `ReceivingVC()` thì có thuộc tính `sendingVC`
Thứ hai, `sendingVC` thì là mọt khởi toạ của `SendingVC(). `SendingVC` thì có thuộc tính `delegate`.

Ta thử tạo một graph như dưới đây:

![](https://cdn-images-1.medium.com/max/2000/1*xCtLEY2ud9Mq97S1tQPz4g.png)

Bạn chắc chắn rằng bạn hiểu rõ ý nghĩa của tham chiếu mạnh và yếu. Nếu không, bạn hãy tìm hiểu lại Make Memory Management Great again =))
Như chúng ta đã thấy, có liên kết mạnh giữa `ReceivingVC` và `SendingVC`. Nếu bạn thử đoạn code sau đây, sẽ không có gì xảy ra.

```swift 
var receivingVc = nil 
```
Chúng ta thấy hàm deinit không được gọi. Mặc dù chúng ta đã gán cho nó = nil. Lý do tại sao? Đó là tại vì vẫn còn liên kết trỏ đến nó.

#### Giới thiệu về weak var 
Điều duy nhất chúng ta cần làm là thêm `weak` vào trước `var delegate`.
```swift 
class SendingVC {
    weak var delegate: SendDataDelegate?
}
```

Hãy nên nhớ là weak luôn đi kèm với var chứ không đi kèm với `weak let` tại sao. Bởi vì khi khai báo `let` thì có nghĩa là biến đó sẽ không thay đổi được giá trị, và chúng ta sẽ không thể gán nó = nil -> Không thể deinit được. 
Sau khi thêm weak vào trước var thì chúng ta đc như sau:

![](https://cdn-images-1.medium.com/max/2000/1*y87pKaXDgoT9EfEQDbLBmg.png)

Chúng ta hãy nên nhớ, những biến `weak` thì không làm ARC tăng lên 1, khi đó thì ở log chúng ta sẽ thấy in ra dòng chữ 
```swift 
// "I'm well gone, bruh"
```
**Chú ý**: Chúng ta chỉ cần thêm weak cho `class`, Swift struct, enum thì không cần vì nó không phải là reference type mà là value type. Và chúng nó không tạo strong reference. 

#### Retention Cycle in Closures
Bây giờ chúng ta chuyển đến mục tiếp thứ hai. Mục tiêu của chúng ta là tại sao lại sử dụng [weak self] trong closure. Thứ nhất, chúng ta hãy thử tạo class tên là `BobClass`. Nó bao gồm hai thuộc tính một là String và một là Closure 

```swift
class BobClass {
 var bobClosure: (() -> ())? 
 var name = “Bob”
 init() {
  self.bobClosure = { print(“Bob the Developer”) }
 }
 deinit {
  print(“I’m gone... ☠️”)
 }
}
```


