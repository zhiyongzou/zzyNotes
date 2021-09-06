//: [Previous](@previous)

import Foundation

var str = "LeetCode, GO"

/// 两数之和
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var result: [Int] = []
    if nums.count > 0 {
        var sumMap: [Int:Int] = [:]
        var idx: Int = 0
        for num in nums {
            if let anotherNumIdx = sumMap[num] {
                result = [anotherNumIdx, idx]
                break
            }
            sumMap[target - num] = idx
            idx += 1
        }
        print(sumMap)
    }
    return result;
}

print(twoSum([1, 2, 7, 4, 5], 5))

//: [Next](@next)
