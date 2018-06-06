### Functional Programing with Swift

***

Swift được giới thiệu ở WWDC năm 2014, Apple không chỉ giới thiệu nó như một ngôn ngữ mới. Nó còn mang đến một số cách tiếp cận của phát triển phần mềm cho iOS và OSX platforms.

Ở trong bài viết này chúng ta chỉ tiếp cận theo lý thuyết, và bạn sẽ được giới thiệu một loạt các ý tưởng và các kỹ thuật khác nhau trong bài viết này.

#### Bắt đầu 

Tạo mới một playground gọi là `IntroductionFunctionalPrograming `. Hãy nhớ rằng tutorial này sẽ bao gồm tất cả các FP(Functional Programing) ở mức cao. Trong trường hợp này, bạn hãy tưởng tượng đang xây dựng một ứng dụng cho công viên giải trí, và dữ liệu của chuyến đi được cung cấp bởi API trên máy chủ từ xa.

Bắt đầu code ở playground như sau:

```swift
enum RideType {
  case Family
  case Kids
  case Thrill
  case Scary
  case Relaxing
  case Water
}

struct Ride {
  let name: String
  let types: Set<RideType>
  let waitTime: Double
}
```

Chúng ta vừa tạo một `enum` tên là RideType nó cung cấp tập hợp các loại của cuộc dạo chơi(Ride). Bạn cũng có một `struct` tên là `Ride` chứ name của `Ride` , tập hợp các `Ride` và thời gian chờ hiện tại của chuyến đi là `waitTime`

Bây giờ bạn có thể nghĩ về vòng lặp như và cảm giác hồi hộp như đang trong một chuyến đi hoang dã, nhưng hãy tin tôi không có chuyến đi nào giống như việc chuyển từ một phong các lập trình khác (IP) sang Functional Programing.

#### Vậy `Functional Programing` là gì?
Ở mức cao thì phân biệt gữa functional programing và các cách tiếp cận khác trong lập trình đó là sự khác biệt giữa **imperative** và **declarative**
Vậy Imperative và Declarative là gì ?
**Imperative programming** và **Declarative programming:** là hai mô hình trong lập trình, hai mô hình trên vốn khá rộng, nhưng chúng ta có thể nói ngắn gọn nó như sau:
* **Imperative programming(IP)**: telling the “machine” how to do something, and as a result what you want to happen will happen.
* **Declarative programming(DP)**: telling the “machine” what you would like to happen, and let the computer figure out how to do it.

**IP** thường gắn liền với lập trình hướng đối tượng **OOP** mà lâu nay tôi và các bạn luôn nghĩ là tối ưu, là phương pháp hay nhất khi phát triển phần mềm. 

**Declarative Programming (DP)** hay đơn giản là một thế giới khác đối nghịch với IP mà chúng ta từng biết. 

**IP** chúng là hướng tiếp cận suy nghĩ về thuật toán hoặc các bước khi giải quyết một vấn đề, làm thế nào để đi được từ vấn đè (A) đến một giải pháp (B). Một ví dụ hoàn hảo cho IP đó là công thức cho việc nướng bánh, các bước làm như thế nào, bao nhiêu bột, nước, làm thế nào để nhào bột, làm như thế nào để nướng bánh. Các công đoạn như thế nào.

**DP** Declarative thinking analyzes a problem in terms of what the solution is, but not how to get to the solution. Take the concept of a recipe for an example. A declarative recipe would essentially show you a picture or offer a description of cupcakes, rather than tell you how to mix ingredients and how to bake them.

**FP** khuyến khích cách tiếp cận khai báo để giải quyết vấn đề thông qua các hàm. Bạn sẽ thấy sự khác biệt giữa **IP** và **DP** khi đọc xong hướng dẫn này.

