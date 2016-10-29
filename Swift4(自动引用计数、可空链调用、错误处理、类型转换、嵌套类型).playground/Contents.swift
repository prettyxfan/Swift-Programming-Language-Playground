//: Playground - noun: a place where people can play

import UIKit

// 类实例之间的循环引用

// 下面两个类会造成循环强引用
/*
class Person {
    let name: String
    init(name: String) {
        self.name = name
    }
    var apartment: Apartment?
    deinit {
        print("Apartment \(name) is being deinitialized")
    }
}

class Apartment {
    let unit: String
    init(unit: String) {
        self.unit = unit
    }
    var tenat: Person?
    deinit {
        print("Apartment \(unit) is being deinitialized")
    }
}
 */

// 解决实例之间的循环强引用：弱引用和无主引用
// 对生命周期中会变为nil的实例使用弱引用，相反地，对于初始化赋值后再也不会被赋值为nil的实例使用无主引用

// 弱引用：不会对其引用的实例保持强引用，不会阻止ARC销毁被引用的实例。因为弱引用可以没有值，所以必须将每一个弱引用声明为可选类型

class Person {
    let name: String
    init(name: String) {
        self.name = name
    }
    var apartment: Apartment?
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    let unit: String
    init(unit: String) {
        self.unit = unit
    }
    weak var tenat: Person?
    deinit {
        print("Apartment \(unit) is being deinitialized")
    }
}

var john: Person?
var unit4A: Apartment?

john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

john!.apartment = unit4A
unit4A!.tenat = john

john = nil
unit4A = nil

// 无主引用：无主引用不会保持住引用的实例。和弱引用不同的是无主引用是永远有值的。
// 如果你试图在实例被销毁后访问该实例的无主引用。会触发运行时的错误。使用无主引用必须确保始终指向一个未销毁的引用

class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit {
        print("Card #\(number) is being deinitialized")
    }
}

var johner: Customer?
johner = Customer(name: "johner")
johner!.card = CreditCard(number: 1234_1234_1234_1234, customer: johner!)

johner = nil

// 无主引用以及隐式解析可选属性：存在第三种场景，两个属性都必须有值，并且初始化完成后永远不会为nil。这时候需要一个类使用无主属性，而另外一个类用隐式解析可选属性
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}

// 闭包引起的循环强引用
// 循环强引用还会发生在当你讲一个闭包赋值给实例的某个属性并且这个闭包中用使用了这个实例
// 闭包也是引用类型。
class HTMLElement {
    let name: String
    let text: String?
    
    lazy var asHTML: (Void) -> String = {
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

let heading = HTMLElement(name: "h1")
let defaultText = "some default text"
heading.asHTML = {
    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}
print(heading.asHTML())
/*
    实例的asHTML属性持有闭包的强引用。
    但是，闭包在其闭包体内使用了self（引用了self.name和self.text），
    因此闭包捕获了self，这意味着闭包又反过来持有了HTMLElement实例的强引用。
    这样两个对象就产生了循环强引用。
*/

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())

paragraph = nil //没有被释放！

// 解决闭包引起的循环强引用
// 定义捕获列表（在定义闭包的时候同时定义捕获列表作为闭包的一部分）：捕获列表中的每一项都由一对元素组成，一个元素师 weak 或 unowned 关键字，另一个元素师类实例的引用（如 self）或初始化过的变量（如 delegate = self.delegate）。这些项在方括号中用逗号分开。如果闭包有参数列表和返回类型，把捕获列表放在它们前面。

/*
lazy var someClosure: (Int, String) -> String = {
    [unowned self, weak delegate = self.delegate!](index: Int, stringToProcess: String) -> String in
    // closure body goes here
}
 */

// 如果闭包没有指明参数列表或者返回类型，即它们会通过上下文推断，那么刻意把捕获列表和关键字 in 放在闭包最开始的地方

/*
lazy var someClosure: Void -> String = {
    [unowned self, weak delegate = self.delegate!] in
    // closure body goes here
}
*/

// 弱引用和无主引用
// 在闭包和捕获的实例总是相互引用并总是同时销毁时，将闭包内的捕获定义为无主引用
// 在捕获的引用可能为 nil 时，将闭包内的捕获定义为弱引用


class AnotherHTMLElement {
    let name: String
    let text: String?
    
