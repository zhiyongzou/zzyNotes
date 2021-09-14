//
//  List.swift
//  SwiftStudy
//
//  Created by zzyong on 2021/9/14.
//

import Foundation

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

/// 链表输出
func printList(_ list: ListNode?) -> Void {
    var result = ""
    var currentNode = list
    while currentNode != nil {
        if let value = currentNode?.val {
            if result.count > 0 {
                result = result + ", " + String(value)
            } else {
                result += String(value)
            }
        }
        currentNode = currentNode?.next
    }
    print(result)
}

/// 反转链表
func reverseList(_ l1: ListNode?) -> ListNode? {

    var header: ListNode? = nil
    var current = l1
    while current != nil {
        let next = current?.next
        current?.next = header
        header = current
        current = next
    }
    return header
}

/// 合并链表
func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    if l2 == nil {
        return l1
    }
    var result = l2
    var current: ListNode? = l1
    while (current != nil) {
        var insertNode = result
        var before: ListNode? = nil
        while (insertNode != nil) {
            if insertNode!.val >= current!.val {
                if before == nil {
                    result = ListNode.init(current!.val)
                    result?.next = insertNode
                } else {
                    before?.next = ListNode.init(current!.val)
                    before?.next?.next = insertNode
                }
                break
            } else {
                before = insertNode
                insertNode = insertNode?.next
            }
        }
        if insertNode == nil && before != nil {
            before?.next = ListNode.init(current!.val)
        }
        
        current = current?.next
    }
    return result
}


