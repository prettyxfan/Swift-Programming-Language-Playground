//: Playground - noun: a place where people can play

import UIKit

// 方法

// Swift 默认给方法的第一个参数一个局部参数名，给第二个和后续的参数局部参数名和外部参数名
class Counter {
    var count: Int = 0
    func incrementBy(_ amount: Int, numberOfTimes: Int) {
        count += amount * numberOfTimes
    }
}
let counter = Counter()
counter.incrementBy(5, numberOfTimes: 3)

// 在实例方法中修改值类型
// 结构体和枚举都是值类型，一般情况下值类型的属性不能在它的实例方法中被修改
// 必须要修改的时候可以用“变异”（mutating），在方法名前加 mutating。其实是隐含的给self属性赋值一个全新的实例，替换原来的实例

struct Point {
    var x = 0.0, y = 0.0
    mutating func moveByX(_ deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
    /*
     等价于：
     mutating func moveByX(deltaX: Double, y deltaY: Double) {
        self = Point(x: x + deltaX, y: y + deltaY)
     }
     
     */
}

var somePoint = Point(x: 1, y: 1)
somePoint.moveByX(2, y: 3)
print("The point is now at (\(somePoint.x), \(somePoint.y))")

// somePoint 必须要是 var，如果是 let 则不能修改

/* error
 
let fixPoint = Point(x: 3, y: 2)
fixPoint.moveByX(2, y: 3)
 
 */

enum TriStateSwitch {
    case off, low, high
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}

var ovenLight = TriStateSwitch.low
ovenLight.next()
ovenLight.next()


// 类型方法，func 前加 static 或者 class（class 允许字累重写父类的实现方法），self 指向这个类型本身
struct LevelTracker {
    static var highestUnlockedLevel = 1
    static func unlockLevel(_ level: Int) {
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
    }
    static func levelIsUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    
    var currentLevel = 1
    
    mutating func advanceToLevel(_ level: Int) -> Bool {
        if LevelTracker.levelIsUnlocked(level) {
            currentLevel = level
            return true
        }
        else {
            return false
        }
    }
}

class Player {
    var tracker = LevelTracker()
    let playerName: String
    func completedLevel(_ level: Int) {
        LevelTracker.unlockLevel(level + 1)
        tracker.advanceToLevel(level + 1)
    }
    init(name: String) {
        playerName = name
    }
}

var player = Player(name: "Argyrios")
player.completedLevel(1)

player = Player(name: "Beto")
if player.tracker.advanceToLevel(6) {
    print("player is now on level 6")
}
else {
    print("level 6 has not yet been unlocked")
}

// 下标脚本:
// 下标脚本允许你通过在实例后面的方括号中传入一个或多个索引值来对实例进行访问和赋值。
/*
    subscipt(index: Int) -> Int {
        get {
            // 返回与入参匹配的 Int 类型的值
        }
        set(newValue) {
            // 执行赋值操作
        }
    }
 */

// newValue 的类型必须和下标脚本定义的返回类型相同。如果是只读的，则和计算属性一样不用写get
/*
    subscript(index: Int) -> Int {
        //
    }
 */

struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int { // 参数可以是变量参数、可变参数。但不能有默认值和in-out参数
        return multiplier * index
    }
}

let threeTimesTable = TimesTable(multiplier: 3)
print("3 的 6 倍是 \(threeTimesTable[6])")

// 下标脚本的重载：类或结构体可以根据自身需要提供多个下标脚本实现，通过传入参数的类型进行区别

struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0, count: rows * columns)
    }
    
    func indexIsValidForRow(_ row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

var matrix = Matrix(rows: 2, columns: 2)
matrix[0, 1] = 1.5
matrix[1, 0] = 3.2

// 继承
// 类可以调用和访问超类的方法、属性和下标脚本，并且可以重写这些方法、属性和下标。
class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        // nothing
    }
}

let someVehicle = Vehicle()

class Bicycle: Vehicle {
    var hasBasket = false
}

let bicycle = Bicycle()
bicycle.hasBasket = true
bicycle.currentSpeed = 15.0

class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}

let tandem = Tandem()
tandem.hasBasket = true
tandem.currentSpeed = 22.0
tandem.currentNumberOfPassengers = 2