    lazy var asHTML: (Void) -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

var paragraph2: AnotherHTMLElement? = AnotherHTMLElement(name: "p", text: "hello, world")
print(paragraph2!.asHTML())

paragraph2 = nil //被释放

// 可空链式调用
// 使用可空链式调用来强制展开
class AnotherPerson {
    var residence: Residence?
}

class Room {
    let name: String
    init(name: String) {
        self.name = name
    }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        } else if buildingNumber != nil {
            return buildingNumber
        } else {
            return nil
        }
    }
}

class Residence {
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Address?
}

let johoh = AnotherPerson()

if let roomCount = johoh.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}

// 用可空链式调用时，这个方法返回的类型为 Void？ 而不是 Void，所以即使该方法没有返回值也可以在if语句里判断
if johoh.residence?.printNumberOfRooms() != nil {
    print("It was possible to print the number of rooms.")
} else {
    print("It was not possible to print the number of rooms.")
}

// 可以判断通过可空链式调用来给属性赋值是否成功
let someAddress = Address()
someAddress.buildingNumber = "29"
someAddress.street = "Acacia Road"

if (johoh.residence?.address = someAddress) != nil {
    print("It was possible to set the address")
}
else {
    print("It was not possible to set the address")
}

// 通过可空链式调用可以用下标来对可空值进行读写，并判断下标调用是否成功
// 当通过可空链式调用访问可空值当下标时，应该将问好放在下标括号对前面而不是后面
if let firstRomeName = johoh.residence?[0].name {
    print("The first room name is \(firstRomeName)")
}
else {
    print("Unable to retrieve the first room name.")
}

johoh.residence?[0] = Room(name: "Bathroom")

let johnsHouse = Residence()
johnsHouse.rooms.append(Room(name: "Living Room"))
johoh.residence = johnsHouse

if let firstRoomName = johoh.residence?[0].name {
    print("The first room name is \(firstRoomName)")
}
else {
    print("Unable to retrieve the first room name.")
}

// 访问可空类型的下标
// 如果下标返回可空类型值，eg：dictionary 的 key 下标。可以在下标的闭合括号后面放一个问号来链接下标的可空返回值
var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1
testScores["Brian"]?[0] = 72

// 多层链接
/*
 如果你访问的值不是可空的，通过可空链式调用将会放回可空值。
 如果你访问的值已经是可空的，通过可空链式调用不会变得“更”可空。
 
 通过可空链式调用访问一个Int值，将会返回Int?，不过进行了多少次可空链式调用。
 类似的，通过可空链式调用访问Int?值，并不会变得更加可空。
*/

if let johnsStreet = johoh.residence?.address?.street {
    print("John's street name is \(johnsStreet).")
} else {
    print("Unable to retrieve the address.")
}

// 对返回可空值的函数进行链接
if let beginsWithThe = johoh.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
    if beginsWithThe {
        print("John's building identifier begins with \"The\".")
    } else {
        print("John's building identifier does not begin with \"The\".")
    }
}
else {
    print("Unable to retrieve the address.")
}

// 错误处理
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

// throwing 函数传递错误
// func canTrowErrors() throws -> String
struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    
    var coinsDeposited = 0
    
    func dispenseSnack(_ snack: String) {
        print("Dispensing \(snack)")
    }
    
    func vend(itemNamed name: String) throws {
        guard var item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        item.count -= 1
        inventory[name] = item
        dispenseSnack(name)
    }
}

// 因为vend(itemNamed:)方法会传递出它抛出的任何错误，在你代码中调用它的地方必须要么直接处理这些错误 - 使用do-catch语句，try?或try!，要么继续将这些错误传递下去

let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]

func buyFavoriteSnack(_ person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
}

// Do-Catch 处理错误
/*
 do {
    try expression
    statements
 }catch pattern 1 {
    statements
 }catch pattern 2 where condition {
     statements
 }
 */

// catch语句不必将do语句中代码所抛出的每个可能的错误都处理。如果没有一条catch字句来处理错误，错误就会传播到周围的作用域。然而错误还是必须要被某个周围的作用域处理的 - 要么是一个外围的do-catch错误处理语句，要么是一个throwing函数的内部。
var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
    try buyFavoriteSnack("Alice", vendingMachine: vendingMachine)
} catch VendingMachineError.invalidSelection {
    
} catch VendingMachineError.outOfStock {
    
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    
}

