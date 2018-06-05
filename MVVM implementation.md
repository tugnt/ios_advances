### Làm thế nào để không tuyệt vọng trong khi implement MVVM
--------
Bài được dịch từ [Nguồn](https://medium.com/flawless-app-stories/how-to-use-a-model-view-viewmodel-architecture-for-ios-46963c67be1b)

- Hãy thử tưởng tượng bạn có một dự án nho nhỏ. Nơi bạn có thể phân phối các chức năng mới chỉ trong 2 ngày, từ 2 ngày lên 1 tuần. rồi 2 tuần. Và khi dự án phình to ra, bạn không thể dự đoán trước khi nào có thể hoàn thành các chức năng mới. Bạn bắt đầu phàn nàn: "Một sản phẩm tốt thì không nên quán phức tạp". ĐÓ chính xác những gì mà tôi đã phải đối diện và nó là khoảng thời gian tồi tệ nhất đối với tôi. Bây giờ, sau khi làm việc được một vài năm với những lập trình viên tuyệt vời. Tôi nhận ra rằng thiết kế sản phẩm không thực sự làm cho code trở nên phức tạp. Chính tôi là người đã làm nó trở nên phức tạp.

- Chúng tôi có thể có kinh nghiệm trong viết spaghetti code, cái mà thực sự làm giảm hiệu suất của dự án. Câu hỏi là làm như thế nào để cải thiện điều đó? Một kiến trúc tốt có thể giúp bạn. Trong bài này, chúng tôi sẽ nói về như thế nào là một kiến trúc tốt, và chúng tôi đề cập đến là MVVM ( Model-View-ViewModel) đang nổi lên là một kiến trúc mà được rất nhiều lập trình viên IOS áp dụng. 

- Như thế nào là "good architecture" kiên trúc tốt, câu hỏi này có vẻ khá là trừu tượng. Và chính nó cũng gây khó khăn cho việc chúng ta nên bắt đầu từ đâu. Đây là một gợi ý cho bạn: Thay vì tập trung vào định nghĩa của architecture, chúng ta có thể tập trung làm như thế nào để việc kiểm thử dễ dàng hơn. 

- Nói đến kiến trúc của ứng dụng thì có khá là nhiều, chúng ta có thể kể đến như MVC, MVP, MVVM, VIPER. Nó thì là khá rõ ràng, chúng tôi có thể không master tất cả các kiến trúc. Tuy nhiên, chúng tôi vẫn lưu ý một quy tắc đơn giản: bất kể kiến trúc bạn sử dụng là gì thì mục tiêu cuối cùng vẫn là làm cho việc kiểm thử đơn giản hơn. Chúng ta hãy suy nghĩ cách tiếp cận này trước khi bắt đầu. Chúng tôi đặt trọng tâm vào chia tách trách nhiệm một cách rõ ràng. Hơn nữa, thiết kế của kiến trúc trông có vẻ hợp lý với suy nghĩ này. Chúng tôi sẽ không bị mắc kẹt trong các tiểu tiết nữa. 

Trong bài này bạn sẽ học được:
- Lý do mà chúng tôi chọn MVVM hơn là Apple MVC
- Cách điều chỉnh MVVM để có một kiên trúc rõ ràng hơn
- Làm thế nào để viết một ứng dụng thực tế dựa trên MVVM 

Tất cả kiến trúc đều có ưu và nhược điểm riêng, nhưng mục đích cuối cùng là làm cho mã trở nên rõ ràng hơn. Bởi vậy, chúng tôi quyết định tập trung vào giải thích tại sao lại chọn MVVM hơn là MVC và làm sao để chuyển từ MVC sang MVVM. 

### Bắt đầu
#### Apple MVC 
MVC(Model-View-Controller) thì là kiến trúc mà Apple đã giới thiệu. Bạn có thể thấy định nghĩa ở đây. Tương tác giữa các đối tượng trong mô hình MVC được mô tả như trong hình dưới đây:

![](https://cdn-images-1.medium.com/max/1600/1*la8KCs0AKSzVGShoLQo2oQ.png)

Trong lập trình iOS và MacOS do sự ra đời của ViewController nên mô hình MVC thường trở thành như sau:


![](https://cdn-images-1.medium.com/max/1600/1*8XM4gfWIvaOl8kHiNlxLeg.png)

ViewControlelr thì chứa cả View và ViewModel của chúng. Vấn đề ở đây là chúng tôi đã sử dụng code để xử lý cả View và Controlelr ở ngay đây. Nó đã làm cho ViewController trở nên quá phức tạp. Đó là lý do tại sao chúng ta gọi nó là `Massive View Controller`. Trong khi bạn viết test cho ViewController, bạn cần mock view vào vòng đời của nó. Nhưng view thì quá khó để mock. Và chúng tôi thường không muốn chỉ mock view với chỉ test controller. Tất cả điều đó làm cho test trở nên quá phức tạp và khó khăn. 

Vì vậy MVVM ở đây:

#### MVVVM - Mode- View-ViewModel 

MVVM thì được đề xuất bởi John Gossman vào năm 2005. Mục đính chính của MVVM là chuyển trạng thái của data từ View sang ViewModel. Luồng dữ liệu trong MVVM được minh hoạ trong hình dưới đây:

![](https://cdn-images-1.medium.com/max/1600/1*8MiNUZRqM1XDtjtifxTSqA.png)

Theo như định nghĩa, bây giờ View chỉ bao gồm những phần tử trực quan. Trong view, chúng tôi chỉ thực hiện những việc như layout, animation, khởi tạo UI, ..rtc. Một lớp đặc biệt nằm ở giữa của View và ViewModel gọi là ViewModel. ViewModel thì đại điện của View. Đólà, ViewModel cung cấp một tập hợp các interface, mỗi interface thì đại diện cho một UI Component trong View. 
Chúng tôi sử dụng kĩ thuật gọi là `binding` để kết nối UI Component với ViewModel interface. Vậy, trong MVVM chúng tôi không làm việc trực tiếp với View. Chung tối thay đổi business logic trong ViewModel và View sẽ tự thay đổi chính nó sao cho phù hợp.
Chúng tôi sẽ viết những logic business ( chuyển date thành String) ở trong ViewModel thay thì ở trong View. Bởi vậy, việc test sẽ đơn giản hơn với business logic mà không cần phải implement ra ngoài view.

Hãy quay lại hình ảnh ở phía trên. Nhìn chung thì ViewModel sẽ nhận tương tác từ View, nhận dữ liệu từ Model và sau đó xử lý để hiển thị ra view. View thì lắng nghe những thay đổi trong ViewModel để tự thay đổi chính nó sao cho phù hợp. Đó là toàn bộ câu chuyện của MVVM. 

- Cụ thể hơn, trong lập trình iOS thì UIView/UIViewController thì đại diện cho View. Chúng ta chỉ cần làm.
    - 1: Khởi tạo, layout các UI Component
    - 2: Bind UI Compnents với ViewModel. 

- Mặt khác ở ViewModel:
    - 1: Viết controller logics như phân trang, xử lý lỗi ..vv
    - 2: Viết các presentational logic, cùng cấp interfaces cho view.

Bạn có thể nhận thấy rằng ViewModel khá phức tạp. Trong phần cuối của bài viết này, chúng tôi sẽ thảo luận về phần xấu của MVVM. Dù sao, đối với một dự án cỡ trung bình, MVVM vẫn là một lựa chọn tốt.

Trong các phần sau, chúng ta sẽ viết một ứng dụng đơn giản với mẫu MVC và sau đó mô tả cách tái cấu trúc ứng dụng thành mẫu MVVM. Dự án mẫu với các unit test có thể được tìm thấy trên GitHub của tôi:

#### Ứng dụng Galery MVC 
Chúng ta sẽ tạo một ứng dụng: 
- Ứng dụng sẽ lấy những hình ảnh từ 500Px API và sử dụng table View để hiển thị hình ảnh
- Mỗi cell trong tableView sẽ hiển thị ảnh, title và description
- User thì không thể click vào những hình ảnh không có label `for_sale`

    ![](https://media.giphy.com/media/l4EoWSOY1kxeSHVvi/giphy.gif)

Trong ứng dụng này chúng tôi có một struct tên là Photo, nó thì đại diện cho 1 bức ảnh. Đây là interface của Photo

```swift 
struct Photo {
    let id: Int
    let name: String
    let description: String?
    let created_at: Date
    let image_url: String
    let for_sale: Bool
    let camera: String?
}
```

Tạo một Controller chứ table view controller cái sẽ hiển thị danh sách cách hình ảnh gọi là PhotoListViewController. Chúng ta sẽ lấy data từ `APIService` trong `PhotoListViewController` và reload table view sau khi lấy được dữ liệu. 

```swift 
  self?.activityIndicator.startAnimating()
  self.tableView.alpha = 0.0
  apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
      DispatchQueue.main.async {
        self?.photos = photos
        self?.activityIndicator.stopAnimating()
        self?.tableView.alpha = 1.0
        self?.tableView.reloadData()
      }
  }
```

`PhotoListViewControlelr` cũng là data source của table view.

```swift 
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // ....................
    let photo = self.photos[indexPath.row]
    //Wrap the date
    let dateFormateer = DateFormatter()
    dateFormateer.dateFormat = "yyyy-MM-dd"
    cell.dateLabel.text = dateFormateer.string(from: photo.created_at)
    //.....................
}
  
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.photos.count
}
```

Trong `tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell` chúng ta sẽ hiển thị đúng data cho từng cell và ở trong đây chúng ta cũng sẽ thự hiện convert date sang string. Đoạn code dưới đây implement cho delegate table view. 

```swift 
func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    let photo = self.photos[indexPath.row]
    if photo.for_sale { // If item is for sale 
        self.selectedIndexPath = indexPath
        return indexPath
    }else { // If item is not for sale 
        let alert = UIAlertController(title: "Not for sale", message: "This item is not for sale", preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return nil
    }
}
```

Chúng ta sẽ chọn hình ảnh tương ứng từ `func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?` và kiểm tra thuộc tính `for_sale`. Nếu nó là true thì oke còn nếu không thì sẽ show alert. 

Vậy đoạn code trên thì có gì sai. Trong `PhotoListViewController` chúng ta có thể tìm thấy những đoạn code logic như convert `Date` sang string ..vv. Chúng ta cũng có những đoạn code của View như là hiển thi hoặc ẩn table view. Hơn nữa chúng ta cũng thực hiện gọi API từ đây, ngay trong ViewController. Nếu bạn có kế hoạch viết test cho `PhotoListVieController`, bạn sẽ cảm thấy như mắc kẹt vì quá phức tạp. Chúng ta có mock APIService, mock table view và mock cell ... quá phức tạp. 

Hãy nhớ rằng mục tiêu đặt ra ở đầu là: Make test easier. Bây giờ chúng ta sẽ tiếp cận theo cách MVVM.

#### Try MVVM

Để giải quyết vấn đề trên thì mục tiêu đầu tiên chúng ta cần làm đó là dọn dẹp sạch sẽ ViewController. Chúng ta sẽ chia ViewController thành 2 phần. 
- 1: Thiết kế một tập các interface cho binding. 
- 2: Chuyển các  presentational logic  và controller logic vào trong ViewModel.

Đầu tiên chúng ta hãy xem qua có bao nhiêu view trong trường hợp này

- 1: activity Indicator (loading/finish)
- 2: tableView (show/hide)
- 3: cells (title, description, created date)

Chúng ta có thể trừu tượng các UI Component như sau:

![](https://cdn-images-1.medium.com/max/1600/1*ktmfaTJajU0NYrCBq8iqnA.png)

Với mỗi UI component thì có tương ứng một thuộc tính trong ViewModel. Chúng ta có thể nói rằng, những gì chúng ta thấy trong View sẽ tương ứng với những gì chúng ta thấy trong ViewModel. Vậy chúng ta sẽ binding nó như thế nào?

#### Implement binding với Closure
Trong Swift chúng ta có vài cách để binding như sau:
- Sử dụng KVO
- Sử dụng thư viện thứ 3 như RxSwift, ReactiveCocoa
- Tự tạo cách riêng =))))))))))

