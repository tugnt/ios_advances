### Xử lý lỗi trong Swift

#### Câu chuyện của tôi. 

Khi tôi còn trẻ, Tôi đã đọc Swift Documentation. Tôi đã đọc tất cả các chương ngoại trừ `Error Handling`. Vì một vài lý do nào đó , tôi đã nghĩ là mình phải là một debuger chuyên nghiệp thì mới có thể hiểu được nó. 

Khi đó tôi đã sợ hãi Error Handling. Những từ như `catch`, `try`, `throw`, `throws` thì không để lại nhiều ấn tượng trong tôi. 
Nó thì trông có vẻ đáng sợ, nếu bạn chưa sử dụng nó trước kia, thì có thể bạn nghĩ nó thật khó để hiểu và sử dụng. Đừng lo, tôi ở đây vì bạn. 

Tôi đã nói khi em gái 13 tuổi của tôi viết một đoạn code `if - else ` để send ra thông báo lỗi. 

#### Error message from Tesla.
Theo như cách bạn biết, Chiếc xe tesla thì có chức năng tự lại. Tuy nhiên, khi mà chiếc xe gặp một số rắc rối vì lý do nào đó. Nó sẽ yêu cầu bạn giữ vô lăng và đưa ra một thông báo lỗi. Trong bài này, bạn sẽ học được cách làm thế nào để đưa ra được thông báo lỗi và xử lý lỗi như thế nào `Error Handling`

Chúng thôi sẽ tạo một chương trình phát hiện các đối tượng như là đèn giao thông trên đường phố. Điều kiện tiên quyết, không giới hạn, học máy, tính toán vector, đại số tuyến tính, xác suất thống kê .. Đùa thôi, tôi thậm chí bây giờ còn chẳng nhớ chút gì về những kiến thức đó. 


#### Giới thiệu về if-else 

Để đánh giá đầy đủ về Xử lý lõi trong Swift. Chúng ta hãy nhìn trong quá khứ của bạn. Đây là cách mà rất nhiều, nhưng không phải tất cả, các new developer xử lý lỗi.

```swift
var isInControl = true
func selfDrive() {
 if isInControl {
  print("You good, let me ride this car for ya")
 } else {
  print("Hold the handlebar RIGHT NOW, or you gone die")
 }
}

selfDrive() // "You good..."
```

#### Vấn đề

Vấn đề lớn nhất ở đây là khả năng đọc code khi mà đoạn mã nằm trong `ìf-else` lớn dần lên. Thứ nhất, đầu tiên bạn không thế biết được thân hàm có thông báo lỗi hay không, trừ khi bạn đọc toàn bộ hàm. Từ khi bạn đặt những tên ham như `selfDriveCanCauseError` thì ban có thể nhận biết được phần nào.

Function này có thể giết chết người lái xe. Bạn muốn thông báo rõ ràng cho member trong team của bạn function này thì nguy hiểm và có thể gây chết người nếu không được xử lý một cách cẩn thận. 

```swift
else {
 print("Hold the handle bar Right now...")

 // If handle not held within 5 seconds, car will shut down
 // Slow down the car
 // More code ...
 // More code ...
}
```

Mã xử lý ở trong block else này thì quá nhiều. Nó cũng giống như bạn đang cố gắng chơi bóng rổ trong bộ quần áo mùa đông vậy, cái điều mà tôi đã thường làm vào mùa đông ở Korea.  Bạn có hiểu là tôi đang nói về vấn đề gì không ? Nó trông không đẹp và cũng không dễ đọc. 

Vậy có cách giải quyết khác. Đó là thay vì viết trực tiếp đoạn mã xử lý vào trong else. Thì chúng ta thử tách nó ra như sau:

```swift 
else {
 slowDownTheCar()
 shutDownTheEngine()
}
```

Tuy nhiên, cùng với vấn đề đầu tiên. Không có một cách rõ ràng nào chỉ rằng `selfDrive()` thì là function nguy hiểm, và nên xử lý một cách thận trọng. Vì vây, chúng ta hãy đi sâu vào Error Handling để viết các thông báo lỗi rõ ràng. 

#### Giới thiệu về Error Handling.

Cho đến nay bạn đã biết và sử dụng `if-else` trong xử lý lỗi. Như ví dụ ở phía trên đã đưa ra. Thay vào đó chúng ta giải định có 2 error message: 
1: You are lost
2: The car battery is low 

Chúng ta sẽ tạo enum cái mà sẽ phù hợp với Error protocol.

```swift 
enum TeslaError: Error {
  case lostGPS
  case lowBattery
}
```

Trung thực mà nói, tôi thực sự không biết `Error ` protocol sẽ làm gì, nhưng để xử lý lỗ, bạn phải làm như vậy. Nó giống như, Tại sao máy tính của bạn lại bật khi bạn ấn nút nguồn. Tại sao điện thoại của bạn lại mở khi bạn vuốt màn hình...vv

Đó là cách mà Swift API quyết định và triển khai, và tôi sẽ không đi sâu vào trình bày động cơ của họ. ( Các kĩ sư viết Swift)
Tôi làm theo những gì mà họ đã tạo ra cho chúng tôi. Tất nhiên, nếu bạn muốn học, bạn có thể download mã nguồn của Swift và phân tích nó. Giống như cách bạn đã mở chiếc máy tính or iPHone của bạn. Tuy nhiên, tôi khuyên bạn không nên làm điều đó. 

Đầu điên chúng ta gửi message error mà không sử dụng Error Handling.

