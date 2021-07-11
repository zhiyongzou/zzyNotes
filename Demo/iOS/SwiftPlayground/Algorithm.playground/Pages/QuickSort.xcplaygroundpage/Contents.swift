//: [Previous](@previous)

/**
 快速排序
 
 最好（n * log2n）：每次划分所取的基准都是当前无序区的“中值”记录，划分的结果是基准的左、右两个字区间的长度大概相等
 
 最坏（n * n）：已经有序，划分的结果是基准某一侧（左或右）的字区间为空
 
 */

import Foundation

var greeting = "Quick Sort"

/// 一趟划分算法
func partition(list: inout [Int], begin: Int, end: Int) -> Int {

    var tempBegin = begin
    var tempEnd = end
    let privot = list[begin]
    while tempBegin < tempEnd {
        // 从右向左扫描比基准小的的整数
        while tempBegin < tempEnd && list[tempEnd] >= privot {
            tempEnd -= 1
        }
        // 如果发现比基准小的数，交换 tempBegin 和 tempEnd 的值
        if tempBegin < tempEnd {
            list.swapAt(tempBegin, tempEnd)
            tempBegin += 1
        }
        // 从左向右扫描比基准大的的整数
        while tempBegin < tempEnd && list[tempBegin] <= privot {
            tempBegin += 1
        }
        // 如果发现比基准大的数，交换 tempBegin 和 tempEnd 的值
        if tempBegin < tempEnd {
            list.swapAt(tempBegin, tempEnd)
            tempEnd -= 1
        }
    }
    // 将基准移到最后的正确位置
    list[tempBegin] = privot
    
    return tempBegin
}

func quickSort(list:inout [Int], begin: Int, end: Int) {
    
    print("begin: \(begin) end: \(end)")
    if begin >= end {
        // 只有一个数据或无数据时无序排序
        return
    }
    
    let partitionIdx = partition(list: &list, begin: begin, end: end)
    print("partition index: \(partitionIdx) ")
    
    // 递归处理左区间
    quickSort(list: &list, begin: begin, end: partitionIdx - 1)
    
    // 递归处理右区间
    quickSort(list: &list, begin: partitionIdx + 1, end: end)
}

var data = [49, 38, 49, 91, 27, 3, 97, 49]
quickSort(list: &data, begin: 0, end: data.count - 1)
print(data)

