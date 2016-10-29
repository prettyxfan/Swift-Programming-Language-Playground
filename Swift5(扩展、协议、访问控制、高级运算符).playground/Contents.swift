//: Playground - noun: a place where people can play

import UIKit

// 扩展：就是向一个已有的类、结构体、枚举类型或者协议类型添加新功能（functionality）。这包括在没有权限获取原始源代码的情况下扩展类型的能力（即逆向建模）。类似 OC 里面的 catagories
/*
     扩展可以：
     1. 添加计算型属性和计算型静态属性
     2. 定义实例方法和类型方法
     3. 提供新的构造器
     4. 定义下标
     5. 定义和使用新的嵌套类型
     6. 使一个已有类型符合某个协议
 
    extension SomeType {
        // 新功能
    }
 
    extension SomeType: SomeProtocol, AnotherProtocol {
        // 协议实现
    }
  */

// 计算属性
extension Double {
    var km: Double {
        return self * 1_000
    }
    var m: Double {
        return self
    }
    var cm: Double {
        return self / 100.0
    }
    var mm: Double {
        return self / 1_000.0
    }
    var ft: Double {
        return self / 3.28084
    }
}

let oneInch = 25.4.mm
let threeFeet = 3.ft
let aMarathon = 42.km + 195.m

// 构造器：可以向类中添加新的便利构造器，不能添加指定构造器或析构器
struct Size {
    var width = 0.0, height = 0.0
}

struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
}

extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width/2)
        let originY = center.y - (size.height/2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

// 如果你使用扩展向一个值类型添加一个构造器，在该值类型已经向所有的存储属性提供默认值，而且没有定义任何定制构造器（custom initializers）时，你可以在值类型的扩展构造器中调用默认构造器(default initializers)和逐一成员构造器(memberwise initializers)。

// 方法
extension Int {
    func repetitions(_ task: ()->()) {
        for _ in 0..<self {
            task()
        }
    }
}

3.repetitions({ print("Hello!") })

// 可变实例方法
extension Int {
    mutating func square() {
        self = self * self
    }
}

var someInt = 3
someInt.square()

// 下标
extension Int {
    subscript(digitIndex: Int) -> Int {
        var index = digitIndex
        var decimalBase = 1
        while index > 0 {
            decimalBase *= 10
            index -= 1
        }
        return (self / decimalBase) % 10
    }
}

7456281739[5]

// 嵌套类型
extension Int {
    enum Kind {
        case negative, zero, positive
    }
    
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}

(-2).kind

func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .negative:
            print("-")
        case .zero:
            print("0")
        case .positive:
            print("+")
        }
    }
}

printIntegerKinds([3, 19, -27, 0, -6, 7])

// 协议
// 语法
/*
    protocol SomeProtocol {
        // 协议内容
    }
 
    struct SomeStructure: SomeSuperClass, FirstProtocol, AnotherProtocol {
        // 结构体内容
    }
 */

// 协议可以规定遵循者提供特定名称和类型的实例属性或者类属性，并不指定是计算属性还是存储型属性。此外必须指明是只读还是可读可写的。
// 如果协议要求是可读可写的，就不能是常量或者只读的，但如果只要求了是可读的，如果需要的话，可以弄成可读可写的

protocol SomeProtocol {
    var mustBeSetteabel: Int { get set }
    var doesNotNeedToBeSettabe: Int { get }
    static var someTypeProperty: Int { get set }
}

protocol FullyNamed {
    var fullName: String { get }
}

struct Person: FullyNamed {
    var fullName: String
}

let john = Person(fullName: "John Appleseed")

class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
    
}

let ncc1701 = Starship(name: "Enterprise", prefix: "USS")

// 对方法的规定
protocol SomeProtocolToo {
    static func someTypeMethod()
    func someMethod()
}

protocol RandomNumberGenerator {
    func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = (lastRandom * a + c).truncatingRemainder(dividingBy: m)
        return lastRandom/m
    }
}

let generator = LinearCongruentialGenerator()
generator.random()

// 对 Mutating 方法的规定：如果你在协议中定义了一个方法旨在改变遵循协议的实例，就需要加 mutating（值类型的时候是现实时要加 mutating，类类型不用加）
protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}

// 对构造器的规定
protocol SomeProtocolThree {
    init(someParameter: Int)
}

