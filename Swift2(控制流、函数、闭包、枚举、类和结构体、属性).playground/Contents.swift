//: Playground - noun: a place where people can play

import UIKit

// For 循环 
// for in 循环
// for var index = 0; index < 3; index++{}

// While 循环: while condition { statements }
// Repeat-While 循环: repeat{ statements }while condition

// 条件语句
// IF 语句
// Switch 语句(必须匹配完备，不存在隐式的贯穿，每个case必须包含至少一条语句)

/*
 switch some value to consider {
 case value 1:
    respond to value 1
 case value2, value3:
    respond to value 2 or 3
 default:
    otherwise, do something else
 }
 */

// 区间匹配

let approximateCount = 62
let countedThings = "moons orbiting Saturn"
var naturalCount: String
switch approximateCount {
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
case 5..<12:
    naturalCount = "several"
case 12..<100:
    naturalCount = "donzens of"
case 100..<1000:
    naturalCount = "hundreds of"
default:
    naturalCount = "many"
}

// 元组(Tuple)：可用元组在同一个switch语句中测试多个值。元组中的元素可以是值，也可以是区间。用（_）来匹配所有可能的值

let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("(0, 0) is at the origin")
case (_, 0):
    print("(\(somePoint.0, 0)) is on the x-axis")
case (0, _):
    print("(\(0, somePoint.1)) is on the y-axis")
case (-2...2, -2...2):
    print("(\(somePoint.0), \(somePoint.1)) is inside the box")
default:
    print("(\(somePoint.0), \(somePoint.1)) is outside the box")
    
}

// 值绑定：case 分支的模式允许将匹配的值绑定到一个临时到常量或者变量，并在该case分支里就可以被引用

let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):
    print("on the x-axis with a x value of \(x)")
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let(x, y):
    print("somewhere else at (\(x), \(y))")
}

// case 分支可以用where语句来判断额外条件

let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x==y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x==-y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}

// 控制转移语句
/*
    1. continue
    2. break
    3. fallthrough
    4. return
    5. throw
 */
// continue，break和之前没什么区别。break用在case语句中用来结束整个switch-case语句
// Fallthrough: switch 不会从上一个 case 分支落入下一个 case 分支中。如果想贯穿。可以在每个需要该特性的 case 分支中使用 fallthrough
let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    description += " a prime number, and also"
    fallthrough
default:
    description += " an integer."
}
print(description)

// 带标签语句
/*
    label name: while condition {
        statements
    }
 */

// 提前退出 guard：总有一个else分句，如果条件不为真则执行else分句中的代码
func greet(_ person: [String: String]) {
    guard let name = person["name"] else {
        return
    }
    
    print("hello \(name)") // guard 语句中声明的变量／常量之后语句也可以使用
    
    guard let location = person["location"] else {
        return
    }
    
    print("I hope the weather is nice in \(location)")
}
// 如果guard语句的条件被满足，则在保护语句的封闭大括号结束后继续执行代码。
// 任何使用了可选绑定作为条件的一部分并被分配了值的变量或常量对于剩下的保护语句出现的代码段是可用的。

// 检测 API 可用性
if #available(iOS 9, OSX 10.10, *) {
    // 在 iOS 使用 iOS 9 的 API，在 OS X 使用 OS X v10.10 的 API
}

// 函数
// 多重返回值函数
func minMax(_ array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty {
        return nil
    }
    
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        }
        else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}

if let bounds = minMax([8, -6, 2, 109, 3, 71]) {
    print("min is \(bounds.min) and max is \(bounds.max)")
}

// 函数参数名称：函数参数都有一个外部参数名和一个局部参数名
// 一般情况下，第一个参数省略其外部参数名，第二个及其随后的参数使用其局部参数名作为外部参数名
func someFunction(_ firstParameterName: Int, secondParameterName: Int) {
}
someFunction(1, secondParameterName: 2)

// 指定外部参数名
func someFunction(externalParameterName locaParameterName: Int) {
    
}
someFunction(externalParameterName: 1)
// 指定了外部参数名时，调用时必须使用外部参数名

