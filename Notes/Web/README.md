# Web 开发

## HTML
HTML（HyperText Markup Language）：是一种用于创建网页的标准标记语言

HTML 元素参考：https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element

### HTML 注释标签`<!--注释-->`
主流浏览器都支持`<!--...-->`注释标签

```
<!--这是一个注释，注释在浏览器中不会显示-->
```

### HTML 网页结构
```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>网页标题</title>
</head>
<body>
    <h1>这是标题</h1>
    <p> 这是段落</p>
</body>
</html>
```

- `<!DOCTYPE html>` 声明为 HTML5 文档，告知浏览器当前HTML版本。此外，doctype 声明是不区分大小写的
- `<html>` 元素是 HTML文档的根元素，其他元素必须是该元素的后代
- `<head>` 元素 规定文档相关的配置信息（元数据），包括文档的标题，引用的文档样式和脚本等。，如 <meta charset="utf-8"> 定义网页编码格式为 utf-8
- `<body>` 元素表示文档的内容（可见的页面内容）

## JavaScript

### 基础语法
变量名
> 大小写敏感，并使用 Unicode 字符集
> 
> 必须以字母、下划线（_）或者美元符号（$）开头

声明

JavaScript有三种声明方式。

|关键字|变量类型|
|--|--|
|var|声明一个变量，可选初始化一个值。|
|let|声明一个块作用域的局部变量，可选初始化一个值。|
|const|声明一个块作用域的只读常量。|

语句
> 在 JavaScript 中，指令被称为语句 （Statement），并用分号（;）进行分隔。

注释
```js
// 单行注释

/* 这是一个更长的,
   多行注释
*/
```

undefined
- 判断一个变量是否已赋值
- 在布尔类型环境中会被当作 false
- 数值类型环境中 undefined 值会被转换为 NaN

null
-  在数值类型环境中会被当作0
-  在布尔类型环境中会被当作 false

变量作用域
- 在函数之外声明的变量为全局变量，可被当前文档中的任何其他代码所访问
- 在函数内部声明的变量为局部变量，只能在当前函数的内部访问
