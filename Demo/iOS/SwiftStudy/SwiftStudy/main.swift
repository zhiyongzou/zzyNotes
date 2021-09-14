//
//  main.swift
//  SwiftStudy
//
//  Created by zzyong on 2021/9/12.
//

import Foundation

print("Hello, World!")

var l1 = ListNode.init(1)
l1.next = ListNode.init(2)
l1.next?.next = ListNode.init(3)
l1.next?.next?.next = ListNode.init(4)

var l2 = ListNode.init(1)
l2.next = ListNode.init(3)
l2.next?.next = ListNode.init(4)

printList(mergeTwoLists(l1, l2))
printList(reverseList(l1))