// 忽略外部参数名：如果不想为第二个及后续的参数设置外部参数名时用（_）代替一个明确的参数名
func someFunction(_ firstParametername: Int, _ secondParameterName: Int) {
    
}
someFunction(1, 2)

// 默认参数值
func someFunction(_ parameterWithDefault: Int = 12) {
    
}
someFunction(6)
someFunction()

// 可变参数： 接受零个或者多个值。通过在变量类型名后加入（...）。可变参数的传入值在函数体中变为此类型的一个数字
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total/Double(numbers.count)
}

arithmeticMean(1, 2, 3, 4, 5, 6)


// 如果函数有一个或多个带参数默认值的参数，而且还有一个可变参数，那么把可变参数放到参数表的最后

// 常量参数和变量参数(swift 3.0 中不再使用变量参数！！)
// 函数参数默认是常量。可以通过指定一个或多个参数为变量参数
func alignRight(_ string: String, totalLegth: Int, pad: Character) -> String {
    var string = string
    let amountToPad = totalLegth - string.characters.count
    if amountToPad < 1 {
        return string
    }
    let padString = String(pad)
    for _ in 1...amountToPad {
        string = padString + string
    }
    return string
}

let originalString = "hello"
let paddedString = alignRight(originalString, totalLegth: 10, pad: "-")

// 输入输出参数：要想函数可以修改参数的值，在函数调用结束之后这些修改仍然存在，就可以把这个参数定义为输入输出参数，在参数定义前加 inout
// 只能传递变量给输入输出参数。传入的参数作为输入输出参数时，要在参数名钱加&。输入输出参数不能有默认值，而且可变参数不能用 inout 标记。
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)

// 函数类型：由函数参数类型和返回类型组成
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}

func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}

var mathFunction: (Int, Int) -> Int = addTwoInts
print("Result: \(mathFunction(2, 3))")

// 函数类型作为参数类型
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result:\(mathFunction(a, b))")
}

printMathResult(addTwoInts, 3, 5)

// 函数类型作为返回值
func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}

func chooseStepFunction(_ backwards: Bool) -> (Int)->Int {
    return backwards ? stepBackward : stepForward
}

var currentValue = 3
var moveNearerToZero = chooseStepFunction(currentValue > 0)

while currentValue != 0 {
    print("\(currentValue)...")
    currentValue = moveNearerToZero(currentValue)
}

// 嵌套函数
func otherChooswStepFunction(_ backwards: Bool) -> (Int)->Int {
    func stepForward(_ input: Int) -> Int {
        return input + 1
    }
    func stepBackward(_ input: Int) -> Int {
        return input - 1
    }
    return backwards ? stepBackward : stepForward
}

currentValue = -4
moveNearerToZero = chooseStepFunction(currentValue > 0)
while currentValue != 0 {
    print("\(currentValue)...")
    currentValue = moveNearerToZero(currentValue)
}

// 闭包
// 闭包可以捕获和存储其所在上下文中任意常量和变量的引用
/*
    闭包采取如下三种形式之一：
    1. 全局函数是一个有名字但不会捕获任何值的闭包
    2. 嵌套函数是一个有名字并可以捕获其封闭函数域内值的闭包
    3. 闭包表达式是一个利用轻量级语法所写的可以捕获其上下文中变量或常量值的匿名闭包
 
    优化：
    1. 利用上下文推断参数和返回值类型
    2. 隐式返回单表达式闭包，即单表达式闭包可以省略 return 关键字
    3. 参数名称缩写
    4. 尾随闭包语法
 */

// 闭包表达式
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
// sort(_:)方法接受一个闭包，该闭包函数需要传入与数组元素类型相同的两个值，并返回一个布尔类型来表明当排序结束之后传入的第一个参数排在第二个参数前面（true）还是后面（false）。

// 提供排序闭包的方法一：写一个符合其类型要求的普通函数，并将其作为sort(_:)方法的参数传入：
func backwards(_ s1: String, s2: String) -> Bool {
    return s1 > s2
}
var reversed = names.sorted(by: backwards)