#### Các khái niệm trong Functional Programing
Trong bài này tôi sẽ giới thiệu các khái niệm chính của Functional Programing. Có rất nhiều cuộc thảo luận về các khái niệm quan trọng của FP như **tính bất biến**, **hiệu ứng lề** ..vv vậy tại sao chúng ta không bắt đầu từ đó.

#### Tính bất biến và Hiệu ứng lề
Bất kể bạn đã học ngôn ngữ lập trình nào trước tiên, có thể một trong những khái niệm ban đầu bạn đã học là một biến đại diện cho dữ liệu. Nếu bạn dừng lại một lúc để thực sự nghĩ về ý tưởng, các biến có vẻ hơi kỳ quặc.

Thêm các dòng mã sau đây vào file playground của bạn:

```swift
var x = 3
x = 4
```

Nếu trước khi bạn từng phát triển phần mềm theo OOP hoặc hướng thủ tục thì bạn thấy đoạn code trên có vẻ rất bình thường. Nhưng tại sao bạn không nghĩ một biến vừa bằng 3 và sau đó lại có thể bằng 4. Nó thực sự vô lý. 

![](https://koenig-media.raywenderlich.com/uploads/2015/08/x3-678x500.png)

Biến tạm có nghĩa là biến mà số lượng có thể thay đổi. Suy nghĩ về số lượng x từ góc nhìn toán học, về cơ bản bạn đã giới thiệu `time` như một thông số quan trọng trong cách phần mềm của bạn hoạt động như thế nào. Bằng cách thay đổi biến, bạn tạo trạng thái có thể thay đổi.

Bởi chính nó hoặc trong một hệ thống tương đối đơn giản, một trạng thái có thể thay đổi không phải là vấn đề khủng khiếp. Tuy nhiên, khi kết nối nhiều đối tượng với nhau, chẳng hạn như trong một hệ thống OOP lớn, một trạng thái có thể thay đổi có thể gây ra nhiều vấn đề phiền toái.

_Ví dụ_: khi hai hoặc tiến trình truy cập **đồng thời** vào cùng một biến, chúng có thể sửa đổi biến đó dẫn đến hành vi không mong muốn. Điều này bao sẽ phát sinh các vấn đề như `race conditions, dead locks` và nhiều vấn đề khác.

Hãy tưởng tượng bạn có thể viết mã mà mà trong đó trạng thái (state) không bị thay đổi. Một loạt các vấn đề xảy ra trong các hệ thống sẽ đơn giản biến mất. Bạn có thể làm điều đó bằng cách khởi tạo các thuộc tính không thể thay đổi, hoặc dữ liệu thì không cho phép thay đổi trong chương trình. 

Trong Objc thì có thể làm điều đó bằng cách sử dụng `constant`, nhưng nếu để mặc định thì thuộc tính bạn tạo là có thể thay đổi được. Còn ở Swift thì mặc định là không thể thay đổi. 

Lợi ích chính của việc sử dụng dữ liệu không thay đổi đó là nó sẽ không phát sinh hiệu ứng lề (Side effects). Nó có nghĩa là sẽ không phát sinh những hiệu quả không mong muốn đối với những function sử dụng biến không thể thay đổi.

Bạn hãy xem ví dụ sau để hiểu rõ hơn:

```swift
let parkRides = [
  Ride(name: "Raging Rapids", types: [.Family, .Thrill, .Water], waitTime: 45.0),
  Ride(name: "Crazy Funhouse", types: [.Family], waitTime: 10.0),
  Ride(name: "Spinning Tea Cups", types: [.Kids], waitTime: 15.0),
  Ride(name: "Spooky Hollow", types: [.Scary], waitTime: 30.0),
  Ride(name: "Thunder Coaster", types: [.Family, .Thrill], waitTime: 60.0),
  Ride(name: "Grand Carousel", types: [.Family, .Kids], waitTime: 15.0),
  Ride(name: "Bumper Boats", types: [.Family, .Water], waitTime: 25.0),
  Ride(name: "Mountain Railroad", types: [.Family, .Relaxing], waitTime: 0.0)
]
```

Khi bạn tạo mảng `parkRides` sử dụng từ khoá `let` thay cho `var` có nghĩa là bạn đã tạo một mảng không thể thay đổi. Chúng ta thử cố thay đổi phần tử thứ nhất của mảng trên xem như thế nào. Yên tâm, chắc chắn sẽ lỗi =))