// 类遵循时需要加 required 以保证子类继承时都能为构造器提供一个现实的实现或继承实现
class SomeClassTwo: SomeProtocolThree {
    required init(someParameter: Int) {
        
    }
}
// 如果一个类是final的就不用写 required。如果一个子类重写了父类的指定构造器，并且该构造器遵循了某个协议规定，那么该构造器的实现需要同时标示 required 和 override
/*
protocol SomeProtocol {
    init()
}

class SomeSuperClass {
    init() {
        
    }
}

class SomeSubClass: SomeSuperClass, SomeProtocol {
    required override init(){
        
    }
}
 */

// 协议类型
/*
    1. 作为函数、方法或构造器中的参数类型或返回值类型
    2. 作为常量、变量或属性的类型
    3. 作为数组、字典或其它容器中的元素类型
 */

class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
    
}

// 委托（代理）模式
protocol DiceGame {
    var dice: Dice { get }
    func play()
}

protocol DiceGameDelegate {
    func gameDidStart(_ geme: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}

class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = [Int](repeating: 0, count: finalSquare + 1)
        board[03] += 08; board[06] += 11; board[09] += 09; board[10] = +02;
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSqure where newSqure > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snackes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()
/*
 Started a new game of Snackes and Ladders
 The game is using a 6-sided dice
 Rolled a 3
 Rolled a 5
 Rolled a 4
 Rolled a 5
 The game lasted for 4 turns
 */


// 在扩展中添加协议成员
protocol TextRepresentatle {
    var textualDescription: String { get }
}

extension Dice: TextRepresentatle {
    var textualDescription: String {
        return "A \(sides)-side dice"
    }
}

extension SnakesAndLadders: TextRepresentatle {
    var textualDescription: String {
        return "A game of Snakes and Ladders with \(finalSquare) squares"
    }
    
}

// 通过扩展补充协议声明
// 当一个类型已经实现了协议中的所有要求，却没有声明为遵循该协议时，可以通过扩展（空的扩展体）来补充协议声明
struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}

extension Hamster: TextRepresentatle {}
// 因为即便满足了协议的所有要求，类型也不会自动转变，因此需要为它做出显示的协议声明
let simonTheHamster = Hamster(name: "Simon")

//协议类型的集合

let things: [TextRepresentatle] = [game, simonTheHamster]

// 协议的继承
/*
    protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
        // 协议定义
    }
 */

protocol PrettyTextRepresentable: TextRepresentatle {
    var prettyxTextualDescription: String { get }
}

extension SnakesAndLadders: PrettyTextRepresentable {
    var prettyxTextualDescription: String {
        var output = textualDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "ddd"
            case let snake where snake < 0:
                output += "fff"
            default:
                output += "ooo"
            }
        }
        return output
    }
}

// 类专属协议
// 可以在协议的继承列表中，通过添加 class 关键字，限制协议只能是适配到class类型
// 该 class 关键字必须是第一个出现在协议的继承列表中，其后才是其它继承协议
/*
protocol SomeClassOnlyProtocol: class, SomeInheritedProtocol {
    // 协议定义
}
 */

// 协议合成
// 有时候需要同时遵循多个协议，可以将多个协议采用 protocol<SomeProtocol, AnotherProtocol> 这样的格式进行组合
protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

struct AnPerson: Named, Aged {
    var name: String
    var age: Int
}

func wishHappyBirthday(_ celebrator: Named & Aged) {
    
}

// 检验协议一致性
// 用 is 和 as 操作来检查是否遵循某一协议或强制转化为某一类型
/*
    is 操作符用来检查实例是否遵循了某个协议。
    as? 返回一个可选值，当实例遵循协议时，返回该协议类型;否则返回nil。
    as 用以强制向下转型，如果强转失败，会引起运行时错误。
 */
protocol HasArea {
    var area: Double { get }
}

class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double { return pi * radius * radius }
    init(radius: Double) { self.radius = radius }
}

class Country: HasArea {
    var area: Double
    init(area: Double) { self.area = area }
}

class Animal {
    var legs: Int
    init(legs: Int) {
        self.legs = legs
    }
}

let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4)
]

for object in objects {
    if let objectWithArea = object as? HasArea {
        print("Area is \(objectWithArea.area)")
    }
    else {
        print("Something that doesn't have an area")
    }
}