// 提供排序闭包的方法二：闭包表达式
/*
    {(parameters) -> returnType in
        statements
    }
 */
// 参数可以使用常量、变量、inout和可变参数。不能提供默认值。闭包函数体部分由 in 引入

reversed = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})

// 根据上下文推断类型
// 因为排序闭包函数是作为sort(_:)方法的参数传入的，Swift 可以推断其参数和返回值的类型。sort(_:)方法被一个字符串数组调用，因此其参数必须是(String, String) -> Bool类型的函数。这意味着(String, String)和Bool类型并不需要作为闭包表达式定义的一部分。因为所有的类型都可以被正确推断，返回箭头（->）和围绕在参数周围的括号也可以被省略
reversed = names.sorted(by: {s1, s2 in return s1 > s2})

// 单表达式闭包隐式返回：单行表达式闭包可以忽略 return 关键字来隐式返回
reversed = names.sorted(by: {s1, s2 in s1 > s2})

// 参数名称缩写：可以直接通过 $0, $1, $2 来顺序调用闭包参数
// 如果在闭包表达式中使用参数名称缩写，可以在闭包参数列表中省略对其的定义。in 关键字也可以省略
reversed = names.sorted(by: {$0 > $1})

// 运算符函数
// Swift 的String类型定义了关于大于号（>）的字符串实现，其作为一个函数接受两个String类型的参数并返回Bool类型的值。
reversed = names.sorted(by: >)

// 尾随闭包
// 如果要将一个很长的闭包表达式座位最后一个参数传递给函数，可以将闭包写在函数括号之后
reversed = names.sorted(){$0 > $1}
reversed = names.sorted{$0 > $1}

let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

let strings = numbers.map{
    (number) -> String in
    var number = number
    var output = ""
    while number > 0 {
        output = digitNames[number % 10]! + output
        number /= 10
    }
    return output
}

// 捕获值
func makeIncrementor(forIncrement amount: Int) -> ()->Int {
    var runningTotal = 0
    func incrementor() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementor
}

let incrementByTen = makeIncrementor(forIncrement: 10)
incrementByTen()
incrementByTen()
incrementByTen()

let incrementBySeven = makeIncrementor(forIncrement: 7)
incrementBySeven()
incrementBySeven()

// 并不会影响incrementByTen
incrementByTen()


// 闭包和函数是引用类型
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()


// 非逃逸闭包（Nonescaping Closures）
// 当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，则称该闭包从函数中逃逸。可以在函数参数名之前标注 @noescape 来指明该闭包不允许逃逸出这个函数。@noescape 能使编译器知道这个闭包的生命周期
func someFunctionWithNoescapeClosure(_ closure: ()->Void) {
    closure()
}

// 需要逃逸的闭包
var completionHandlers:[() -> Void] = []
func someFunctionWithEscapingClosure(_ completionHandler:@escaping ()->Void) {
    completionHandlers.append(completionHandler)
}

// 将闭包标注为 @noescape 使得能在闭包中隐式地引用 self
class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure{ self.x = 100 }
        someFunctionWithNoescapeClosure{ x = 200 }
        
    }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)
completionHandlers.first?()
print(instance.x)

// 自动闭包
// 自动闭包是一种自动创建的闭包，用于包装传递给函数作为参数的表达式。这种闭包不接受任何参数，当它被调用的时候，会返回被包装在其中的表达式的值。
// eg: assert(condition:message:file:line:) 函数接受闭包作为它的 condition 参数和 message 参数。它的 condition 参数仅会在 debug 模式下被求值，它的 message 参数仅当 condition 参数为 false 时被计算求值

var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)

let customerProvider = { customersInLine.remove(at: 0) } //延迟执行
// customerProvider 类型 ()->String

print(customersInLine.count)
print("Now serving \(customerProvider())!")
print(customersInLine.count)

// 将闭包作为参数传递给函数
func serverCustomer(_ customerProvider: ()->String) {
    print("Now serving \(customerProvider())")
}
serverCustomer({ customersInLine.remove(at: 0) })

