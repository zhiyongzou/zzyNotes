//
//  main.swift
//  SwiftStudy
//
//  Created by zzyong on 2021/9/12.
//

import Foundation

print("Hello, World!")

//MARK: 合并2个有序链表
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

// [1, 2, 3]  [1, 2, 3]
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

var l1 = ListNode.init(1)
l1.next = ListNode.init(2)
l1.next?.next = ListNode.init(4)

var l2 = ListNode.init(1)
l2.next = ListNode.init(3)
l2.next?.next = ListNode.init(4)

let result = mergeTwoLists(l1, l2)

var printNode = result
while printNode != nil {
    print(printNode!.val)
    printNode = printNode?.next
}