```swift
parkRides[0] = Ride(name: "Functional Programming", types: [.Thrill], waitTime: 5.0)
```

#### Tính module
Bây giờ chúng ta hãy cùng nhau tạo function đầu tiên, và bạn sẽ cần sử dụng một số function của `NSString` trong Swift. Vì vậy bạn sẽ cần phải import `Foundation` framework. Giả sử bạn cần sắp xếp theo abc theo tên của rides. Theo cách tiếp cập IP thì chúng ta sẽ làm như sau

```swift
func sortedNames(rides: [Ride]) -> [String] {
  var sortedRides = rides
  var i, j : Int
  var key: Ride

  // 1
  for (i = 0; i < sortedRides.count; i++) {
    key = sortedRides[i]

    // 2
    for (j = i; j > -1; j--) {
      if key.name.localizedCompare(sortedRides[j].name) == .OrderedAscending {
        sortedRides.removeAtIndex(j + 1)
        sortedRides.insert(key, atIndex: j)
      }
    }
  }

  // 3
  var sortedNames = [String]()
  for ride in sortedRides {
    sortedNames.append(ride.name)
  }

  print(sortedRides)

  return sortedNames
}
```
1. Sử dụng vòng lặp qua các phần tử
2. So sánh 2 phần tử với nhau
3. Đưa ra một mảng đã được sắp xếp. 

Từ quan điểm của người gọi đến hàm `sortedName(:)`, nó cung cấp một danh sách các rides và sau đó trả về một danh sách đã được sắp xếp. Không có gì ngoài sortedName bị ảnh hưởng. Để kiểm tra nó chúng ta hãy in danh sách trước và sau khi sắp xếp. 

Bạn có thể thấy trong `assistan editor` bạn sẽ thấy rằng tên của các chuyến đi đã được sắp sép mà không làm ảnh hưởng đến danh sách ban đầu. 

IP thì bắt buộc chúng ta phải tạo một hàm khá dài và khó sử dụng. Nó sẽ không còn là tốt nữa nếu có một chức năng đơn giản hoá quy trình so sánh như `selectedName(:)` chẳng hạn. Khi đó cuộc đời sẽ đẹp hơn rất nhiều. ]

#### First class và Higher-Order Function.
Một đặc trưng khác của FP đó chính là trong FP thì `function` chính là first-class, có nghĩa là function có thể được gán giá trị và có thể được truyền trong bản thân hàm hoặc hàm khác. Nó thì là cấp độ cao hơn của `higher-order  function`. Cái mà cấp nhận funciton như là một tham số hoặc trả về một function khác.

