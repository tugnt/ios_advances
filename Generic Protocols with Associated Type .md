Bài viết được dịch từ [Nguồn](https://www.bobthedeveloper.io/blog/generic-protocols-with-associated-type)

### Giới thiệu
Bạn đã bắt đầu học Protocol và bạn bắt đầu yêu thích nó. Một ngày, bạn nghe được một vài từ kiểu như `Associated Type` hay `Type eraser`. Bạn tự nghĩ nó là cái méo gì vậy. Đừng lo, đó là lý do tôi viết bài này. 

#### Mục tiêu 
Chúng ta có hai mục tiêu. Chúng ta sẽ học làm thế nào để tạo một protocol vs `Associated type`. Sử dụng `where` để rằng buộc các điều kiện của generic. 

#### Điều khoản thứ nhất
Ngôn ngữ Swift thì là một ngôn ngữ type-safe. Nó có nghĩa là bạn phải khai báo và định nghĩa trước khi được compile. 

#### Review
Trước khi chúng ta bắt đầu thảo luận về `Generic Protocol`, bạn hãy xem qua ví dụ dưới đây. 

```swift
struct GenericStruct<T> {
    var property: T?
}
```

Tôi có thể khai báo tường minh kiểu Generic T như sau, or có thể Swift sẽ dựa theo giá trị.


#### Normal Protocol 
Trước khi đánh giá `Generic Protocol` chúng ta hãy nhìn vào quá khứ của bạn. Hãy tạo một protocol mà yêu cầu bạn thêm một `property` như là `String`

#### Định nghĩa `Protocol`

```swift
protocol NOrmalProtocol {
  var property: String { get set }
}
```

#### Design class and Conform

```swift 
class NormalClass: NormalProtocol {
  var property: String = "TD"
}
```

Trông có vẻ ổn. Tuy nhiên, `NormalProtocol` bắt buộc `NormalClass` sử dụng `String `. Tuy nhiên nếu chúng ta muốn làm việc với `Int` or `Bool` thì sao?

Đó chính là lý do tại sao chúng ta có `Protocol  Associated Type `

#### Giới thiệu về `Protocol Associated Type`

Trong `Generic Protocol`, tạo một cái gì đó như Generic <T>. Bạn sẽ cần thêm vào `associatedtype`. Bạn hãy xem qua ví dụ sau: 

```swift 
protocol GenericProtocol {
  associatedtype newType 
  var anyProperty: newType { get set } 
}
```

Bây giờ, Bất cứ cái gì conform protocol GenericProtocol đều phải  implement `anyProperty`. Tuy nhiên, type thì vẫn chưa được định nghĩa. Như trước đó tôi đã nói, class or struct cái mà conform Protocol phải định nghĩa tường minh or không tường minh biến trong protocol. 

Đầu tiên, chúng ta hãy tạo một class là `SomeClass` cái mà confrom `GenericProtocol`. Chúng ta phải định nghĩa `myType`. Okie, vậy chúng ta có hai cách định nghĩa như ở trên.

#### Định nghia không tường minh Associated Type 

Bạn có thể định nghĩa kiểu cơ bản của `newType` với anyProperty.

```swift 
class SơmeClass: GenericProtocol {
    var anyProperty: newType: = "BOB"
}
```

Bây giờ, `newType` thì đã được định nghĩa là String dựa trên giá trị là `BOB`. Tuy nhiên, swift cũng có thể đoán mặc dù bạn không khai báo kiểu dữ liệu cho `anyProperty`.


#### Định nghĩa Associated Type tường minh. 
Bạn cũng có thể định nghĩa associated type bằng cách gọi `typealias `
```swift
class SomeClass: GenericProtocl {
   typealias newType: String 
   var anyProperty: myType = "BOB"
}
```

#### Protocol Extension và TYpe Constraints

Như bạn đã biết, protocol extension thì là nơi tuyệt vời bởi vì bạn có thể implement mà không cần method or property. 

```swift 
extension GenericProtocol {
  static func introduce() {
    print("TD")
   }
}
```

Bây giờ bạn có thể sử dụng method của `GenericProtocol` như sau:

```
SomeClass.introduce() // I'm Bob
SomeStruct.introduce() // I'm Bob
```

Nhưng đột nhiên bạn chỉ muốn nếu `myType` là `String` thì mới gọi được `introduce()`.

#### Giới thiệu về điều kiện `where`

Đừng lo nếu trước kia bạn chưa từng sử dụng `where`/ Nó chỉ là cách viết ngắn hơn cho mệnh đề điều kiện `if-else`.

Bây giờ chúng ta sẽ thêm vào `introduce()` đoạn code như sau:

```swift 
extension GenericProtocol where myType == String {
 func introduce(){
  print("I'm Bob")
 }
}
```

Không cần giải thích thì bạn có thể dễ dàng hiểu được đoạn code trên dùng để làm gì. Nó có nghĩa là nếu `myType` == String thì những method trong extension đó mới có thể dùng được. 

#### Multiple Where Conditions with Self
Bạn có thể thêm vài từ `where` để làm extension thêm tường minh. Trong ví dụ này nếu ta chỉ muốn `SomeClass` sử dụng method trong extention thì làm như thế nào. Chỉ đơn giản là thêm một where vào extension như sau:

```swift 
extension GenericProtocol where type == String, Self == SomeClass {
 func introduce(){
  print("I'm Bob")
 }
}
```

Từ khoá `Self` đó chính là chỉ đến những class/struct/enum những cái mà conform `GenericProtocol`.


#### Override Associated Type

Như ở trên kia chúng ta đã không định nghĩa `associatedtype` bên trong `Generic Protocol`


```swift 
protocol GenericProtocol {
 associatedtype myType
 var anyProperty: myType { get set }
}
```

myType thì có được định nghĩa bởi những class/struct/enum conform `GenericProtocol` tuy nhiên chúng ta có thể định nghĩa trước giá trị của `newType` ở trong `GenericProtocol`.

#### Associated Type Pre-defined Protocol.

Chúng ta có thể định nghĩa kiểu của `newType` ở ngay trong protocol như sau. Khi đó ở những class/struct/enum conform protocl sẽ không phải bắt buộc định nghĩa là kiểu của `newType` nữa. Ví dụ: 

```swift 
protocol Familiable {
 associatedtype FamilyType = Int
 func getName() -> [FamilyType]
}
```

Khi đó ta sẽ sử dụng như sau: 

```swift 
class NumberFamily: Familiable {
 func getName() -> [FamilyType] {
  return [1, 2, 3]
 }
}
```

```swift 
class NumberFamily: Familiable {
 func getName() -> [Int] {
  return [1, 2, 3]
 }
}
```

Bây giờ chúng ta sẽ tạo thể hiện của NumberFamily như sau: 

```swift 
let numberFam = NumberFamily() /// // NumberFamily<Int>
```

#### Override Associated Type

Đầu tiên chúng ta sẽ tạo một struct gọi là `NormalFamily`. Nó thì sẽ conform `Familiable`. Nó có nghĩa là nó bắt buộc struct phải sử dụng `Int`. Tuy nhiên chúng ta có thể tuỳ chọn cách không sử dụng 

Nếu bạn muốn struct sử dụng String thì bạn thay `BOB ` or một cái gì đó thay cho Int. Ví dụ như sau.

```swift 
struct NormalFamily<T: ExpressibleByStringLiteral>: Familiable {
   func getName() -> [T {
      return ["Nguyen, "Trong", "Tung"]
   }
}
```

Bây giờ chúng ta sẽ tạo thể hiện.

```swift 
let normalFam = NormalFamily() /// ExpressibleByStringLiteral
```

Tại sao lại có thể. Nếu bạn giữ ấn `Option` và click vào `String` trong swift thì bạn sẽ khám phá ra. String thì conform từ `ExpressibleByStringLiteral`


```swift
// Swift Library
extension String : ExpressibleByStringLiteral {}
```

