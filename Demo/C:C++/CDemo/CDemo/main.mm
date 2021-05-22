//
//  main.m
//  CDemo
//
//  Created by zzyong on 2021/3/16.
//

// 进度： 无名对象

#import <Foundation/Foundation.h>
#import <stdio.h>
#import <iostream>

using namespace std;

int i = 1;
namespace my {
    int i = 2;
};

class People {
    
    int data;
    
public:
    
    People(int data) {
        this->data = data;
        cout<<"People data: "<<data<<endl;
    }
    
    ~ People() {
        cout<<"~ People data"<<data<<endl;
    }
};

class Book {
    string name;
public:
    Book(string name) {
        this->name = name;
        cout<<"Book name: "<<name<<endl;
    }
    
    ~Book(){
        cout<<"~ Book name: "<<name<<endl;
    }
};

class Student:public People {
    
private:
    string name;
    unsigned int age;
    bool sex;
    const int score;
    Book book;
    
// 访问修饰符
public:
    
    // 构造函数: 跟类名相同，无返回类型，初始化成员变量
    // 构造函数可以存在多个
//    Student(string name, unsigned int age, bool sex):score(20) {
//        this->name = name;
//        this->age = age;
//        this->sex = sex;
//        cout<<"score: "<<score<<endl;
//    }
    
    // 函数重载
    // :scroe 只能用初始化列表数据类型：常量、引用、成员对象、父对象
//    Student():score(10){
//        cout<<"score: "<<score<<endl;
//    }
    
    // 行参默认值
    Student(string name = "default", unsigned int age = 1, bool sex = false):People(10), score(30), book("english") {
        this->name = name;
        this->age = age;
        this->sex = sex;
        cout<<name<<", "<<age<<endl;
    }
    
    // 析构函数： ~ 类名
    // 系统自动调用
    ~ Student() {
        cout<<"~ Student name: "<<name<<endl;
    }
    
    
    void show() {
        cout<<name<<", "<<age<<endl;
    }
    
    void show() const {
        cout<<name<<", "<<age<<endl;
    }
    
    void setName(string name) {
        // this 对象地址 Student *
        this->name = name;
    }
    
    // 常函数，无法改变变量（name）值
    string getName() const {
        return name;
    }
};

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        // 命名空间 ::
//        std::cout << "Hello, World!"<<std::endl;
//
//        int i = 0;
//        cout<<i<<endl;
//        cout<<::i<<endl;
//
//        cout<<my::i<<endl;
//
//        my::i = 3;
//        cout<<my::i<<endl;
        
        Student stu1;
//        stu1.show();
        
//        const Student stu2("lili", 18, true);
//        stu2.getName();
        // stu2.show();
        
        // 引用 &
        // 引用是另外一个变量的别名，相当于是同一个变量。 a 就是 j, j 就是 a
        // 普通引用创建必须初始化
        // 引用无法修改
//        int a = 3;
//        int &j = a;
//        j = 4;
//        cout<<"a: "<<a<<" j: "<<j<<endl;
//        a = 5;
//        cout<<"a: "<<a<<" j: "<<j<<endl;
        
        NSUInteger
    }
    return 0;
}