![](https://koenig-media.raywenderlich.com/uploads/2015/08/firstclass-678x500.png)

Trong loạt bài này, bạn sẽ làm việc với một số higher-order function thường gặp của FP như là `filter`, `map`, `reduce`

#### Filter

Trong Swift thì `filter(:)` thì là phương thức trên tập dữ liệu, giống như swift array, và nó chấp nhận một function khác như là một tham số duy nhất và nó sẽ ánh xạ những giá trị trong tập dữ liệu sang một mảng Bool.

`filter(:)` áp dụng đầu vào của functoin là mỗi phần tử của mảng đang được gọi và tả về một mảng khác, cái mà chỉ có những phần tử của mảng mà function return true. ( Phù hơp với điều kiện trong filter)

#### Map
Phương thức trên `Collection Type` `map(:)` func chấp nhật một `single function` như một tham số, và ngược lại nó sẽ trả về một mảng có cùng độ dài sau khi áp dụng mỗi phần tử của collection. Kiểu trả về của function sau khi được ánh xạ thì không cùng kiểu với collection element ban đầu. 

Áp dụng map cho những phần tử của `parkRides` và lấy danh sách rác ride name như sau:

```swift
let rideNames = parkRides.map { $0.name } 
print(rideNames)
```
#### Reduce 
Phương thức `reduce(:,:)` thì lấy 2 giá trị như là tham số đầu vào. Giá trị thứ nhất thì là giá trị bắt đầu , và giá tị thứ 2 là hàm cái mà sẽ kết hợp giá trị của  với mỗi phần tử trong collection và tạo ra một giá trị khá. 

#### Currying.
Một kĩ thuật cao hơn trong FP là `currying`. Về cơ bản có nghĩa là suy nghĩ về các hàm nhiềm tham số như một chuỗi các ứng dụng hàm cho mỗi tham số, từng cái một. 

![](https://koenig-media.raywenderlich.com/uploads/2015/08/curry-678x500.png)

Rõ ràng, trong tutorial này. Currry thì không phải là dễ dàng gì. Bạn có thể chứng minh sự pha trộ bằng cách tạo ra một hàm hai tham số để tách hai tham số qua dấu ngoặc đơn. 

```swift 
func rideTypeFilter(type: RideType)(fromRides rides: [Ride]) -> [Ride] {
  return rides.filter { $0.types.contains(type) }
}
*** Notice: Cyrried function thì đã bị bỏ ở Swift 4
```
Ở đây `rideTypeFilter(:)(:)` cấp nhận `RideType` như là tham số đầu tiên và một array `rides` như là tham số thứ 2. Một trong những ứng dụng tốt nhất của `currying) là tạo ra các chưc năng mới. Bằng cách gọi hàm curried của bạn với chỉ một tham số, bạn thực hiện hàm khác sẽ chỉ yêu cầu một tham số khi được gọi ( Khó hiểu vãi chưởng)

Hãy thử nó bằng cách thêm đoạn code sau vào trong playground của bạn:
```swift 
func createRideTypeFilter(type: RideType) -> [Ride] -> [Ride] {
  return rideTypeFilter(type)
}
``` 
....còn tiếp

#### Hàm thuần khiết

Một trong những khái nhiệm chính trong FP đưa đến khả săng suy luận nhất quán về cấu trúc của chương trình, cũng như tự tin về kết quả của chương trình đó chính là `pure function` ( Hay còn gọi là Hàm thuần khiết)

`Pure function ` luôn phải đáp ứng 2 tiêu chí sau:
 - Luôn luôn tạo ra cùng một output vs cùng input. Đầu ra chỉ phụ thuộc vào đầu vào.
 - Không tạo hiệu ứng lề . Có nghĩ là không phụ thuộc và không bị thay đổi trạng thái vào các biến bên ngoài phạm vi hoạt động của nó. 

Sự tồn tại của `pure function` thì gắn chặt với việc sử dụng các immutable states.( Trạng thái bất biến) 
Thêm đoạn code sau vào trong playground của bạn. 

```swift
func ridesWithWaitTimeUnder(waitTime: Double, fromRides rides: [Ride]) -> [Ride] {
  return rides.filter { $0.waitTime < waitTime }
}
```

`ridesWithWaitTimeUnder(:fromRides:)` thì là một hàn thuần khiết bởi vì output của nó thì luôn luôn giống nhau với cùng một đàu vào. 

Với một `pure function` thật đơn giản để viết một unit test tốt. 

#### Referential Transparency (Tham chiếu minh bạch)
Các `pure function` thì liên quan chặt chẽ đến khái niệm tham chiếu minh bạch. Một phần tư của chương chình thì là tham chiếu minh bạch nếu bạn có thể thay thế nó với định nghĩa của nó và luôn luôn tạo ra cùng một kết quả. Nó làm cho mã có thể dự đoán được và cho bén trình biên dịch được tối ưu hoá. 





