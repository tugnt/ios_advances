# UICollectionView Custom Layout Tutorial: Pinterest


#### Notice: Bài này được dịch từ nguồn : [Raywenderlich](https://www.raywenderlich.com/164608/uicollectionview-custom-layout-tutorial-pinterest-2)

`UICollectionView` đươc giới thiệu ở iOS 6 và nó nhanh chóng trở thành một trong những UI element quan trọng nhất đối với iOS developer. Điều gì làm cho nó trở nên hấp dẫn đó chính là sự tách biệt giữa data và lớp biểu diễn (presentation layer), cái mà phụ thuộc trên một đối tượng riêng biệt để xử lý layout. Layout thì chịu trách nhiệm cho xác định vị trí và các thuộc tính của view.

Bạn thường sử dụng layout mặc định, layout mà được cung cấp bởi `UIKit`, cái mà bao gồm bố cục lưới cơ bản với một số tuỳ chọn. 
Nhưng bạn cũng có thể tuỳ biến layout theo bất kì cách nào mà bạn muốn. Chính điều đó làm cho `UICollectionView` rất mạnh mẽ và linh hoạt.

Trong tutorial về custom layout cho `UICollectionView`, bạn sẽ tạo ra một layout lấy cảm hứng từ ứng dụng Pinterst.

Trong quá trình bạn sẽ học được rất nhiều về custom layout, làm thế nào để tính và cache các layout attributes, làm thế nào để xử lý dynamically sized cell và nhiều hơn nữa. 

```note
Trong tutorial yêu cầu bạn đã có kiến thức cơ bản về UICollectionView. Nếu bạn chưa có căn bản về nó hãy học nó trước khi đọc bài này.
```