// 重写 
class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}

// 可以提供 getter 和 setter 来重写继承来的计算属性和存储属性，要将它的名称和类型都写出来
// 可以讲一个继承来的只读属性重写为一个读写属性，但不能将一个继承来的读写属性重写为只读属性
// 如果在重写属性时提供了 setter，就一定要提供 getter，哪怕getter里只写 super.somePropety

class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

let car = Car()
car.currentSpeed = 25
car.gear = 3
print("Car: \(car.description)")

// 重写属性观察器
// 不可用为继承来的常量存储属性或继承来的只读计算属性添加属性观察器。这些值都是不可被设置的。
// 不可同时重写 setter 和属性观察器

class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10) + 1
        }
    }
}

// 防止重写
// 可以通过把方法、属性或下标脚本记为 final 来防止他们被重写，可以在 class 前添加 final 将整个类标记为不可继承

// 构造过程
// 构造器
/*
    init() {
    }
 */
struct Fahrenheit {
    var temperature: Double
    init() {
        temperature = 32.0
    }
    /* or
     var temperature = 32.0
     */
}

// 默认属性值：可以在构造器中为存储属性，也可以在属性声明时为其设置默认值

// 自动构造过程
// 构造参数
struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32) / 1.8
    }
    
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    
    init(_ celsius: Double) {
        temperatureInCelsius = celsius
    }
}

let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
let freezingPointOfWater = Celsius(fromKelvin: 273.15)
let bodyTemperature = Celsius(37.0)

// swift 会为每个构造器的参数自动生成一个跟内部名字相同的外部名，如果不希望自动提供外部名，可以用（_）描述

struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    init(white: Double) {
        red = white
        green = white
        blue = white
    }
}

// 可选属性类型
class SurveyQuestion {
    var text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}

// 构造过程中常量属性的修改：可以在构造过程中的任意时间点修改常量属性的值，只要在构造过程结束时是一个确定值。对于类的实例来说，它的常量属性只能在定义它的类的构造过程中修改，不能在子类中修改

class AnotherSurveyQuestion {
    let text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}

// 默认构造器：如果结构体和类的所有属性都有默认值，同时没有自定义的构造器，那么 swift 会给这些结构体和类创建一个默认的构造器。将所有属性设置为默认值

// 结构体的逐一成员构造器：除了默认构造器，如果结构体对所有存储型属性提供了默认值且没有提供自定义的构造器，就会自动获得一个逐一成员构造器
struct Size {
    var width = 0.0, height = 0.0
}
let twoByTwo = Size(width: 2, height: 2)

// 值类型的构造器代理
// 构造器可以通过调用其他构造器来完成实例的部分构造过程（构造器代理）
// 构造器代理的实现规则和形式在值类型和类类型中有所不同：值类型没有继承，类类型需要保证其所有继承的存储型属性在构造时也能正确的初始化
// 如果为某个值类型定义了一个定制的构造器，则不能使用 init()

struct Rect {
    var origin = Point()
    var size = Size()
    
