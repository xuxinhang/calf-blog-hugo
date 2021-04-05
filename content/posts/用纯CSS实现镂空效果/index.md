---
title: 用纯 CSS 实现镂空效果
date: 2019-02-22 23:20:51
tags:
  - CSS
  - mask
  - 混合模式
  - blend mode
  - 镂空
---

> UPDATE 2/26
> 
> 现在为示例 CodePen 添加了厂商前缀，并在正文中添加了兼容性提示。感谢评论区的各位。

近来研究了一下镂空效果。

<!--`https://github.githubassets.com/pinned-octocat.svg`-->

<!--more--> 

# `background-clip: text`

背景被裁剪为文字的前景色。第一次是在 CSS-Tricks 看到的这个用法: 在 CSS-Tricks 网站上，这个玩意用得到处都是。

这样，做简单的图片背景镂空效果便不再困难了。关键代码只有几行。

```css
.wrapper {
  /* ... */
  background-image: url("/path/to/your/image");
  -webkit-background-clip: text;  /* Chrome 用户注意加 -webkit 前缀 */
  background-clip: text;
  color: transparent;             /* 文字设为透明 */
}
```

就这几行，视觉上会就会有大变化。[前后对比](https://codepen.io/xuxinhang/pen/ZwdxgW)：

![](16915c2a03989856.png)


> 另外，[这里](https://codepen.io/xuxinhang/pen/wNGwYo)有个比上面更实用的 Demo

> **兼容性提示**
> 
> 除了 Firefox 和 Edge ，其它浏览器需要配合厂商前缀：
> ```css
>   -webkit-background-clip: text;
> ```


`background-clip` 既然是“background”家族的，那它天生和图片、渐变打的交道多。不过，我们做镂空总不会都是图片、渐变这种吧。如果我们想做视频、文字，甚至更复杂的 DOM 元素的镂空效果呢？


# 单刀直入： CSS `mask` 属性

这应该是最直接能想到的方法了。毕竟名字里就带个“mask”，谁能忽略呢？

CSS `mask-*` 系列属性是在 CSS Masking Module Level 1 中定义的。这个规范也定义了为很多人熟知的 `clip` 和 `clip-path` 属性，换句话说，这个CSS 模块包括遮罩和剪裁两部分。

## 第一个例子

虽然是一个新的属性，但设置 mask 属性并不难。下面就是我们的第一个例子。

```html
<div class="masked" />
```

```css
.masked {
  height: 100px;
  width: 100px;
  background: linear-gradient(red, orange, yellow, lightgreen, blue, purple, red);
  -webkit-mask: url("https://github.githubassets.com/pinned-octocat.svg");
  mask: url("https://github.githubassets.com/pinned-octocat.svg");
}
```

就是下面的效果啦。

![](16915c7824565c9e.png)


上面的用法还是很简单的，我们指定了一个 `mask` 参数，它的值是一张<s>从GitHub盗的</s>SVG图片。于是多彩的渐变就被<s>裁剪</s>遮罩成了那只著名的猫。


>  **兼容性提示**
>
> 目前 Mask Module 还处于 Candidate Recommendation 状态，不少浏览器现在需要厂商前缀。Chrome 用户和 Edge 用户请加上 `-webkit` 前缀，如 `-webkit-mask: ... ;`。Firefox 可直接使用。
>
> [从Can I Use 可以知道](https://caniuse.com/#search=mask)，加上 `-webkit`，支持 Mask 的浏览器还是不少的。
>
> 为了方便阅读，*下面的代码 **均未** 使用前缀*。

## mask-* 大家族

`mask`属性实际上是诸多`mask-*`的缩写:

    mask-image
    mask-repeat
    mask-position
    mask-clip
    mask-origin
    mask-size
    -
    mask-type
    mask-composite
    mask-mode
    
有没有 `background-*` 的即视感？没错，里面的不少属性都是和 backgorund / border 一致的，而且它们的作用也是一致的，只不过 `background-*` 用在背景上，而 `mask-*` 用在遮罩层上而已——用在背景上的奇技淫巧搬到 mask 的世界里还能接着用！比如实现这样的效果：

![](16915c51b6c3daab.png)


```css
.masked {
  height: /* ... */;
  width: /* ... */;
  background: /* ... */;
  /* Webkit 内核用户请注意添加厂商前缀 -webkit */
  mask-image: url(https://github.githubassets.com/pinned-octocat.svg);
  mask-size: 5em;
  mask-position: center;
  /* 如果你心情好，加个动画也没问题的 */
}
```

## 进一步控制遮罩效果

可能读者已经发现了，`mask-*` 家族里有几张生面孔。这也好理解： mask 这么强大的特性，完完全全地抄 `background-*` 岂不可惜了。

### `mask-mode`

mask-mode 用来指定具体的遮罩方式。

> **兼容性预警**：目前 `mask-mode` 仅 Firefox 53+ 支持。

mask-type CSS 属性设置 `mask-image` 被用于“亮度型”的遮罩还是“不透明度”型的遮罩。`mask-mode: alaph` 表示使用不透明度（即alaph通道）作为 mask value，`mask-mode: luminance` 表示使用亮度值作为 mask value。

那，遮罩值 / mask value 又是什么？mask value 表示被遮罩的元素被遮罩的程度。mask value 越大，被遮罩区域会更偏向于显露，mask value 最大的时候，那个区域就完全不透明了。举个例子：

```html
<div class="mode">ABCDEFG</div>
```

```css
.mode {
  height: 200px;
  width: 300px;
  /* and more */
  mask-image: linear-gradient(to left, black, yellow);
  mask-mode: luminance; /* or alaph ? */
}
```

![](16915cc34f589f22.png)

左边是遮罩图片，中间是 `luminance` 右边使用 `alaph`。这里的图片是不透明的，所以将一个恒不透明的图片在`alaph`模式下作为遮罩，其结果是没有遮罩效果。但是图片是有亮度变化的，所以`luminance`下的被遮罩元素就呈现出透明度的变化了。 

一般 `luminance` 模式慢一点点，因为每一个像素点的亮度值需要根据 RGB 三个通道的值计算出来。



### `mask-composite`

指定当有多个遮罩图片叠加起来的时候，如何处理遮罩效果。一些属性值的效果依赖于 mask-image 的层级次序。

用 [MDN 提供的这个 CodePen]( https://developer.mozilla.org/en-US/docs/Web/CSS/mask-composite#Example) 来感受一下 

关于 `mask` 的知识就讲到这里，更具体更准确的说明还是*要到 MDN 看一看*。




# 混合模式

这应该是最为神奇的一种方法了。使用PS的时候，经常会看见“混合模式”这个词。还记得多年前我初次使用 Photoshop 的时候还很好奇“混合模式”是什么东西，顿时让我对 Photoshop 充满了敬畏之情。不过，当年的敬畏归敬畏，现在这里说的“混合模式”还是蛮好理解的。

所谓的“混合模式”，是指当一种当层重叠时计算像素最终颜色值的方法。每种混合模式接收前景颜色值和背景颜色值（分别为顶部颜色和底部颜色）作为输入，执行一些计算并输出最后要显示在屏幕上的颜色值。最终的可见的颜色是对层中的每个重叠像素执行混合模式计算所得的结果。**说白了，混合模式确定了把一层叠加到另一层上去会得到什么结果。**

在 CSS 中，可以使用 `mix-blend-mode` 来指定混合模式。

你可能会问了，平时也没有用什么“混合模式”这种东西，所以`blend-mode`的默认值是`none`吗？可不是。其实，这种最常见的 上层把下层“遮住”了的情况也属于一种混合模式，叫`normal`，它本质上是一种只保留前景颜色值而完全抛弃背景颜色值的混合模式。

这里我们只讨论实现镂空效果用到的混合模式 —— `screen`。这种混合模式有一个特性，前景层是黑色导致最终可见的颜色直接是背景层的颜色，前景层是白色导致最终可见的颜色直接是白色。

相信你已经搞不明白这和镂空有什么关系了，下面举个例子看一下。

现在，我们有一个`<video>`，以及一个“白底黑字”的Logo浮层。

![](16915a8b25d771d1.png)

我们在浮层框上加上下面的 CSS：

```css
.logo {
    /* ... ... */
    mix-blend-mode: screen;
}
```

就变成了下面的样子：

![](16915ae4bf83ad55.png)
[去这个 Demo，看具体代码和效果](https://codepen.io/xuxinhang/pen/KJjBbP)

齿轮图标确实是变为镂空的了。不过，为什么呢？

先来明确一件事：把浮层置于视频之上，浮层是“前景”，视频是“背景”。先来看浮层的白色部分，因为把白色置于任何颜色之上都得到白色，所以白色部分被保留；而因为黑色置于任何颜色之上都得到下层的颜色，所以黑色部分呈现镂空效果。

但是这样的实现比较 Hack，因为这里只使用了黑白两色，如果使用其它的颜色作为浮层的 `background-color`，得到的就不会像是镂空的效果了，这时还是得请上面的`mask`家族出场。不过，单单对于白底的情况，`mix-blend-mode` 不失为一个可行的解法。
































