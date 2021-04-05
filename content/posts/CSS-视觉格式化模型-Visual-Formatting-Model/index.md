---
title: CSS 视觉格式化模型 Visual Formatting Model
date: 2018-02-18 12:52:09
tags:
  - CSS
---


![img](7e8f35beff7b07022095b9bc4b634416.png)

# What’s CSS Visual Formatting Model

- 视觉格式化模型(visual formatting model)是用来处理文档并将它显示在视觉媒体上的机制。
- 根据CSS盒模型，浏览器为文档元素生成盒子(Box)。视觉格式化模型就是文档里的“盒子布局呈现的一种规则”。

<!--more--> 

# Basic Concepts in CSS specification

### The “Box” in the sight of W3C

各位至少对CSS盒模型有所耳闻吧？CSS盒子（Box）是由 CSS 引擎根据文档中的内容所创建，用于文档元素的定位、布局和格式化等的布局单位。

> **Q: 一个元素 等于 一个盒子 ？**
>
> A: 我都这么问了，答案肯定是否定的。反例：
>
> 1. `<li>` 元素，除了标签内容之外，前面的项目符号也生成了一个盒子。
> 2. 跨行的行内元素（例如 大段的文本）。分布在不同行的部分分别属于不同的盒子。

### Overview: Block , Inline and Boxes

很多概念你可以分得清吗？

![img](2766dbbad7cb2b9d773b5e699f53f450.png)

**术语表：\*见文末*。**

- 块盒(Block Box)：既是块级盒(Block Level Box) 也是 块容器盒(Block Container Box) 的盒子。
- 包含块(containing block): 包含其他盒子的块称为包含块。

### 块级盒子 // Block-Level Box

**当元素的 display为block、list-item或table时，该元素将成为块级元素。** 块级盒子参与块级格式化上下文。块级盒子描述元素与其父元素和兄弟元素之间的行为。块容器盒子描述了元素跟其后代之间的行为（例如，子元素相对父元素进行定位）。

- **有些块级盒子并不是块容器盒子。** 比如表格，表格的单元格明显不是块级嘛，但是它还是可以包含div等块级的盒子。其实表格内部是“表格格式化上下文”。
- **有些块容器盒子也不是块级盒子** 。如非替换行内级块和非替换表格单元格。（下文有具体的例子）。

> **Q: 什么是替换元素？**
>
> 替换元素就是浏览器根据元素的标签和属性，来决定元素的具体显示内容。比如`img`元素通过`src`属性的值来读取图片信息并显示出来，而 HTML 代码里没有图片的实际内容；又例如 `input` 元素的 `type` 属性决定是显示输入框，还是单选按钮等。
> `html<img src="girl.jpg"/> <input type="submit" name="submit" value="提交"/> `
>
> HTML 的大多数元素是非替换元素，即浏览器直接渲染HTML标签内的内容。 例如：
>
> ```
> <p>p的内容</p>
> <em>label的内容</em>
> ```

## 

> **Q: “块级元素” 对应一个 “块级盒子”?**
>
> A: 不一定。大多数块级元素都仅会生成一个块级盒子。但有的块级元素 `<li>`可能会生成更多盒子。

### 行内级盒子 // Inline-Level Box

行内级元素是 `display` 属性为 `inline-*` 的元素和其他默认行内的元素。

行内级元素会生成行内级盒子，参与行内格式化上下文（IFC）。

> **Q：“原子”可以再分吗？**或者说 生成 “原子行内级盒子” 的元素 可以拥有子元素吗？

### 行内级盒子 vs. 行内盒子 vs. 原子行内级盒子

傻傻分不清。**“行内级盒子” 分为 “行内盒” 与 “原子行内级盒” 两种。 注意概念区分与包含关系** 。

![img](18918e6b5fc9dc6a2b2d5eb515f3c251.png)

#### 行内盒子 // Inline-Box

其内容会参与创建其容器的行内格式化上下文。可以被拆分成多个盒子然后放置在包含它的盒子里。