Sử dụng KVO thì là một ý tưởng tồi. Bởi vì chúng ta sẽ cần đến một lượng lớn các phương thức delegate và chúng ta phải cẩn thận về addObserver/removeObserver cái mà có thể xem như gánh nặng của view. 

Cách lý tưởng để binding là sử dụng giải pháp liên kết trong FRP. Nếu bạn đã quen thuộc với Functional Reactive Programing(FRP) thì hãy tìm nó! Nếu không, tôi sẽ không khuyên bạn nên sử dụng FRP chỉ để binding bởi vì nó là loại khó hiểu, và nó giống như việc bạn dùng giao giết trâu đi mổ gà vậy. Đây là một bài viết tuyệt vời nói về việc sử dụng decorator pattern  để tự tạo ra binding. Trong bài viết này, chúng tôi sẽ đưa mọi thứ đơn giản hơn. Chúng tôi binding mọi thứ bằng cách sử dụng closure. Thực tế, trong ViewModel một interface / một property cho binding trông như thế này:

```swift 
var prop: T {
    didSet {
        self.propChanged?()
    }
}
```

Mặt khác, trong View, chúng ta gán một closure cho propChanged như callback closure để cập nhật giá trị.
```swift 

// When Prop changed, do something in the closure 
viewModel.propChanged = { in
    DispatchQueue.main.async {
        // Do something to update view 
    }
}
```