// 对可选协议的规定
// 可以在协议中使用 optional 关键字作为前缀来定义可选成员
// 当需要使用可选规定的方法或者属性时，它的类型自动会变成可选的。
// 比如，一个定义为(Int) -> String的方法变成((Int) -> String)?。需要注意的是整个函数定义包裹在可选中，而不是放在函数的返回值后面。可选协议在调用时使用可选链，因为协议的遵循者可能没有实现可选内容。像someOptionalMethod?(someArgument)这样，你可以在可选方法名称后加上?来检查该方法是否被实现。

// 可选协议只能在含有@objc前缀的协议中生效。 这个前缀表示协议将暴露给Objective-C代码
// @objc的协议只能由继承自 Objective-C 类的类或者其他的@objc类来遵循。它也不能被结构体和枚举遵循。


@objc protocol CounterDataSource {
    @objc optional func incrementForCount(_ count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.incrementForCount?(count) {
            count += amount
        }
        else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

class ThreeSource: CounterDataSource {
    @objc let fixedIncrement = 3
}

var counter = Counter()
counter.dataSource = ThreeSource()

for _ in 1...4 {
    counter.increment()
    print(counter.count)
}

class TowardsZeroSource: CounterDataSource {
    @objc func incrementForCount(_ count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}

// 协议扩展
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

// 通过扩展协议，所有协议的遵循者，在不用任何修改的情况下，都自动得到了这个扩展所增加的方法。
let aGenerator = LinearCongruentialGenerator()
print("Here's a random number: \(aGenerator.random())")
// 输出 "Here's a random number: 0.37464991998171"
print("And here's a random Boolean: \(aGenerator.randomBool())")
// 输出 "And here's a random Boolean: true

// 提供默认实现
// 可以通过协议扩展的方式类为协议规定的属性和方法提过默认的实现

extension PrettyTextRepresentable {
    var prettyTextualDescription: String {
        return textualDescription
    }
}

// 为协议扩展添加限制条件：用where指定一些限制，只有满足这些限制的协议遵循者，才能获得协议扩展提供的属性和方法

extension Collection where Iterator.Element: TextRepresentatle {
    var texturalDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}

let murrayTheHamster = Hamster(name: "Murray")
let morganTheHamster = Hamster(name: "Morgan")
let mauriceTheHamster = Hamster(name: "Maurice")
let hamsters = [murrayTheHamster, morganTheHamster, mauriceTheHamster]

print(hamsters.texturalDescription)
// 如果有多个协议扩展，而一个协议的遵循者又同时满足它们的限制，那么将会使用所满足限制最多的那个扩展。


// 泛型
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

struct Stack<T> {
    var items = [T]()
    mutating func push(_ item: T) {
        items.append(item)
    }
    
    mutating func pop() -> T {
        return items.removeLast()
    }
}

// 扩展一个泛型类型
// 不需要在扩展的定义中提供类型参数列表。原始类型定义中声明的类型参数列表在扩展里是可以使用的，并且这些来自原始类型中的参数名称会被用作原始定义中类型参数的引用。
extension Stack {
    var topItem: T? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

// 类型约束
/*
func someFunction<T: SomeClass, U: SomeProtocol> (someT: T, someU: U) {
    // T必须是SomeClass的子类，U必须遵循SomeProtocol协议的类型约束
}
 */
func findIndex<T: Equatable>(_ array: [T], _ valueToFind: T) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

// 关联类型实例
// 定义一个协议时，有时候声明一个或多个关联类型作为协议定义的一部分。一个关联类型作为协议的一部分，给定了类型的一个占位名（或别名）

protocol Container {
    associatedtype ItemType
    mutating func apped(_ item: ItemType)
    var count: Int{ get }
    subscript(i: Int) -> ItemType { get }
}

struct IntStack: Container {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
    // Container 协议的实现
//    typealias ItemType = Int 可以忽略
    mutating func apped(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}
// 遵循Container协议的泛型
struct AnotherStack<T>: Container {
    var items = [T]()
    mutating func push(_ item: T) {
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
    
    mutating func apped(_ item: T) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> T {
        return items[i]
    }
}


// 扩展一个存在的类型作为一指定关联类型
//extension Array: Container {}

// Where 语句
func allItemsMatch<C1: Container, C2: Container>(_ someContainer: C1, anotherContainer: C2) -> Bool where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
    if someContainer.count != anotherContainer.count {
        return false
    }
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }
    return true
}









































