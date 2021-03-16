## Web

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
- `<title>` 元素 定义文档的标题，显示在浏览器的标题栏或标签页上
- `<body>` 元素表示文档的内容（可见的页面内容）