例如：`display: inline`

下面这张图片里，蓝色字包含在`<em>`里面。而这个标签拆成了三个块，和包含它的盒子的行内盒子“融为一体”，也就是所谓的`“参与创建其容器的行内格式化上下文”`。

（下图的绿色虚线框使用`CSS outline 属性`生成。印证了“生成三个盒子”的说法。）

![img](50571bc1ec99df9e1fea0f0b780c4321.png)

#### 原子行内级盒子 // Atomic Inline-Level Box

内容不参与行内格式化上下文的创建，像原子一样不可再拆成多个盒子。

例子： 替换行内级元素（例`<img />`）、`display: inline-block`、`inline-table`。

下图的`<em>`被添加了`inline-block`，成为原子行内级元素。它自成”独立王国“，其内容 *不会* 参与其容器盒子的格式化上下文。

![img](73e9c8e631156c77f4e9b4b0f1331041.png)

#### 原子行内级盒的排布

原子行内盒在行内格式化上下文里 **不能拆成多个盒子** 。

默认情况下，如果一行的剩余空间容不下，那就去新开一行；如果新开的一行也容不下，那就算溢出容器也不让拆成多个盒子。

**单个汉字 / 单个英文单词 就是一个自然的原子行内级盒** 。当然，一些CSS属性会改变对“原子”的判定，例如 `word-break: break-all`。见下图。

![img](f67abd5d7a768c10b3b57bb2d24d207a.png)

> **Q：“原子”可以再分吗？**或者说 生成 “原子行内级盒子” 的元素 可以拥有子元素吗？
>
> A: 可以包含子元素。`display: inline-block`的元素会生成原子行内级盒子，也可以包含子元素。

### 题外话：Line-Box 行盒 是什么

行盒（Line Box, 也叫行框）是由行内格式化上下文(IFC)产生的盒，用于表示一行。在块盒里面，行盒从块盒一边排版到另一边（从左右浮动元素边缘开始计）。

*一般我们 CSS 布局时不需关注。这和我们上文讨论的概念没有直接的联系。*

### 没有盒子也要强行加盒子——匿名盒子

在某些情况下进行视觉格式化时，需要添加一些增补性的盒子，这些盒子 **不能** 用CSS选择符选中，称为 **匿名盒子（anonymous boxes）** 。

不能被 CSS 选择符选中意味着不能用样式表添加样式。不过，它们的样式表现可以这样理解：
🔸可继承的 CSS 属性值都为 `inherit` 
🔸不可继承的 CSS 属性值都为 `initial`

![img](4ef4f442d3e2a9f436e9fc6d9d92230a.png)

上图含有了两个匿名块盒子，下图显示了两个匿名行内盒子。

# Various "Formatting Contexts"

### What’s Formatting Context

“格式化上下文”…… 什么叫“上下文”，真是一个蹩脚的翻译！

我的理解：每种 *环境(context)* 各自对应着盒模型格式化的一套 *规则(layout)*

> Boxes in the normal flow belong to a formatting context
>
> 正常流中的盒子属于某一个格式化上下文。
>
> 正常流：文档流，非绝对定位的盒子在其中。

下面是几种FC：

![img](4f07d3e67edf70f09ba92c1b687080d8.png)

### BFC

#### 产生条件

1. <u>根元素</u>或其它包含它的元素
2. 浮动`float: left/right/inherit`
3. 绝对定位`position: absolute/fixed`
4. 行内块`display: inline-block`
5. 表格单元格`display: table-cell`
6. 表格标题`display: table-caption`
7. 溢出元素 `overflow: hidden/scroll/auto/inherit`（“浮动坍塌”的快捷解决方案之一）

#### 布局规则

- 内部的Box会在垂直方向，一个接一个地放置。
- Box垂直方向的距离由margin决定。属于同一个BFC的两个相邻Box的margin会发生重叠。
- 每个元素的marginbox的左边，与包含块borderbox的左边相接触。即使存在浮动也是如此。
- **BFC的区域不会与float box重叠** 。
- BFC就是页面上的一个隔离的独立容器， **容器里面的子元素不会影响到外面的元素** 。反之也如此。
- **计算BFC的高度时，浮动元素也参与计算** 。