Mỗi lần thuộc tính được cập nhật, `propChange` sẽ được gọi. Vì vậy chúng tôi có thể cập nhật view theo đúng với sự thay đổi của ViewModel. Khá là đơn giản phải không. 

#### Interfaces for binding in ViewModel
Bây giờ chúng ta hãy cùng viết ViewModel theo những UIComponent dưới đây. 
- 1: tableView
- 2: cells
- 3: activity indicator

Chúng tôi tạo interface/properties cho biding PhotoListViewModel

```swift 
private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel]() {
    didSet {
        self.reloadTableViewClosure?()
    }
}
var numberOfCells: Int {
    return cellViewModels.count
}
func getCellViewModel( at indexPath: IndexPath ) -> PhotoListCellViewModel

var isLoading: Bool = false {
    didSet {
        self.updateLoadingStatus?()
    }
}
```

Với mỗi `PhotoListCellViewModel` thì sẽ là một cell trong table view. Nó cung cấp data interface để hiển thị một table cell. Chung ta put tất cả các `PhotoListCellViewModel` vào một array gọi là `cellViewModesl`, số lượng cell chính xác với số lượng item trong array. Chúng ta có thể nói array cellViewModels thì đại diện cho tableView. Mỗi lần update `cellViewModel` thì closure `realoadTableViewClosure` sẽ được gọi và table view sẽ update đúng với data source. 