// @autoclosure 来接受一个自动闭包，它暗含了 @noescape 特性
func serverCustomer2(_ customerProvider:@autoclosure ()->String) {
    print("Now serving \(customerProvider())")
}
serverCustomer2(customersInLine.remove(at: 0))

var customerProviders: [() -> String] = []

// @autoclosure 暗含了 @noescape 特性, 要是得可逃逸，用 @autoclosure(escaping)

func collectCustomerProviders( _ customerProvider: @autoclosure @escaping ()->String) {
    customerProviders.append(customerProvider)
}

collectCustomerProviders(customersInLine.remove(at: 0))
collectCustomerProviders(customersInLine.remove(at: 0))

print("Collected \(customerProviders.count) closures.")

for customerProvider in customerProviders {
    print("Now Serving \(customerProvider())")
}


// 枚举
/*
enum SomeEnumeration {
    // 枚举类型定义在这里
}
 */

enum CompassPoint {
    case north
    case south
    case east
    case west
}
// 枚举成员在创建时不会被赋予一个默认的整数值，即 North，South，East和West 不会隐式地被赋值为 0，1，2，3

enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}

var directionToHead = CompassPoint.west
directionToHead = .south

switch directionToHead {
case .north:
    print("")
case .south:
    print("")
case .east:
    print("")
case .west:
    print("")
}

// 关联值
enum Barcode {
    case upca(Int, Int, Int, Int)
    case qrCode(String)
}

var productBarcode = Barcode.upca(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")

// switch 语句可以提取关联值
switch productBarcode {
case .upca(let numberSystem, let manufacturer, let product, let check):
    print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode)")
}

// 如果关联值统一为常量或者变量，可以把let／var 写在前面
switch productBarcode {
case let .upca(numberSystem, manufacturer, product, check):
    print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
    print("QR code: \(productCode)")
}

// 原始值(默认值)，原始值始终不变，关联值会变
enum ASCLLControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

// 原始值的隐式赋值
// 在使用原始值为整数或者字符串类型的枚举时，不需要显式地为每一个枚举成员设置原始值，Swift 将会自动为你赋值。
enum Plane: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}
// 当使用字符串为枚举类型的原始值时，每个枚举成员的隐式原始值为该枚举成员的名称

enum AnotherCompassPoint: String {
    case North, South, East, West
}

let earthsOrder = Plane.earth.rawValue

let sunsetDirection = AnotherCompassPoint.West.rawValue

// 使用原始值初始化枚举实例（如果定义枚举类型时使用了原始值）
let possiblePlanet = Plane(rawValue: 7) //possiblePlanet 是可选类型

// 递归枚举：在美剧成员前加 indirect 表示成员可递归
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case .number(let value):
        return value
    case .addition(let left, let right):
        return evaluate(left) + evaluate(right)
    case .multiplication(let left, let right):
        return evaluate(left) * evaluate(right)
    }
}

let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
print(evaluate(product))


// 类和结构体
/*
    共同点：
    1. 定义属性用于存储值
    2. 定义方法用于提供功能
    3. 定义附属脚本用于访问值
    4. 定义构造器用于生成初始化值
    5. 通过扩展增加默认实现的功能
    6. 实现协议提供某种标准功能
 
    类还有其他功能：
    1. 继承
    2. 类型转换允许在运行时检查和解释一个类实力的类型
    3. 解构器允许一个类实例释放任何其所被分配的资源
    4. 引用计数允许对一个类多次引用
 */

struct Resolution {
    var width = 0
    var height = 0
}

class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

let someResolution = Resolution()
let someVideoMode = VideoMode()

// 结构体类型的成员逐一构造器：所有结构体自动生成。类没有
let vga = Resolution(width: 640, height: 480)

// 结构体、枚举、Int、Float、Bool、String、Array、Dictionary 都是值类型，类是引用

// 恒等运算符：判断两个常量或者变脸是否引用同一个实例，等价于：=== 不等价于 !===

// 属性
// 存储属性存储变量或者常量作为实例的一部分，而计算属性计算一个值。计算属性可以用在 类、结构体和枚举。存储属性只能用于类和结构体。