#### 实用层面

- 浮动区域不叠加到BFC区域上
- 防止与浮动元素重叠
- 防止margin合并
- float高度塌陷

![img](65c91d27b6b5bee5ae574f2f4fd3fca4.png)

#### Related Demos

防止与浮动元素重叠 | <https://codepen.io/SitePoint/pen/xGpMRP>

margin collapse | <https://codepen.io/SitePoint/pen/XbVOXp>

自己写一个 | <https://codepen.io/xuxinhang/pen/QmXEWz>

### IFC

#### 触发条件

一个块级元素中 **仅** 包含内联级别元素。

所以如果还包含块级盒子那内部是BFC。（参见 ”匿名盒子“小节 的例子。）

#### 布局规则

- 内部的盒子会在水平方向，一个接一个地放置。
- 这些盒子垂直方向的起点从包含块盒子的顶部开始。
- 摆放这些盒子的时候，它们在水平方向上的 padding、border、margin 所占用的空间都会被考虑在内。
- 在垂直方向上，这些框可能会以不同形式来对齐（vertical-align）：它们可能会使用底部或顶部对齐，也可能通过其内部的文本基线（baseline）对齐。
- 能把在一行上的框都完全包含进去的一个矩形区域，被称为该行的 **行框（line box）**。 **行框的宽度是由包含块（containing box）和存在的浮动来决定** 。
- IFC中的 line box 一般左右边都贴紧其包含块，但是会因为float元素的存在发生变化。float 元素会位于IFC与与 line box 之间，使得 line box 宽度缩短。
- IFC 中的 line box 高度由 CSS 行高计算规则来确定，同个 IFC 下的多个 line box 高度可能会不同（比如一行包含了较高的图片，而另一行只有文本）
- 当 inline-level boxes 的总宽度少于包含它们的 line box 时，其水平渲染规则由 text-align 属性来确定，如果取值为 justify，那么浏览器会对 inline-boxes（注意不是inline-table 和 inline-block boxes）中的文字和空格做出拉伸。
- **【敲黑板】** *当一个 inline box 超过 line box 的宽度时，它会被分割成多个boxes，这些 boxes 被分布在多个 line box 里。如果一个 inline box 不能被分割（比如只包含单个字符，或 word-breaking 机制被禁用，或该行内框受 white-space 属性值为 nowrap 或 pre 的影响），那么这个 inline box 将溢出这个 line box。*

#### 实用

- 水平居中：当一个块要在环境中水平居中时，设置其为 inline-block 则会在外层产生 IFC，通过设置父容器 text-align:center 则可以使其水平居中。
- 垂直居中：创建一个IFC，用其中一个元素撑开父元素的高度，然后设置其 vertical-align:middle，其他行内元素则可以在此父元素下垂直居中。

### FFC

#### 触发条件

当 `display`的值为`flex`或`inline-flex`时，其内容建立了一个新的 **弹性格式化上下文** 。

#### 布局规则

- 设置为 flex 的容器被渲染为一个块级元素
- 设置为 inline-flex 的容器则渲染为一个行内元素
- 弹性容器中的每一个子元素都是一个弹性项目。弹性项目可以是任意数量的。弹性容器外和弹性项目内的一切元素都不受影响。

*FFC 里也可存在匿名盒子！*

### GFC

#### 条件

当为一个元素设置为网格布局`display: grid/grid-inline`的时候，此元素内部将会是一个 **GFC** 。

#### 规则

通过在网格容器（grid container）上定义网格定义行（grid definition rows）和网格定义列（grid definition columns）属性各在网格项目（grid item）上定义网格行（grid row）和网格列（grid columns）为每一个网格项目（grid item）定义位置和空间。

### TFC (Table-FC)