Dưới đây là struct `PhotoListCellViewModel

```swift 
struct PhotoListCellViewModel {
    let titleText: String
    let descText: String
    let imageUrl: String
    let dateText: String
}
```

Như bạn có thể thấy, các thuộc tính của `PhotoListCellViewModel` cũng cấp interface cho binding đến các UI Component trong view.

#### Bind the view with the ViewModel
Với các interface cho binding, bây giờ chúng ta hãy tập trung vào View. Thứ nhất, trong `PhotoListViewController@, chúng ta khởi tạo callback closure ở `viewDidLoad`:

```swift 
viewModel.updateLoadingStatus = { [weak self] () in
    DispatchQueue.main.async {
        let isLoading = self?.viewModel.isLoading ?? false
        if isLoading {
            self?.activityIndicator.startAnimating()
            self?.tableView.alpha = 0.0
        }else {
            self?.activityIndicator.stopAnimating()
            self?.tableView.alpha = 1.0
        }
    }
}
    
viewModel.reloadTableViewClosure = { [weak self] () in
    DispatchQueue.main.async {
        self?.tableView.reloadData()
    }
}
```

Khi chúng thay thay đổi data source. trong MVC partent, chúng setup presentational logic ở trong `func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell`. Bây giờ chúng tôi phải chuyển vào trong ViewModel. Và khi đó data source sẽ trông như 

```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCellIdentifier", for: indexPath) as? PhotoListTableViewCell else { fatalError("Cell not exists in storyboard")}
		
    let cellVM = viewModel.getCellViewModel( at: indexPath )
		
    cell.nameLabel.text = cellVM.titleText
    cell.descriptionLabel.text = cellVM.descText
    cell.mainImageView?.sd_setImage(with: URL( string: cellVM.imageUrl ), completed: nil)
    cell.dateLabel.text = cellVM.dateText
		
    return cell
}
```

Flow của data bây giờ như sau: 
- 1: `PhotoListCellViewModel` thì sẽ lấy dữ liệu 
- 2: Sau khi đã lấy được data chúng ta sẽ tạo các đối tượng `PhotoListCellViewModel` và put chúng vào array `cellViewModels`
- 3: `PhotoListViewController` thì nhận được thông báo update và bắt đầu update lại UI