// 将错误转换成可选值：使用 try？ 通过将其转换成一个可选值来处理错误

/*
func someThrowingFunction() throws -> Int {
    // ...
}

let x = try? someThrowingFunction()

let y: Int?

do {
    y = try someThrowingFunction()
} catch {
    y = nil
}
 */

// 使错误传递失效

// let photo = try! loadImage("./Resource/John Appleseed.jpg")

// 指定清理操作：defer
/*
func processFile(filename: String) throws {
    if exists(filename) {
        let file = open(filename)
        defer {
            close(file)
        }
        while let line = try file.readline() {
            // 处理文件
        }
        // 在这里，作用域的最后调用 close(file)
    }
}
*/

// 类型转换
class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]

// 类型检查（is）
var movieCount = 0
var songCount = 0

for item in library {
    if item is Movie {
        movieCount += 1
    }
    else if item is Song {
        songCount += 1
    }
}

// 向下转型
// 某类型的一个常量或变量可能在幕后实际上属于一个子类。当确定是这种情况时，你可以尝试向下转到它的子类型，用类型转换操作符(as? 或 as!)

for item in library {
    if let movie = item as? Movie {
        print("\(movie.name), dr. \(movie.director)")
    }
    else if let song = item as? Song {
        print("\(song.name), by \(song.artist)")
    }
}

// Any 和 AnyObject 的类型转换
// AnyObject 可以代表任何 class 类型的实例
// Any 可以表示任何类型，包括方法类型
// AnyObject 类型

let someObjects: [AnyObject] = [
    Movie(name: "2001: A Space Odyssey", director: "Stanley Kubrick"),
    Movie(name: "Moon", director: "Duncan Jones"),
    Movie(name: "Alien", director: "Ridley Scott")
]

for object in someObjects {
    let movie = object as! Movie
    print("Movie: '\(movie.name)', dir. \(movie.director)")
}

for movie in someObjects as! [Movie] {
    print("Movie: '\(movie.name)', dir. \(movie.director)")
}

// Any 类型
// 可以使用 Any 类型来混合不同类型一起工作
var manyThings = [Any]()

manyThings.append(0)
manyThings.append(0.0)
manyThings.append(42)
manyThings.append(3.14159)
manyThings.append("hello")
/* 报错
manyThings.append((3.0, 5.0))
manyThings.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
manyThings.append({(name: String) -> String in "Hello, \(name)"})
 */

for thing in manyThings {
    switch thing {
    case 0 as Int:
        print("zero as an Int")
    case 0 as Double:
        print("zero as a Double")
    case let someInt as Int:
        print("an integer value of \(someInt)")
    case let someDouble as Double where someDouble > 0:
        print("a positive double value of \(someDouble)")
    case is Double:
        print("some other double value that I don't want to print")
    case let someString as String:
        print("a string value of \"\(someString)\"")
    case let (x, y) as (Double, Double):
        print("an (x, y) point at \(x), \(y)")
    case let movie as Movie:
        print("a movie called '\(movie.name)', dir. \(movie.director)")
    case let stringConverter as (String) -> String:
        print(stringConverter("Michael"))
    default:
        print("something else")
    }
}

// 嵌套类型
struct BlackjackCard {
    enum Suit: Character {
        case spades = "A", hearts = "B", diamonds = "C", clubs = "D"
    }
    
    enum Rank: Int {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king, ace
        struct Values {
            let first: Int, second: Int?
        }
        var values: Values {
            switch self {
            case .ace:
                return Values(first: 1, second: 11)
            case .jack, .queen, .king:
                return Values(first: 10, second: nil)
            default:
                return Values(first: self.rawValue, second: nil)
            }
        }
    }
    
    let rank: Rank, suit: Suit
    var description: String {
        var output = "suit is \(suit.rawValue)"
        output += " value is \(rank.values.first)"
        if let sencond = rank.values.second {
            output += " or \(sencond)"
        }
        return output
    }
}

let theAceOfSpades = BlackjackCard(rank: .ace, suit: .spades)
print(theAceOfSpades.description)

// 嵌套类型的引用
let heartsSymbol = BlackjackCard.Suit.hearts.rawValue
