In terms of the visual formatting model, a table can behave like a [block-level](https://www.w3.org/TR/CSS22/visuren.html) (for '`display:table`')or [inline-level](https://www.w3.org/TR/CSS22/visuren.html) (for `'display:inline-table'`)element.

The table box establishes a **table formatting context** .

互联网上的文章为什么都没有提到 TFC ？可能是谈到这个点的时候 CSS 规范直接”参考Table章节“了吧……

TFC也存在匿名盒子。例如：

```
<div style="display: table;">
    I'm in an anonymous table cell actually.
</div>
```

你看到的文本其实在一个 显式的table盒子 里的 匿名的table-row盒子 里的 匿名的table-cell盒子 里。

# The End

#### Vocabulary

*来自 MDN 的整理*

> - **块**：block，一个抽象的概念，一个块在文档流上占据一个独立的区域，块与块之间在垂直方向上按照顺序依次堆叠。
> - **包含块**：containing block，包含其他盒子的块称为包含块。
> - **盒子**：box，一个抽象的概念，由CSS引擎根据文档中的内容所创建，主要用于文档元素的定位、布局和格式化等用途。盒子与元素并不是一一对应的，有时多个元素会合并生成一个盒子，有时一个元素会生成多个盒子（如匿名盒子）。
> - **块级元素**：block-level element，元素的 `display` 为 `block`、`list-item`、`table` 时，该元素将成为块级元素。元素是否是块级元素仅是元素本身的属性，并不直接用于格式化上下文的创建或布局。
> - **块级盒子**：block-level box，由块级元素生成。一个块级元素至少会生成一个块级盒子，但也有可能生成多个（例如列表项元素）。
> - **块盒子**：block box，如果一个块级盒子同时也是一个块容器盒子（见下），则称其为块盒子。除具名块盒子之外，还有一类块盒子是匿名的，称为匿名块盒子（Anonymous block box），匿名盒子无法被CSS选择符选中。
> - **块容器盒子**：block container box或block containing box，块容器盒子侧重于当前盒子作为“容器”的这一角色，它不参与当前块的布局和定位，它所描述的仅仅是当前盒子与其后代之间的关系。换句话说，块容器盒子主要用于确定其子元素的定位、布局等。
>
> 注意：盒子分为“块盒子”和“块级盒子”两种，但元素只有“块级元素”，而没有“块元素”。下面的“行内级元素”也是一样。
>
> - **行内级元素**：inline-level element，`display` 为 `inline`、`inline-block`、`inline-table` 的元素称为行内级元素。与块级元素一样，元素是否是行内级元素仅是元素本身的属性，并不直接用于格式化上下文的创建或布局。
> - **行内级盒子**：inline-level box，由行内级元素生成。行内级盒子包括行内盒子和原子行内级盒子两种，区别在于该盒子是否参与行内格式化上下文的创建。
> - **行内盒子**：inline box，参与行内格式化上下文创建的行内级盒子称为行内盒子。与块盒子类似，行内盒子也分为具名行内盒子和匿名行内盒子（anonymous inline box）两种。
> - **原子行内级盒子**：atomic inline-level box，不参与行内格式化上下文创建的行内级盒子。原子行内级盒子一开始叫做原子行内盒子（atomic inline box），后被修正。原子行内级盒子的内容不会拆分成多行显示。

#### 看CSS规范的一些注意事项

- CSS3开始，CSS规范把各个部分拆成了很多各自独立、并行发展的小规范，就像打补丁。要看本文的点，还是要去看CSS2的规范，因为CSS3规范是没有定义这些点的。
- 比ECMAScript规范易读。

#### Refer to

<https://www.sitepoint.com/understanding-block-formatting-contexts-in-css/>

<https://www.w3.org/TR/css-display-3/#flow-layout>

<https://www.w3.org/TR/CSS22/tables.html#model>

<https://developer.mozilla.org/zh-CN/docs/Web/Guide/CSS/Visual_formatting_model>

<https://segmentfault.com/a/1190000013372963>