![](https://cdn-images-1.medium.com/max/1600/1*w4bDvU7IlxOpQZNw49fmyQ.png)

#### Xử lý tương tác của người dùng. 

Bây giờ chúng ta bắt đầu xử lý tương tác khi người dùng click vào cell trong table view. Trong `PhotoListViewModel` chúng ta tạo function sau:

```swift 
func userPressed( at indexPath: IndexPath )
```

Khi user click vào một cell, `PhotoListViewController` ( Chính là View) sẽ thông báo cho `PhotoListViewModel` gọi function `userPressed`. Vậy chúng ta có thể chỉnh sửa lại delegate method trong `PhotoListViewController` như sau:

```swift
func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {	
    self.viewModel.userPressed(at: indexPath)
    if viewModel.isAllowSegue {
        return indexPath
    }else {
        return nil
    }
}
```

Nó có nghĩa là `func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? ` thì được gọi khi người dùng tương tác( click vào cell), action thì chuyển qua `PhotoListViewModel`. Delegate thì sẽ quyết định xem action đó có được xử lý hay là bỏ qua dựa vào thuộc tính `isAlowSegueprovided` bởi `PhotoListViewModel`. Chúng ta đã thành công trong việc remove state từ View. 

#### The implementation of the PhotoListViewModel
Đó là một hành trình dài đúng không? Hãy chịu khó thêm chút nữa, bạn đang chạm đến phần cốt lõi của MVVM rồi đấy. Trong `PhotoListViewModel` chúng ta có một mảng gọi là `cellViewModel`, cái đại diện cho tableView trong View.

```swift 
private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel]()
```

Vậy làm như thế nào để có thể lấy được dữ liệu về? Chúng tôi thực sự làm hai việt trong quá trình khởi tạo ViewModel

- 1: Inject the dependency: the APIService
- 2: Fecth data sử dụng APIService

```swift
init( apiService: APIServiceProtocol ) {
    self.apiService = apiService
    initFetch()
}
func initFetch() {	
    self.isLoading = true
    apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
        self?.processFetchedPhoto(photos: photos)
        self?.isLoading = false
    }
}
```

Trong đoạn coe ở trên, chúng tôi đã set thuộc tính `isLoading = true ` trước khi bắt đầu fetch data từ APIService. Nhờ sự ràng buộc mà chúng ta đã làm trước đó, thiết lập isLoading = true có nghĩa là indicator sẽ load khi fetch data. Trong callback closure của `APIService`, chúng tôi đã set `isLoadig = false` sau khi lấy được danh sách các hình ảnh. Chúng tôi không cần trực tiếp thao tác với View, nhưng nó thì rõ ràng hơn, UI component thì làm việc khi mà có sự thay đổi thuộc tính ở ViewModel.

Dưới đây là implementation của `processFetchPhoto(photos: [Photo]`

```swift
private func processFetchedPhoto( photos: [Photo] ) {
    self.photos = photos // Cache
    var vms = [PhotoListCellViewModel]()
    for photo in photos {
        vms.append( createCellViewModel(photo: photo) )
    }
    self.cellViewModels = vms
}
```

Yay, chúng ta đã hoàn thành MVVM 

![](https://media.giphy.com/media/l0K4m0mzkJDAIdhHW/giphy.gif)

Bạn có thể tìm thấy mã nguồn ở trên [Github](https://github.com/koromiko/Tutorial/tree/MVC/MVVMPlayground)

#### Tóm tắt
Trong bài này, chúng ta đã thành công trong việc chuyển một ứng dụng từ mô hình kiến trúc MVC sang MVVM và chúng ta đã làm:
- Bingding sử dụng closure
- Removed toàn bộ controller logic từ View
- Có khả năng kiểm thử ViewModel.

#### Thảo luận
Như tôi đã nhắc ở trên, tất cả các kiến trúc thì đều có điểm cộng và điểm trừ. Sau khi đọc bài viết này của tôi, bạn phải có một vài suy nghĩ về điểm trừ của MVVM. Dưới đây là một vài bài blog nói về những điểm trừ của MVVM.

- [MVVM is Not Very Good — Soroush Khanlou](http://khanlou.com/2015/12/mvvm-is-not-very-good/)
- [The Problems with MVVM on iOS — Daniel Hall](http://www.danielhall.io/the-problems-with-mvvm-on-ios)

Vấn đề lớn nhất của MVVM thì là ViewModel làm quán nhiều việc. Như tôi đã nhắc ở trong bài viết này, chúng ta có controller và presenter trong ViewModel. Ngoài ra, hai vai trò, builder và router trong thì không bao gồm trong MVVM partent. Chúng tôi đã đặt chúng trong ViewController. Nếu bạn quan tâm đến một giải pháp tốt hơn, bạn nên thử tìm hiểu MVVM+FlowController or VIPER và Clean by Uncle BOB