// 存储属性
struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}

let rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3) //length 初始化之后就不能改变

// 如果创建类一个结构体的实例并把它赋值给一个常量，则无法修改该实例的任何属性，即使定义了变量存储属性。
let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
//rangeOfFourItems.firstValue = 6 

// 即值类型的实例被声明为常量时，它的所有属性也就变成了常量。而类属于引用类型，把一个类的实例赋值给一个常量之后，仍然可以修改该实例的变量属性

// 延迟存储属性：属性前用 lazy 来标示，必须声明为 var
class DataImporter {
    var fileName = "data.txt"
    
}

class DataManager {
    lazy var importer = DataImporter()
    var data = [String]()
}

let manager = DataManager()
manager.data.append("some data")
manager.data.append("some more data")
// importer 还没有被创建

// 注意：如果一个被标记为 lazy 的属性在没有初始化时就同时被多个线程访问，则无法保证该属性只会被初始化一次

// 计算属性：计算属性不存储值，只是提供一个 getter 和一个可选的 setter，来间接获取和设置其他属性或者变量的值。必须声明成 var
struct Point {
    var x = 0.0, y = 0.0
}

struct Size {
    var width = 0.0, height = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + size.width/2
            let centerY = origin.y + size.height/2
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - size.width/2
            origin.y = newCenter.y - size.height/2
        }
    }
}

var square = Rect(origin: Point(x: 0.0, y: 0.0), size: Size(width: 10, height: 10))
let initalSquareCenter = square.center
square.center = Point(x: 15, y: 15)
print("Square.origin is now at (\(square.origin.x), \(square.origin.y))")

// 便捷 setter 声明
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + size.width/2
            let centerY = origin.y + size.height/2
            return Point(x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - size.width/2
            origin.y = newValue.y - size.height/2
        }
    }
}

// 只读属性：只有 getter 没有 setter 的计算属性就是只读属性。只读属性可以去掉 get 关键字和花括号
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth
    }
}

let fourByFiveByTwo = Cuboid(width: 4.0, height: 5, depth: 2)
fourByFiveByTwo.volume

// 属性观察器
// 监控和相应属性值的变化，每次属性被设置的时候就会调用属性观察器。除了延迟存储属性不能设置观察器之外，其他属性都可以添加观察器
// 也可以通过重写属性的方式为继承的属性（包括计算属性和存储属性）添加观察器
// 不要为非重写的计算属性添加属性观察器，因为可以通过它的 setter 直接监控和响应值的变化
// 父类的属性在子类中被赋值时，它在父类中的 willSet 和 didSet 观察器会被调用
// willSet 会将新的属性值作为常量参数传入，默认名称 newValue，didSet 将老的属性值作为常量参数传入，默认名称 oldValue
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print(newTotalSteps)
        }
        didSet {
            if totalSteps > oldValue {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}

let setpCounter = StepCounter()
setpCounter.totalSteps = 200

// 如果一个属性的 didSet 观察器里为它赋值，这个值会替换观察器之前设置的值

// 全局变量和局部变量
// 计算属性和属性观察器所描述的模式也可以用于全局变量（在函数、方法、闭包盒任何类型之外定义的变量，都是延迟计算的）和局部变量（在函数、方法或闭包内部定义的变量）

// 类型属性
// 值类型的存储型类属性可以时变量或者常量，计算型类属性只能定义成变量

struct SomeStructure {
    static var storedTypePropety = "Some value."
    static var computedTypePropety: Int {
        return 1
    }
}

struct SomeEnumeration {
    static var storedTypePropety = "Some value."
    static var computedTypePropety: Int {
        return 1
    }
}

class AnotherSomeClass {
    static var storedTypePropety = "Some value."
    static var computedTypePropety: Int {
        return 1
    }
    class var overrideableComputedTypeProperty: Int { //也是类属性，支持子类对父类进行重写
        return 107
    }
}

SomeStructure.storedTypePropety
SomeStructure.storedTypePropety = "1234"
SomeStructure.computedTypePropety
AnotherSomeClass.overrideableComputedTypeProperty






