### Bắt đầu
Trước khi bắt đầu bạn nãy download template project [ở đây](https://koenig-media.raywenderlich.com/uploads/2017/09/Starter_Project.zip) về. Chạy ứng dụng lên bạn sẽ thấy nó như sau:
 ![]( https://koenig-media.raywenderlich.com/uploads/2017/08/pinterest-layout-updated-initial.png)

Ứng dụng hiển thị thư viện hình ảnh từ RWDevCon.

Ứng dụng thì build và sử dụng côlection view với flow layout mặc định. Từ cái nhìn đầu tiên, nó thì trông có vẻ ổn. Nhưng layout thì chắc chắn có thể được cải thiện. Các cell thì không fill toàn bộ nội dung ảnh, và các ảnh dài thì sẽ bị cắt bớt. 

Trải nghiệm người dùng nhìn chung khá là nhàm chán bởi vì tất cả các ô có cùng kích thước. Một cách để cải tiến đó là tạo một custom layout nơi mà mỗi cell thì có kích thước phù hơp với size của ảnh. 

### Tuỳ biến Collection View Layout

Bước đầu tiên trong việc tạo collection view tuyệt đẹp là tạo một custom layout class cho Galery của bạn. 
Collection view layouts thì là subclass của abstract `UICollectionViewLayout` class. Nó định nghĩa những thuộc tính cho mỗi item trong collection view của bạn. Các thuộc tính riêng lẻ là thể hiện của `UiCollectionViewlayoutAttributes` và bao gồm các thuộc tính của mỗi item trong collection view của bạn, chẳng hạn như `frame` or `transform` của item.

Tạo new file trong `Layouts` groups. Chọn `Cocoa Touch Class` từ `iOS\Source`. Đặt tên nó là `PinterestLayout` và nó là lớp con của `UICollectionViewLayout`.  Hãy chắc chắn chọn ngôn ngữ là swift và ấn create new file. 

Tiếp theo bạn sẽ cần configure collection view sử dụng layout bạn vừa mới tạo. 

Mở file `Main.storyboard` và chọn `Collection View ` từ Photo Stream View Controller Sence như hình dưới. 

![](https://koenig-media.raywenderlich.com/uploads/2017/08/pinterest-layout-updated-interface-builder.png)

Tiếp theo, mở `Attributes Inspector. Chọn `Custom` trong layout drop-down list và chọn PrinterestLayout trong class drop-down list.
![](https://koenig-media.raywenderlich.com/uploads/2017/09/storyboard_change_layout.png)

OKay. bây giờ ta sẽ build và run lại app. Wtf, không có gì hiển thị lên. 

![](https://koenig-media.raywenderlich.com/uploads/2015/05/build_and_run_empty_collection.png)

Đừng hoảng loạn. Nó là một dấu hiệu tốt, bạn có thể tin hoặc không. Nó có nghĩa là collection view thì đang sử dụng custom layout class. Cell thì không hiển thị bởi vì `PrinteressLayout`  class thì vẫn chưa implement bất kì một phương thức nào. 

### Core Layout Process( Từ này mình không hiểu rõ nghĩa lắm nên sẽ để nguyên gốc cho mọi người tự suy nghĩ ) =))

Hãy dành vài phút để suy nghĩ về tiến trình bố cục layout trong collection view, là sự cộng tác giữa collection view và layout object. Khi collection view cần một số thông tin về layout, nó sẽ hỏi đối tượng layout mà bạn cung cấp cho nó bằng cách gọi một số phương thức nhất định theo thứ tự cụ thể. 

![](https://koenig-media.raywenderlich.com/uploads/2015/05/layout-lifecycle.png)

Lớp layout của bạn bắt buộc phải implement một số phương thức dưới đây. 
* `collectionViewContentSize` : Phương thức này sẽ trả về width và height của content của collection view. Bạn phải override nó. Nó thì sẽ trả về width và height của toàn bộ nội dung của collection view- không chỉ là nội dung hiển thị. 
* `prepare()`: Phương thức này sẽ gọi khi bất cứ khi nào hoạt động bố cục layout được diễn ra. Dó là thời giạn cho bạn chuẩn bị và thực hiện bất kỳ phép tính toán nào cần thiết để xác định kích thước của bộ sưu tập và vị trí của các item.
* `layoutAttibuesForElement(in:)`: trong hương thức này bạn cần trả về thuộc tính của layout cho tất cả các item bên trong hình chữ nhật đã cho. Bạn sẽ trả về các thuộc tính cho collection view như một mảng của `UICollectionViewLayoutAttributes`.
* `layoutAttributesForItem(at:)`: thước thức này cung cấp thông tin layout cho collection view theo yêu cầu. Bạn cần override nó và trả về layout attributes cho item tại requested indexPath.

### Tính toán các thuộc tính layout. 

Trong layout này, bạn cần tính toán động chiều cao cho mỗi item vì bạn không biết chiều cao của bức ảnh sẽ là gì. Bạn cần khai báo một protocol cái mà sẽ cung cấp thông tin này(chiều cao) khi mà `PriterestLayout` cần.

```swift
protocol PinterestLayoutDelegate: class {
   func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndextPatt index: IndexPath) -> CGFloat
}
```

Đoạn code trên sẽ khai báo `PinterestLayoutDelegate` protocol, cái mà có một thương thức yêu cầu trả về chiều cao của bức ảnh. Bạn sẽ implement protocol này trong `PhotoStreamViewController`. 

Chỉ cần làm một việc nữa trước khi implement các phương thức của layout, bạn cần khi báo vài thuộc tính sau:

```swift
// 1 
weak var delegate: PinterestLayoutDelegate!

// 2
fileprivate var numberOfColumns = 2
fileprivate var cellPadding: CGFloat = 6

// 3
fileprivate var cache = [UICollectionViewLayoutAttributes]()

// 4
fileprivate var contentHeight: CGFloat = 0

fileprivate var contentWidth: CGFloat {
  guard let collectionView = collectionView else {
    return 0
  }
  let insets = collectionView.contentInset
  return collectionView.bounds.width - (insets.left + insets.right)
}

// 5
override var collectionViewContentSize: CGSize {
  return CGSize(width: contentWidth, height: contentHeight)
}
```

Đoạn code trên định nghĩa một số thuộc tính bạn cần sau này cung cấp cho layout. Dưới đây là định nghĩa từng thuộc tính:
- 1: Nó giữ liên kết đên delegate
- 2: Có 2 thuộc tính cho config layout: cel padding và số collumn
- 3: Array này thì cache những attributes đã tính toán. Khi bạn gọi method `prepare()`, bạn sẽ tính toán các thuộc tính cho tất cả các item và thêm nó vào cache. Khi collection view yêu cầu layout attribues, bạn có thể query vào bộ nhớ cache thay vì tính toán mỗi lần. 
- 4: Khai báo hai thuộc tính cho lưu trữ content size. `contentHeight` thì tăng lên khi ảnh được thêm vào và `contentWidth` thì được tính toán dựa trên collectionView và content inset của nó. 
- 5: Ở đây thì override phương thức  `collectionViewContentSize` size của content collection view. Bạn sử dụng cả `contentWidth` và `contentHeight` từ bước phía trước cho tính toán size.

Bạn đã sẵn sàng tínht toán các thuộc tính cho collection view item, Để hiểu rõ hơn bạn xem hình bên dưới.

![](https://koenig-media.raywenderlich.com/uploads/2015/05/customlayout-calculations1.png)

Bạn sẽ tính toàn frame của mỗi item dựa trên collum của nó (xOffset) và vị trí của item phía trước trong cùng một collumn (tính bởi yOffset). 

Tính toán vị trí nằm ngang bạn sẽ xử dụng toạ độ X của cột mà item sẽ bắt đầu và cộng thêm với cell padding. Vị trí thẳng đứng là vị trí của item cùng cột ở phía trước cộng với chiều cao của mục trước đó. Tổng thể chiều cao đó là tổng chiều cao của ảnh và phần cell padding.

Bạn sẽ implement nó trong `prepare()`, nơi mục tiêu chính của bạn là tính toàn instance của `UICollectionViewlayoutAttributes` cho mỗi item trong layout.

Thêm code dưới này vào `PinterestLayout`

```swift
override func prepare() {
  // 1
  guard cache.isEmpty == true, let collectionView = collectionView else {
    return
  }
  // 2
  let columnWidth = contentWidth / CGFloat(numberOfColumns)
  var xOffset = [CGFloat]()
  for column in 0 ..< numberOfColumns {
    xOffset.append(CGFloat(column) * columnWidth)
  }
  var column = 0
  var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
    
  // 3
  for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
      
    let indexPath = IndexPath(item: item, section: 0)
      
    // 4
    let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
    let height = cellPadding * 2 + photoHeight
    let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
    let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      
    // 5
    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    attributes.frame = insetFrame
    cache.append(attributes)
      
    // 6
    contentHeight = max(contentHeight, frame.maxY)
    yOffset[column] = yOffset[column] + height
      
    column = column < (numberOfColumns - 1) ? (column + 1) : 0
  }
}
```

Giải thích các comment:

- 1: Bạn sẽ chỉ tính toán khi mà cache trống và collection view không mang giá trị nil 
- 2: Mảng yOffset thì theo dõi vị trí y cho mỗi cột. Bạn khởi tạo mỗi giá trị trong yOffset thành 0, vì đây là giá trị bù của mục đầu tiên trong mỗi cột.
- 3: Vòng lặp qua tất cả item của section đầu tiên. Vì collection view này chỉ có 1 section.
- 4: Phần này biểu diẽn tính toán `frame`. `width` là `cellWidth` đã được tính toán trước đó, đã xoá bỏ padđing giữa những cell. Bạn hỏi `delegate` cho chiều cao của ảnh và tính toán frame height dựa trên chiều cao này vào định nghĩa lại lại `cellPadding` to top và bottom. Sau đó bạn kết hợp điều này với độ lệch x và y của cột hiện tại để tạo `insetFrame` sử dụng bởi attributes.
- 5: Ở đây tạo thể hiện của `UICollectionViewLayoutAttributes`, thiết lập nó sử dụng `insetFrame` và lưu nó vào trong cache. 
- 6: Mở rộng `contentHeight` để tính toán `frame` của item mới được tính toán( khó hiểu vãi chưởng). Sau đó tiến hành thiết đặt `yOffset` cho cột hiện tại dựa trên frame. Cuối cùng, nó thì tiến tới tính toán các cột tiếp theo. 

NOTE: 

Bây giờ bạn cần override `layoutAttributesForElements(in:)` , cái mà collection view sẽ gọi sau khi `prepare()` để xác định xem item nào sẽ đc hiển thị. 

Thêm vào `PinterestLayout` đoạn code dưới đây:

```swift 
override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? { 
  var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()  
  // Loop through the cache and look for items in the rect
  for attributes in cache {
    if attributes.frame.intersects(rect) {
      visibleLayoutAttributes.append(attributes)
    }
  }
  return visibleLayoutAttributes
}
```

Ở đây bạn lặp qua cá thuộc tính trong bộ đệm cache và kiểm frame của chúng có giao nhau với rect hay không(), cái được cung cấp bởi `UICollectionView`. Bạn thêm bất kỳ thuộc tính nào với các khung giao cắt với rect đó thành `layoutAttributes`, cuối cùng nó được trả về collection view. 

Method cuối cùng bạn phải implement là `layoutAttributesForItem(at:)`

```swift 
override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
  return cache[indexPath.item]
}
```

Ở đây bạn chỉ cần truy xuất và trả về từ cache các thuộc tính layout tương ứng với indexPath được yêu cầu.

Trước khi bạn có thể thấy layout của mình đang hoạt động, bạn cần implement PinterestLayoutDelegate. PinterestLayout dựa vào điều này để cung cấp chiều cao ảnh và chú thích khi tính chiều cao của attributes's frame. 

Mở PhotoStreamViewController.swift và thêm phần mở rộng sau vào cuối tệp để áp dụng giao thức PinterestLayoutDelegate

```swift 
extension PhotoStreamViewController: PinterestLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    
    return photos[indexPath.item].image.size.height
  }
}
```
Ở đây cũng cấp layout với chính xác chiều cao của bức ảnh. 

Cuối cùng thêm đoạn code sau vào trong `viewDidLoad()` :

```swift 
if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
  layout.delegate = self
}
```
Build và run app chúng ta sẽ nhận được kết quả như dưới đây:

![](https://koenig-media.raywenderlich.com/uploads/2017/08/pinterest-layout-updated-final.png)
