    init() {}
    
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    init(center: Point, size: Size) {
        let originX = center.x - size.width/2
        let originY = center.y - size.height/2
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

// 类的继承和构造过程
// 指定构造器和便利构造器

// 指定构造器是类最主要的构造器。初始化类和其父类中所有的存储变量。每个类必须至少有一个指定构造器
// 便利构造器是类中比较次要的、辅助型构造器。可以定义便利构造器来调用同一个类的指定构造器，并为器参数提供默认值

// 指定构造器：
/*
    init(parameters) {
        statements
    }
 */

// 便利构造器
/*
    convenience init(parameters) [
        statements
    }
 */

// 类构造器的代理规则
/*
    1. 指定构造器必须调用其直接父类的指定构造器
    2. 便利构造器必须调用同一类中定义的其它构造器
    3. 便利构造器必须始终以调用一个指定构造器结束
 */

/*
    两段式构造过程
    Swift 中类的构造过程包含两个阶段。第一个阶段，每个存储型属性通过引入它们的类的构造器来设置初始值。当每一个存储型属性值被确定后，第二阶段开始，它给每个类一次机会在新实例准备使用之前进一步定制它们的存储型属性。
 
     Swift的两段式构造过程跟 Objective-C 中的构造过程类似。最主要的区别在于阶段 1，Objective-C 给每一个属性赋值0或空值（比如说0或nil）。Swift 的构造流程则更加灵活，它允许你设置定制的初始值，并自如应对某些属性不能以0或nil作为合法默认值的情况。
  */

/*
     Swift 编译器将执行 4 种有效的安全检查，以确保两段式构造过程能顺利完成：
     
     安全检查 1
     指定构造器必须保证它所在类引入的所有属性都必须先初始化完成，之后才能将其它构造任务向上代理给父类中的构造器。
     
     如上所述，一个对象的内存只有在其所有存储型属性确定之后才能完全初始化。为了满足这一规则，指定构造器必须保证它所在类引入的属性在它往上代理之前先完成初始化。
     
     安全检查 2
     指定构造器必须先向上代理调用父类构造器，然后再为继承的属性设置新值。如果没这么做，指定构造器赋予的新值将被父类中的构造器所覆盖。
     
     安全检查 3
     便利构造器必须先代理调用同一类中的其它构造器，然后再为任意属性赋新值。如果没这么做，便利构造器赋予的新值将被同一类中其它指定构造器所覆盖
     
     安全检查 4
     构造器在第一阶段构造完成之前，不能调用任何实例方法、不能读取任何实例属性的值，self的值不能被引用。
 
     类实例在第一阶段结束以前并不是完全有效，仅能访问属性和调用方法，一旦完成第一阶段，该实例才会声明为有效实例。
     
     以下是两段式构造过程中基于上述安全检查的构造流程展示：
 
     阶段 1
     某个指定构造器或便利构造器被调用；
     完成新实例内存的分配，但此时内存还没有被初始化；
     指定构造器确保其所在类引入的所有存储型属性都已赋初值。存储型属性所属的内存完成初始化；
     指定构造器将调用父类的构造器，完成父类属性的初始化；
     这个调用父类构造器的过程沿着构造器链一直往上执行，直到到达构造器链的最顶部；
     当到达了构造器链最顶部，且已确保所有实例包含的存储型属性都已经赋值，这个实例的内存被认为已经完全初始化。此时阶段1完成。
     阶段 2
     从顶部构造器链一直往下，每个构造器链中类的指定构造器都有机会进一步定制实例。构造器此时可以访问self、修改它的属性并调用实例方法等等。
     最终，任意构造器链中的便利构造器可以有机会定制实例和使用self。
 */

// 构造器的继承和重写：和OC不同的是swift中子类不会默认继承父类的构造器。
// 可以 override 父类的构造器

class V {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}

class B: V {
    override init() {
        super.init()
        numberOfWheels = 2
    }
}

// 自动构造器的继承
/*
    如上所述，子类不会默认继承父类的构造器。但是如果特定条件可以满足，父类构造器是可以被自动继承的。在实践中，这意味着对于许多常见场景你不必重写父类的构造器，并且在尽可能安全的情况下以最小的代价来继承父类的构造器。

    假设要为子类中引入的任意新属性提供默认值，请遵守以下2个规则：

    规则 1
    如果子类没有定义任何指定构造器，它将自动继承所有父类的指定构造器。

    规则 2
    如果子类提供了所有父类指定构造器的实现--不管是通过规则1继承过来的，还是通过自定义实现的--它将自动继承所有父类的便利构造器。

    即使你在子类中添加了更多的便利构造器，这两条规则仍然适用。
 
 */

class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

class Recipelngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

let oneMystryItem = Recipelngredient()
let oneBacon = Recipelngredient(name: "Bacon")
let sexEggs = Recipelngredient(name: "Eggs", quantity: 6)

class ShoppingListItem: Recipelngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? "✓" : "×"
        return output
    }
}

// shoppingListItem 没有定义构造器来为 purchased 提供初始化，没有自定义任何构造器，故继承所有父类中的指定构造器和便利构造器

var breakfastList = [ShoppingListItem(), ShoppingListItem(name: "Bacon"), ShoppingListItem(name: "eggs", quantity: 6)]
breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}
/*
 1 x Orange juice✓
 1 x Bacon×
 6 x eggs×
 */

