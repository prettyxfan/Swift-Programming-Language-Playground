//: Playground - noun: a place where people can play

import UIKit

/* =========== 开篇 ============= */
// dictronary 遍历
let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largest = 0
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
        }
    }
}
print(largest)

enum Rank : Int {
    case Ace
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    
    func simpleDescription() -> String {
        switch self {
        case .Ace:
            return "ace"
        case .Jack:
            return "jack"
        case .Queen:
            return "queen"
        case .King:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}
let ace = Rank.Four
let aceRawValue = ace.rawValue
let numberRawValue = Rank.Ten.rawValue

if let convertedRank = Rank(rawValue: 3) {
    let threeDescription = convertedRank.simpleDescription()
}

enum Suit {
    case Spades, Hearts, Diamonds, Clubs
    func simpleDescription() -> String {
        switch self {
        case .Spades:
            return "spades"
        case .Hearts:
            return "hearts"
        case .Diamonds:
            return "diamonds"
        case .Clubs:
            return "clubs"
        }
    }
}

//结构体是传值， class 是传引用
struct Card {
    var rank: Rank
    var suit: Suit
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
}

let threeOfSpades = Card(rank: .Three, suit: .Spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()


//MARK: - important!
enum ServerResponse {
    case Result(String, String)
    case Error(String)
}

let success = ServerResponse.Result("6:00 am", "8:09 pm")
let failure = ServerResponse.Error("Out of cheese.")

switch success {
case let .Result(sunrise, sunset):
    let serverResponse = "Sunrise is at \(sunrise) and sunset is at \(sunset)"
case let .Error(error):
    let serverReponse = "Failure..\(error)"
}

//协议和扩展
protocol ExampleProtocol {
    var simpleDescription: String { get }
    mutating func ajust()
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class"
    var anotherPropety: Int = 68105
    func ajust() {
        simpleDescription += " Now 100% adjusted."
    }
}

var a = SimpleClass()
a.simpleDescription
a.ajust()
let aDescription = a.simpleDescription

struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    mutating func ajust() {
        simpleDescription += "(ajusted)"
    }
}

var b = SimpleStructure()
b.ajust()
let bDescription = b.simpleDescription

//注意：声明 SimpleStructure 时 mutating 关键字用来标记一个会修改结构体的方法，SimpleClass 的声明不需要标记任何方法，以为类中的方法通常可以修改属性（类的兴致）

extension Int: ExampleProtocol {
    var simpleDescription : String {
        return "The number \(self)"
    }
    
    mutating func ajust() {
        self += 42
    }
    
}

print(7.simpleDescription)

let protocalValue: ExampleProtocol = a
//当处理类型是协议值时， 协议外定义的方法不可用
//print(protocalValue.anotherPropety)


//泛型
func repeatItem<Item>(item: Item, numberOfTimes: Int) -> [Item] {
    var result = [Item]()
    for _ in 0..<numberOfTimes {
        result.append(item)
    }
    return result
}

repeatItem(item: "Knock", numberOfTimes: 4)

//可以创建泛型函数、方法、类、枚举和结构体
enum OptionalValue<Wrapped> {
    case None
    case Some(Wrapped)
}

var possibleInteger: OptionalValue<Int> = .None
possibleInteger = .Some(100)

//在类型后面用 where 来指定对类型的需求: 如 限定类型实现某个协议，限定两个类型是相同的或限定某个类必须有一个特定的父类
func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool where T.Iterator.Element: Equatable, T.Iterator.Element == U.Iterator.Element {
    for lhsLItem in lhs {
        for rhslItem in rhs {
            if lhsLItem == rhslItem {
                return true
            }
        }
    }
    return false
}

//SequenceType: 协议（能实现 for..in）; Equatable：协议（能做 == or =! 比较）
anyCommonElements([1, 2, 3], [3])

// <T: Equatable> 和 <T where T: Equatable> 是等价的

//常量和变量
var red, green, blue: Double

//一旦声明，就不能改变其存储的类型，也不能将常量和变量进行互转。 如果需要使用与swift保留关键字相同的名称作为常量或者变量名，可以用反引号(`)将关键字包围的方式作为名字使用

//整数范围
let minValue = UInt8.min
let maxValue = UInt8.max

// 在 32 位平台上， Int 和 Int32 长度相同；在 64 位平台上，Int 和 Int64 长度相同
// 在推断浮点数类型时，swift 总是会选择 double 而不是 float

let decimalInteger = 17
let binaryInteger = 0b10001 //二进制17
let octalInteger = 0o21 //八进制17
let hexadecimalInteger = 0x11 //16进制17

let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1

// 类型转换
let twothousand: UInt16 = 2_000
let one: UInt8 = 1
let twoThousandAndOne = twothousand + UInt16(one)

// SomeType(ofInitialValue) 是调用swift构造器并传入一个初始值的默认方法。并不能传入任意值，但是可以扩展现有类型使其可以接收其他类型的值

// 类型别名
typealias AudioSample = UInt16
var maxAmplitudeFound = AudioSample.min

// 元组(tuples)，元组内的值可以是任意类型，不要求是相同类型
let http404Error = (404, "Not Found")
let (statusCode, statusMessage) = http404Error
print("The status code is \(statusCode)")
print("The status message is \(statusMessage)")

let (justTheStatusCode, _) = http404Error
print("The status code is \(justTheStatusCode)")

print("The status code is \(http404Error.0)")
print("The status message is \(http404Error.1)")

let http200Status = (statusCode: 200, description: "OK")
print("The status code is \(http200Status.statusCode)")
print("The status message is \(http200Status.description)")

let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)

var serverResponseCode: Int? = 404
serverResponseCode = nil

// 可选绑定(optional binding)，可以用在 if 和 while 语句中
if let actualNumber = Int(possibleNumber) {
    print("\'\(possibleNumber)\' has an integer value of \(actualNumber)")
}
else {
    print("\'\(possibleNumber)\' could not be converted to an integer")
}

if let firstNumber = Int("4"), let secondNumber = Int("42") , firstNumber < secondNumber {
    print("\(firstNumber) < \(secondNumber)")
}

// 隐式解析可选类型，只要第一次赋值后可以保证之后都有值
var assumedString: String!
assumedString = "An implicitly unwrapped optional string"
// 依然可以用if语句判断是否有值
if assumedString != nil {
    print(assumedString)
}

if let definiteString = assumedString {
    print(definiteString)
}

// 错误处理
func canTrowAnError() throws {
    // 这个函数有可能抛出错误
}

do {
    try canTrowAnError()
}
catch {
    
}

func makeASandwich() throws {
    // ...
}
//
//do {
//    try makeASandwich()
//    eatASandwich()
//}
//catch Error.OutOfCleanDishes {
//    washDishes()
//}
//catch Error.MissingIngredients(let ingredients) {
//    buyGroceries(ingredients)
//}


// 断言 assert(_:_file:line:)
let age = -3
//assert(age > 0, "A person's age connot be less than zero") //(Bool, String) bool为false时触发断言
//assert(age > 0)

/*
    断言使用场景：
    1. 整数类型的下标索引被传入一个自定义下标脚本实现，但下标索引值可能太大或太小
    2. 需要给函数传入一个值，但是非法的值可能会导致函数不能正常运行
    3. 一个可选值现在是nil，但后面的代码运行需要一个非nil的值
 */

// 基本运算符
// = 运算不返回值，以免 == 和 = 写错；＋ － ＊ ／ ％ 会检测并不允许值溢出
// swift 中 ％ 可以对浮点数取余

let (x, y) = (1, 2)
if x == y {
    //
}
"hello, " + "world"
-9 % 4
9 % -4 //在对负数取余时，会忽略符号

let minusSix = -6
let alsoMinusSix = +minusSix //一元正号运算符不会做任何改变地返回操作数的值

// 空运算符 a ?? b，对可选类型 a 进行空判断，如果 a 包含一个值就进行解封，否则返回一个默认值 b（a必须时Optional类型， b的类型必须要和a的存储值的类型保持一致），等价于 a != nil ? a!:b
let defaultColorName = "rad"
var userDefinedColorName: String?

var colorNameToUse = userDefinedColorName ?? defaultColorName

userDefinedColorName = "green"
colorNameToUse = userDefinedColorName ?? defaultColorName

// 区间运算符：
// 闭区间运算符(a...b)，区间包涵 a 和 b，且 b >＝ a。
for index in 1...5 {
    print("\(index) * 5 = \(index * 5)")
}
// 半开区间预算符(a..<b)，区间包涵 a 不包含 b
let names = ["Anna", "Alex", "Brian"]
for i in 0..<names.count {
    print("第 \(i + 1) 个人叫 \(names[i])")
}

// && 和 || 都是短路计算， && 和 || 都是左结合的

// 字符串和字符 （NSString 和 String 无缝桥接），字符串是值类型
// String 中每一个字符串都是由编码无关的 Unicode 字符组成，并支持访问字符的多种 Unicode 表现形式（representations）

// 初始化
var emptyString = ""
var anotherEmptyString = String()

emptyString == anotherEmptyString

if emptyString.isEmpty {
    print("string empty")
}

for character in "Dog!🐶".characters {
    print(character)
}

let exclamationMark: Character = "!"

let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
let catString = String(catCharacters)
print(catString)

var instruction = "look over"
instruction += "there"

instruction.append(exclamationMark)

//instruction += exclamationMark, 错误！ 两个类型不同

let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐫"
print(unusualMenagerie.characters.count)


// 每一个Swift的Character类型代表一个可扩展的字形群
var word = "cafe"
print("the number of characters in \(word) is \(word.characters.count)")

word += "\u{301}"

print("the number of characters in \(word) is \(word.characters.count)")

// 可扩展的字符集群可以组成一个或多个 Unicode 标量。这意味着不同的字符以及相同的字符的不同表示可能需要不同数量的内存空间来存储。所以 Swift 中的字符在一个字符串中并不一定占用相同的内存空间数量
// 通过 characters 属性返回的字符数量并不总是与包含相同字符的 NSString 的 length 属性相同。 NSString 的 length 属性是利用 UTF-16 表示的十六位代码单元数字，而不是 Unicode 可扩展的字符群集

print("the length of \(word) is \(NSString(string: word).length)")

// 字符串索引
// startIndex 可以获取 String 的第一个 Character 的索引
// endIndex 可以获取最后一个 Character 的后一个位置的索引，因此 endIndex 属性不能作为一个字符串的有效下标
// 如果字符串是空的，startIndex 和 endIndex 是相等的。
// 调用 String.index 的 predecessor() 可以立即得到前一个索引
// 调用 String.index 的 successor() 可以立即得到后一个索引

let greeting = "Guten Tag!"
greeting[greeting.startIndex]

// greeting[greeting.endIndex.predecessor()] 改为
greeting[greeting.index(before: greeting.endIndex)]

//greeting[greeting.startIndex.successor()] 改为
greeting[greeting.index(after: greeting.startIndex)]

//greeting[greeting.startIndex.advancedBy(7)] 改为
let index = greeting.index(greeting.startIndex, offsetBy: 7)


// 使用 characters 属性的 indices 属性会创建一个包含全部索引的范围（Range），用来在一个字符串中访问单个字符
for index in greeting.characters.indices {
    print("\(greeting[index])", terminator:" ")
}

// 插入和删除

// insert(_:atIndex:) 指定位置插入字符
var welcome = "hello"
welcome.insert("!", at: welcome.endIndex)

// insertContentsOf(_:at:) 指定位置插入字符串
welcome.insert(contentsOf: " there".characters, at: welcome.index(before: welcome.endIndex))

// removeAtIndex(_:) 指定索引删除字符
welcome.remove(at: welcome.index(before: welcome.endIndex))

// removeRange(_:) 指定索引删除字符串
let range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex
welcome.removeSubrange(range)

// 比较字符串

// 前缀／后缀相等（Prefix and Suffix Equality）
// hasPrefix(_:) / hasSuffix(_:)
let romeoAndJuliet = "Act 1 Secene 1: Verona, A public place"
romeoAndJuliet.hasPrefix("Act")
romeoAndJuliet.hasSuffix("cell")


// 字符串的 Unicode 表示
let dogString = "Dog!!🐶"

// utf-8 表示
for codeUnit in dogString.utf8 {
    print("\(codeUnit)", terminator:" ")
}
// 68 111 103 33 33 240 159 144 182 

// utf-16 表示
for codeUnit in dogString.utf16 {
    print("\(codeUnit)", terminator:" ")
}
//  68 111 103 33 33 55357 56374 

// unicode 标量表示
for codeUnit in dogString.unicodeScalars {
    print("\(codeUnit)", terminator:" ")
}
// D o g ! ! 🐶


// 集合类型 Array(有序) Set（无序无重复） Dictionary（无序的键值对）
var someInts = [Int]()
someInts.append(3)
someInts = []

var threeDoubles = [Double](repeating: 0.0, count: 3)
var anotherThreeDoubles = Array(repeating: 2.5, count: 3)

var sixDoubles = threeDoubles + anotherThreeDoubles
var shoppingList = ["Eggs", "Milk"]

shoppingList.count

// isEmpty 作为检查 count 属性是否为 0
if shoppingList.isEmpty {
    print("Shopping list is empty")
}
else {
    print("Shopping list is not empty")
}

// append(_:) 在数组后添加新数据
shoppingList.append("Flour")

shoppingList += ["Baking Powder"]

shoppingList += ["Chocolate Spread", "Cheese", "Butter"]

var fistItem = shoppingList[0]

shoppingList[0] = "Six eggs"

// 利用下标一次性改变一系列数据
shoppingList

shoppingList[4...6] = ["Bananas", "Apples"]
shoppingList

// insert(_:atIndex:) 在某个具体索引值之前添加数据
shoppingList.insert("Maple Syrup", at: 0)

// removeAtIndex(_:) 移除数组中的一项并返回这个被移除的数据项
let mapleSyrup = shoppingList.remove(at: 0)

// removeLast() 移除数组最后一项
let apples = shoppingList.removeLast()

// 数组遍历
for item in shoppingList {
    print(item)
}

// 同时需要每个数据项的值和索引值，可以用enumerate()方法遍历。enumerate 方法返回一个由每个数据项索引值和数据值组成的元组
for (index, value) in shoppingList.enumerated() {
    print("item \(String(index + 1)): \(value)")
}

// 集合 Set

// 集合类型的哈希值：一个类型未来存储在集合中，该类型必须是可哈希化的，也就是该类型必须提供一个方法来计算它的哈希值
// swift 所有基本类型都是可哈希化的（String，Int，Double，Bool）。没有关联值的枚举成员值默认也是可哈希化的
// 自定义类型要放入集合，需要实现 Hashable 协议，即要提供一个类型为 Int 的可读属性 hashValue。
// Hashable 协议 符合 Equatable 协议，所以符合该协议的类型需要提供一个“是否相等”运算符（==）的实现
// 要满足： a==a; a==b 则 b==a; a==b && b==c 则 a==c

var letters = Set<Character>()
letters.insert("a")
letters = []

var favoriteGenres: Set = ["Rock", "Classical", "Hip hop"] //需要显示的写出Set，不然会被推断成Array

favoriteGenres.count

if favoriteGenres.isEmpty {
    print("Empty")
}

favoriteGenres.insert("Jazz")

if let removedGenre = favoriteGenres.remove("Rock") {
    print("\(removedGenre)? I'm over it.")
}

// contains(_:) 检查 Set 中是否包含一个特定的值
if favoriteGenres.contains("Funk") {
    //
}

// Set 类型无序，可以提供一个sort方法来遍历
for genre in favoriteGenres.sorted() {
    print(genre)
}

// Set 基本操作
// intersect(_:) 根据两个集合中都包含的值创建一个新的集合
// exclusiveOr(_:) 根据在一个集合中但不在两个集合中的值创建一个新的集合
// substract(_:) 根据不再该集合中的值创建一个新的集合

var oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

oddDigits.union(evenDigits).sorted()
oddDigits.intersection(evenDigits).sorted()
oddDigits.subtracting(singleDigitPrimeNumbers).sorted()
oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()

// 集合成员关系和相等
// == 运算符来判断两个集合是否包含全部相同的值
// isSubsetOf(_:) 判断一个集合是否是一个集合的子集
// isStrictSubSetOf(_:) 判断集合是否是一个集合的真子集
// isSupersetOf(_:) 判断集合是否是一个集合的父集
// isDisjointWith(_:) 判断两个集合是否不含有相同的值

let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐂", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]

houseAnimals.isSubset(of: farmAnimals)
farmAnimals.isSuperset(of: houseAnimals)
farmAnimals.isDisjoint(with: cityAnimals)

// 字典
// Dictionary<Key, Value>, key 必须遵循 hashable 协议
var namesOfIntegers = [Int: String]()
namesOfIntegers[16] = "sixteen"
namesOfIntegers = [:]

var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

airports.count

if airports.isEmpty {
    //...
}

airports["LHR"] = "London"

airports["LHR"] = "London Heathrow"

// updateValue(_:forKey:) 更新特定键对应的值，并返回更新值之前的原值(可选类型)，而上面那种更新方法不返回

if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("old value was \(oldValue)")
}

if let airportName = airports["DUB"] {
    
}

// 还可以使用下标语法来通过给某个键对应的值赋值为nil来从字典里移除一个键值对
airports["APL"] = "Apple Internation"
airports["APL"] = nil

// removeValueForKey(_:) 也可以用来在字典中移除键值对，该方法会返回被移除的值（可选类型）
if let removedValue = airports.removeValue(forKey: "DUB") {
    
}

// 字典遍历
for (airportCode, airportName) in airports {
    print("\(airportCode): \(airportName)")
}

for airportCode in airports.keys {
    
}

for airportName in airports.values {
    
}

// 构造新数组
let airportCodes = [String](airports.keys)
let airportNames = [String](airports.values)