```swift 
var lostGPS: Bool = true
var lowBattery: Bool = false

func autoDriveTesla() {
 if lostGPS {
  print("I'm lost, bruh. Hold me tight")
  // A lot more code
 }

 if lowBattery {
  print("HURRY! 💀")
  // Loads of code
 }
}
```

Thử chạy nó xem sao:

```swift 
autoDriveTesla() // I'm lost, bruh. Hold me tight
```

Bây giờ chúng ta hãy cùng implement error handling. Thứ nhất, Bạn phải chỉ ra rằng function này là nguy hiểm và có thể ném ra lỗi bằng cách đặt từ khoá `throws` bên cạnh khai báo hàm.

```swift 
func autoDriveTesla() throws { ... }
```

Bây giờ, function tự động nói với các thành viên trong tram của bạn rằng `autoDriveTesla` thì có thể ném ra lỗi mà không cần phải đọc toàn bộ code của function. 

Trông nó có vẻ ổn. Okay, bây giờ chính là thời gian để ném (throw) lỗi đến bới người lái xe. Chúng ta hãy nhớ rằng `TeslaError` là enum.

```swift
func autoDriveTesla() throws {
 if lostGPS {
  throw TeslaError.lostGPS
}
 if lowBattery {
  throw TeslaError.lowBattery
}
```

Nếu `lostGPS` thì true, function sẽ send `TeslaError.lostGPS`. Tuy nhiên, bạn sẽ làm gì sau đó. Chúng ta sẽ xử lý lỗi ở đâu để không phải viết quá nhiều code trong else block.

```swift 
print("Bruh, I'm lost. Hold me tight")
```

Okay. Hãy chạy hàm này với từ khoá throw kèm theo. Bạn phải chạy hàm này bằng cách goi try bên trong `do` block. Giống như việc bạn thử làm gì đó

```swift 
do {
   try autoDriveTesla() 
}
```

Tôi biết lúc này bạn đang suy nghĩ điều gì. "Tôi thực sự muốn đưa ra thông báo lỗi, nếu không người lái xe sẽ ngỏm củ tỏi".
Vậy, chúng ta sẽ in ra thông báo lỗi ở đâu. Như chúng ta đã biết, function có thể ném ra 2 loại lỗi. đó là 1: mât gps và 2: hết pin. Khi function ném ra lỗi, bạn phải băt "catch" những lỗi bị ném. Và với mỗi một lỗi bị bắt, bạn in ra thông báo lỗi. 

```swift 
var lostGPS: Bool = false
var lowBattery: Bool = true

do {
 try autoDriveTesla()
 } catch TeslaError.lostGPS {
  print("Bruh, I'm lost. Hold me tight")
 } catch TeslaError.lowBattery {
  print("HURRY! 💀")
 }
}

// Results: "HURRY! 💀"
```

### Error Handling with Init
Bạn không chỉ áp dụng error handling cho các function, bạn cũng  có thể error handling khi khởi tạo một object. Nhưng đã nói, nếu bạn không đặt tên cho khoá học, nó sẽ ném ra một lỗi. 

```swift
// Define Error Type
enum CourseError: Error {
 case noName
}

// Create Structure
struct UdemyCourse {
 let courseName: String
 init(name: String) throws {
  if name == “” { throw CourseError.noName }
  self.courseName = name
 }
}

// Init & Handle Error
do {
 try UdemyCourse(name: “UIKit Fundamentals with Bob”)
 } catch NameError.noName {
  print(“Bob, you need to enter the name”)
 }
 ```

Nếu bạn thử `UdemyCourse(name: "")` thì sẽ xuất hiện lỗi. 


###  Khi nào thì bạn nên sử dụng `try!` và `try?`

Tốt. `Try` thì chỉ sử dụng khi bạn chạy function/init bên trong khối `try/catch`. Tuy nhiên, nếu bạn không quan tâm đến việc thông báo cho người dùng những gì đang xảy ra thông qua in các thông báo lỗi hoặc xử lý lỗi. Về mặt kĩ thuật bạn không cần khổi `catch`

### Còn mày là ai `try?`

Hãy bắt đàu với `try?`, mặc dù tôi không khuyến khích bạn viết như thế này. 

```swift
let newCourse = try? UdemyCourse("Functional Programming")
```

`try?` thì luôn trả về một optional object. Và nếu bạn muốn unwrap `newCourse` object như sau: 

```swift 
if let newCourse = newCourse { ... }
```

nếu phương thức khởi tạo ném ra một lỗi. Trông như sau: 

```swift
let myCourse = try? UdemyCourse("") // throw NameError.noName
```
thì `myCourse` sẽ mang giá trị nil.

### Vậy còn mày là ai `try!`

Không giống như `try?` thì trả về một optional value. `try!` thì trả về một giá trị bình thường. 
Ví dụ 

```swif
let bobCourse = try! UdemyCourse("Practical POP")
```

`bobCourse` thì không phải là một optional value. Tuy nhiên, nếu hàm khởi tạo của nó ném ra một lỗi giống như:

```swift 
let noCourseName = try! UdemyCourse("") // throw NameError.noName
```
thì ứng dụng sẽ bị crash. Không bao giờ sử dụng `!` trừ khi bạn chắc chắc không mang giá trị nil. 

Chính là nó. Bạn đã hiểu đầy đủ khái nhiệm về Error Handloing trong hướng dẫn này, khá là dễ dàng đúng không. Không cần phải trở thành debuger chuyên nghiệp mới có thể hiểu được bài này. 



