// 可失败构造器：可失败构造器的参数名和参数类型不能与其它非可失败构造器的参数名及其类型相同，构造成功时不返回任何值，失败时 return nil

struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty {
            return nil
        }
        self.species = species
    }
}

if let giraffe = Animal(species: "") {
    
}

// 枚举类型的可失败构造器
enum TemperatureUnit {
    case kelvin, celsius, fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .kelvin
        case "C":
            self = .celsius
        case "F":
            self = .fahrenheit
        default:
            return nil
        }
    }
}

// 带原始值的枚举类型的可失败构造器
// 带原始值的枚举类型会自带一个可失败构造器 init?(rawValue)

// 类的可失败构造器
// 值类型的可失败构造器对何时何地出发构造失败这个行为没有任何限制。但是类的可失败构造器只能在所有类属性被初始化之后和所有类之间的构造器的代理调用发生完成之后触发

class Product {
    let name: String!
    init?(name: String) {
        self.name = name
        if name.isEmpty {
            return nil
        }
    }
}
/*
 // error: constant 'self.name' used before being initialized

    class Product {
        let name: String!
        init?(name: String) {
            if name.isEmpty {
                return nil
            }
        }
    }
*/

// 构造失败的传递

class CartItem: Product {
    let quantity: Int!
    init?(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name) // 如果这个构造失败，整个构造都失败
        if quantity < 1 {
            return nil
        }
    }
}

if let twoSocks = CartItem(name: "", quantity: 1) {
    print("done")
}
else {
    print("init failed")
}

// 重写一个可失败构造器
// 可以用子类可失败构造器重写父类可失败构造器，也可用子类一个非可失败构造器重写父类可失败构造器（反过来不行）。
// 当用一个子类的非可失败构造器重写父类可失败构造器时，子类的构造器将不能再向上代理父类的可失败构造器。

class Document {
    var name: String?
    init() {
        
    }
    init?(name: String) {
        if name.isEmpty {
            return nil
        }
        self.name = name
    }
}

class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    override init(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        }
        else {
            self.name = name
        }
    }
}

// 可以再构造器中调用父类的可失败构造器然后强制解包，以实现子类的非可失败构造器
class UntitledDocument: Document {
    override init(){
        super.init(name: "[Untitled]")!
    }
}

// 可失败构造器 init!
// 该可失败构造器会构建一个特定类型的隐式可选类型的对象

// 必要构造器：在类的构造器前添加 required 修饰符表面该类的子类都必须实现该构造器

// 通过闭包和函数来设置属性的默认值：如果某个存储属性的默认值需要特别的定制或准备。可以使用闭包或全局函数来为其属性提供定制的默认值

/*
class SomeClass {
    let someProperty: SomeType = {
        //在这个闭包中给 someProperty 创建一个默认值
        //someValue 和 SomeType 类型相同
        return someValue
    }()
}
 */

// 用闭包来初始化属性，其它属性还没初始化，所以不能在闭包里访问其它属性。也不能用 self，不能调用其它实例方法

struct Checkerboard {
    let boardColors: [Bool] = {
       var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...10 {
            for j in 1...10 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
    }()
    
    func squarelsBlackAtRow(_ row: Int, column: Int) -> Bool {
        return boardColors[(row * 10) + column]
    }
}


// 析构过程
// 析构器只能用于类类型。当一个类的实例被释放之前，析构器会立即被调用。析构器用 deinit 标示
// 每个类最多只能有一个析构器，析构器不带任何参数。自动被调用

struct Bank {
    static var coinsInBank = 10_000
    static func vendCoins(_ numberOfCoinsToVend: Int) -> Int {
        let number = min(numberOfCoinsToVend, coinsInBank)
        coinsInBank -= number
        return number
    }
    static func receiveCoins(_ coins: Int) {
        coinsInBank += coins
    }
}

class AnotherPlayer {
    var coinsInPurse: Int
    init(coins: Int) {
        coinsInPurse = Bank.vendCoins(coins)
    }
    func winCoins(_ coins: Int) {
        Bank.receiveCoins(coins)
    }
    deinit {
        Bank.receiveCoins(coinsInPurse)
    }
}
























