import Foundation

// 创建默认值数组
var threeDoubles = Array(repeating: 0.0, count: 3)
print(threeDoubles)

// 通过两个数组相加创建一个数组
var anotherThreeDoubles = Array(repeating: 2.5, count: 3)
var sixDoubles = threeDoubles + anotherThreeDoubles
print(sixDoubles)

//var threeInts = Array(repeating: 3, count: 3)
//var mixNumber = threeDoubles + threeInts
//print(mixNumber)

// 用数组字面量构造数组
var shoppingList = ["Eggs", "Milk"]
print(shoppingList)

// 访问和修改数组
// 可以通过数组的方法和属性来访问和修改数组，或者使用下标语法
print("The shopping list contains \(shoppingList.count) items.")

if shoppingList.isEmpty {
    print("购物列表为空")
} else {
    print("不为空")
}

// 使用 append(_:) 方法在数组后面添加新的数据项
shoppingList.append("Flour")
print(shoppingList)

// 通过 + 直接增加其他数组里面的数据
shoppingList += ["Cheese"]
print(shoppingList)

// 使用下标获取数组里面的元素
var firstItem = shoppingList[0]
print(firstItem)

// 使用下标来改变某个有效索引值对应的数据值
shoppingList[0] = "Six eggs"
print(shoppingList[0])

// 使用下标批量修改数据
shoppingList[2...3] = ["Bananas", "Apples"]
print(shoppingList)

// 数组中指定位置插入元素
shoppingList.insert("Maple Syrup", at: 0)
print(shoppingList)

// 移除指定位置元素
shoppingList.remove(at: 0)
print(shoppingList)

// 移除最后一个
shoppingList.removeLast()
print(shoppingList)

// 移除第一个
shoppingList.removeFirst()
print(shoppingList)

// 【注意】方法内部并没有越界保护逻辑
// shoppingList.removeAll()
// shoppingList.removeFirst()

//MARK: 数组遍历

// for-in
for item in shoppingList {
    print("item: \(item)")
}
