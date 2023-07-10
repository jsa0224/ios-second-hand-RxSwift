# Second-Hand

![Online Shop-Mobile App UI (Community)](https://github.com/jsa0224/ios-second-hand-RxSwift/assets/94514250/d8d8a691-a09f-4cad-8d54-8fac12588306)

> 기존의 야곰 아카데미에서 진행한 토이 프로젝트 Open Marketd을 RxSwift와 MVVM, Clean Architecture, Coordinator를 활용하여 리팩토링한 프로젝트입니다.

> 개발기간: 2023.05.22 - 2023.07.07

## 🗂️ 목차
- [소개](#-프로젝트-소개)
- [개발 인원](#-개발-인원)
- [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
- [프로젝트 주요 기능](#-프로젝트-주요-기능)
- [아키텍처](#-아키텍처)

## 🏷️ 프로젝트 소개
'Second-Hand'는 사용자들이 더 이상 필요하지 않은 제품을 판매하고, 필요한 제품을 저렴하게 구매할 수 있는 편리한 플랫폼을 제공합니다.

## ☁️ 개발 인원
|[som](https://github.com/jsa0224)|
|:---:|
|<img src=https://github.com/jsa0224/ios-second-hand-RxSwift/assets/94514250/c130ceb8-9a7b-44fe-b0df-bc2672067feb width="200" height="200">

## ⚙️ 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]() [![Xcode](https://img.shields.io/badge/Xcode-16.2-blue)]() [![RxSwift](https://img.shields.io/badge/RxSwift-6.5.0-purple)]() [![RxDataSource](https://img.shields.io/badge/RxDataSource-5.0-purple)]() [![CoreData](https://img.shields.io/badge/CoreData-3.0+-green)]() [![OpenMarket](https://img.shields.io/badge/OpenMarket-sever-red)]()

## 📱 프로젝트 주요 기능
|상품 리스트 화면|상품 검색 화면|상품 상세 화면|
|:---:|:---:|:---:|
|<img src=https://github.com/jsa0224/ios-second-hand-RxSwift/assets/94514250/d91ea652-91de-4732-ab70-54c6a358cd47 width="300">|<img src=https://github.com/jsa0224/ios-second-hand-RxSwift/assets/94514250/12e99297-b1b9-45b7-9df0-30f479f7f4d8 width="300">|<img src=https://github.com/jsa0224/ios-second-hand-RxSwift/assets/94514250/f16378c3-79c8-496b-8142-b76d0880fe81 width="300">|

|관심 상품 등록|관심 상품 삭제 기능|장바구니 상품 등록|장바구니 상품 삭제 기능|
|:---:|:---:|:---:|:---:|
|<img src=https://github.com/jsa0224/ios-second-hand-RxSwift/assets/94514250/05d28753-31cb-4d51-98cd-11187fab452d width="200">|<img src=https://github.com/jsa0224/ios-second-hand-RxSwift/assets/94514250/0ad5d921-5072-4ca5-b9ac-0982753bf865 width="200">|<img src=https://github.com/jsa0224/ios-second-hand-RxSwift/assets/94514250/5cd53e5c-4cbe-44c2-af02-e38785c877cd width="200">|<img src=https://github.com/jsa0224/ios-second-hand-RxSwift/assets/94514250/f565c8b2-0762-41ba-a621-501513720a92 width="200">|

## ⚒️ 아키텍처
### 🌲 파일트리
<details>
<summary>세부사항</summary>
<div markdown="1">
    
```
SecondHand
├── App
│   ├── Coordinator
│   │   ├── Coordinator    
│   │   └── AppCoordinator 
│   ├── AppDelegate
│   └── SceneDelegate
├── Data
│   ├── Network
│   │   ├── NetworkManager
│   │   ├── ItemNetworkManager  
│   │   ├── NetworkError 
│   │   └── ImageCacheManager    
│   ├── CoreData
│   │   ├── CoreDataManager
│   │   ├── CoreDataManageable
│   │   └── CoreDataError      
│   ├── Repositories
│   │   ├── ItemListRepository
│   │   └── ItemRepository
│   └── ResponseModel
│       ├── CoreData
│       │   ├── ItemDAO+CoreDataClass
│       │   └── ItemDAO+CoreDataProperties    
│       └── Network
│           ├── ProductList
│           ├── Product
│           └── ProductForm     
├── Domain
│   ├── InterFaces
│   │   ├── Repositories
│   │   │   ├── CoreDataRepository
│   │   │   └── NetworkRepository
│   ├── Entities
│   │   ├── Item
│   │   └── ItemForm
│   └── UseCases
│       ├── Protocol
│       │   ├── ItemListUseCaseType
│       │   ├── ImageUseCaseType
│       │   └── ItemUseCaseType
│       ├── ItemListUseCase
│       ├── ImageUseCase
│       └── ItemUseCase
├── Presentation
│   ├── CommonView
│   │   ├── Alert
│   │   │   ├── AlertActionType
│   │   │   └── AlertManager
│   │   ├── Item
│   │   │   └── WorkItem
│   │   ├── View
│   │   │   ├── PriceView
│   │   │   ├── Label
│   │   │   │   └── TotalPriceLabel
│   │   │   ├── GridView
│   │   │   └── ListView
│   │   └── Cell
│   │       ├── Section
│   │       │   └── ItemSection    
│   │       ├── ListCell
│   │       │   ├── ViewModel
│   │       │   │   └── TableViewCellViewModel
│   │       │   └── ItemTableViewCell
│   │       └── GridCell
│   │           ├── ViewModel
│   │           │   └── GridCellViewModel
│   │           └── ItemGridCollectionViewCell
│   ├── HomeView
│   │   ├── Coordinator
│   │   │   └── HomeCoordinator 
│   │   ├── ViewModel
│   │   │   └── HomeViewModel
│   │   └── View
│   │       └── HomeViewController
│   ├── SearchView
│   │   ├── Coordinator
│   │   │   └── SearchCoordinator 
│   │   ├── ViewModel
│   │   │   └── SearchViewModel
│   │   └── View
│   │       └── SearchViewController    
│   ├── DetailView
│   │   ├── Coordinator
│   │   │   └── DetailCoordinator     
│   │   ├── ViewModel
│   │   │   └── DetailViewModel
│   │   └── View
│   │       ├── DetailView
│   │       └── DetailViewController
│   ├── FavoriteView
│   │   ├── Coordinator
│   │   │   └── FavoriteCoordinator 
│   │   ├── ViewModel
│   │   │   └── FavoriteViewModel
│   │   └── View
│   │       └── FavoriteViewController 
│   └── CartView
│       ├── Coordinator
│       │   └── CartCoordinator    
│       ├── ViewModel
│       │   └── CartViewModel
│       └── View
│           └── CartViewController
├── Util
├── Legacy    
└── Resource
```
</div>
</details>


### 📊 다이어그램
![오픈마켓 다이어그램 (16)](https://github.com/jsa0224/ios-second-hand-RxSwift/assets/94514250/ac7a6929-cf42-4d37-a6b1-1ac238ea4d0f)

> **Clean Architecture**
- MVVM 아키텍처로 구현하면서도 객체를 어느 파일에 구현하면 좋을 지, 의문이 생겨 해당 아키텍처를 공부하게 되었습니다.
- 도메인, 비즈니스 모델, 유즈케이스 등을 활용하면서 내부 레이어에서 외부 레이어로 종속성을 갖지 않도록 유의했습니다.

> **MVVM** 
- MVC 패턴을 사용하면서, Controller의 역할이 비대해져 역할 분리가 안 된다는 생각이 들어, MVVM을 공부하게 되었습니다.
- ViewModel, View 객체를 통해 역할 분리를 하였고, 기존 ViewController의 코드 2배가량 줄일 수 있었습니다.
- 화면 전환을 담당하는 Coordinator 객체가 있다면 역할 분리가 더 명확해진다는 것을 깨닫고, 다음 프로젝트에 적용해볼 생각입니다.

> **Input & Output**
- 뷰모델을 Input과 Output으로 정의하여 뷰의 이벤트들을 Input에 바인딩하고, 뷰에 보여질 데이터를 Output에 바인딩했습니다.
- 일관성 있고 직관적인 구조를 유지해 뷰모델의 코드 가독성이 높아졌습니다. 

> **Coordinator Pattern**
- Coordinator 패턴은 앱의 각 화면 또는 기능을 개별적인 Coordinator 객체로 분리함으로써 단일 책임 원칙을 따릅니다. 각 Coordinator는 해당 화면 또는 기능에 대한 네비게이션 및 비즈니스 로직을 담당하므로 코드의 응집성과 유지보수성이 향상되었습니다.
- 각 화면은 독립적인 Coordinator로 관리되며, 필요에 따라 새로운 Coordinator를 추가하거나 기존 Coordinator를 수정하거나 제거할 수 있었습니다.
