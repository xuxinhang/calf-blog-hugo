---
title: LaTeX 入门小记：Vim + Vimtex + LaTeX 初体验
date: 2019-11-25 19:15:00
categories:
- LaTeX
tags:
- Vim
- LaTeX
---

前几天写作业的时候突发奇想，想用传说中的LaTeX写一份作业交上去，正好前几天也被迷一样的Word搞得苦不堪言。

之前收藏过一篇来自外国小哥的文章
 [How I'm able to take notes in mathematics lectures using LaTeX and Vim​](https://castel.dev/post/lecture-notes-1/)

知乎上也有相关的中文介绍
[机器之心：世界上最好的编辑器Vim：1700多页数学笔记是如何实时完成的](https://zhuanlan.zhihu.com/p/61036165)

就以这篇文章为起点，我在一台Windows电脑上开始了 Vim + LaTeX 的踩坑旅程……

<!--more--> 

## 安装LaTeX环境

**不要再用CTeX套装了。** CTeX 套装是一个LaTeX发行版，里面包含了包括CTeX宏包在内的一套适合中文排版的工具集。它本质上是MiKTex的修改版，但已经很久没有更新过，里面的工具已经过于陈旧。CTeX 宏包是集成了中文支持、字体、版式为一体的一组宏包和文档类的合集。CTeX宏包已经发布到了Tex Live与MiKTeX两大发行版的仓库里，所以不使用CTeX套装也可以享受CTeX宏包带来的便利。这里就请大家直接用MiKTeX或者TeX Live吧！

我用的MiKTeX，整个安装过程还是很顺畅的。安装完后有一个“MiKTeX Console”，它是MiKTeX的控制台，可以手动安装升级宏包、修改镜像地址什么的。安装向导里有个选项，大意是遇到缺失的包该怎样处理，默认就好。

> 题外话：我当时安装MiKTeX的时候它没有把自己的路径加到PATH里

![](v2-0ec0595f725cfb2ec8b58ad28f2e84b1_b.png)
![](v2-d844eb849f295d87d5cea16f05970993_b.png)

TeX Live 也有类似的 Console。里面“选项”下可以改镜像地址，改成一个中国境内的地址后下载速度就不错了。不过我个人更偏好 MiKTex 一些。

![](v2-bec3cf587887872af73a396311379b10_b.png)


## 安装配置Vim与Vimtex

Vim官网上有gVim可供下载，当然没有谁会用它提供的那个所谓GUI的…
> 安装时记得勾选 "Install for command line"

![](v2-f5d4fe37982e77420c4bcbb883914a6a_b.png)

然后开始学习使用Vim，这里不包教，也不包会…

之后安装 Vimtex，如果你初次用 Vim，还得安装个 vim-plug 这样的插件管理器，不麻烦。

`~/.vimrc` 里也得加入相关的配置
```vim
"....
Plug 'lervag/vimtex'
let g:tex_flavor='latex'

" 阅读器相关的配置 包含正反向查找功能 仅供参考
let g:vimtex_view_general_viewer = 'SumatraPDF'
let g:vimtex_view_general_options_latexmk = '-reuse-instance'
let g:vimtex_view_general_options
\ = '-reuse-instance -forward-search @tex @line @pdf'
\ . ' -inverse-search "' . exepath(v:progpath)
\ . ' --servername ' . v:servername
\ . ' --remote-send \"^<C-\^>^<C-n^>'
\ . ':execute ''drop '' . fnameescape(''\%f'')^<CR^>'
\ . ':\%l^<CR^>:normal\! zzzv^<CR^>'
\ . ':call remote_foreground('''.v:servername.''')^<CR^>^<CR^>\""'

set conceallevel=1
let g:tex_conceal='abdmg'
"...
```

我的配置是相当简单的，基本和原文保持一致，但有两个不一样的地方：

-   我没有关闭`vimtex_quickfix_mode`。“quickfix mode”是指当编译完成之后，会弹出一个split，告诉你哪里有warning啊，哪里有error啊。如果不是过于追求速度，看看warning并把它们全都消灭掉也不错……
-   我使用了 SumatraPDF 作为PDF阅读器，而非Zathura。（因为Windows上没有Zathura）当然你也可以使用其它的PDF阅读器，比如说使用Zathura就写 `let g:vimtex_view_method='zathura'`
-   `:help g:vimtex_view_method`里针对不同的阅读器也有不同的推荐配置。如果使用其它的阅读器，那么具体配置内容请看帮助文档。
-   *其中包含正向查找和反向查找的相关配置。* 正向查找是指可以让阅读器中的文档定位至源码中光标对应的位置，反向查找指在源码中定位到阅读器文档中某一点处对应的位置。帮助文档提供的阅读器的推荐配置中包含了正反向查找的相关内容。
    

## 安装PDF阅读器

我使用的是SumatraPDF，在Vimtex中相关配置就在上面了。`:h vimtex-options` 里推荐了不少PDF阅读器并提供了推荐配置。你也可以使用自己喜欢的，但还是建议使用 Vimtex 推荐的PDF阅读器，毕竟一些实用功能还是需要阅读器的配合。

> Windows用户要记得把路径加到PATH里啊

## 开始写LaTeX文档

从零开始学习LaTeX可以看《[The Not So ShortIntroduction to LATEX2](http://tug.ctan.org/info/lshort/english/lshort.pdf)》，CTeX小组和社区还翻译了中文版《[一份不太简短的LATEX2介绍](http://mirrors.ctan.org/info/lshort/chinese/lshort-zh-cn.pdf)》。CTAN官方访问困难也可访问[中国境内的CTAN镜像站](https://zhuanlan.zhihu.com/p/20490473)。另外下面这些个也不错：
+ [一份其实很短的 LaTeX 入门文档](https://liam.page/2014/09/08/latex-introduction/)
+ [一份其实很短的 LaTeX 入门文档 · 看云](https://www.kancloud.cn/thinkphp/latex/41802)

### 关于中文/CTeX

这里推荐使用 CTeX 宏包。如果以UTF-8保存，`[UTF8]`是一定要加的。
```latex
\documentclass[UTF8]{ctexart}
\begin{document}
你好，world!
\end{document}
```

### 关于数学公式

数学公式的规则是有那么一点复杂，还好这里有个在线LaTeX公式编辑器可供学习研究。我常用它来看一些不常用的数学记号怎么写（我怎么能记得住所有的数学记号啊）。
> [http://www.codecogs.com/latex/eqneditor.php](http://www.codecogs.com/latex/eqneditor.php)

### 关于使用 Vimtex

Vimtex提供了一些默认的 key mappings，可以在 `:h vimtex-usage` 里看到。摘几个我觉得好使的列在下面吧。（比如 vimtex-toc-open可以调出一个大纲列表，方便在不同的section/subsection之间跳转，delim-close可以直接关闭当前的环境/命令，等等。）

> ⚠️ Vimtex 使用了 filetype 特性，所以相关的命令与缩进规则与只在 `*.tex` 文件中有效
```
 ---------------------------------------------------------------------~
   LHS              RHS                                          MODE~
  ---------------------------------------------------------------------~
   <localleader>li  |<plug>(vimtex-info)|                           `n`
   <localleader>lt  |<plug>(vimtex-toc-open)|                       `n`
   <localleader>lT  |<plug>(vimtex-toc-toggle)|                     `n`
   <localleader>lv  |<plug>(vimtex-view)|                           `n`
   <localleader>ll  |<plug>(vimtex-compile)|                        `n`
   <localleader>lo  |<plug>(vimtex-compile-output)|                 `n`
   <localleader>lg  |<plug>(vimtex-status)|                         `n`
   <localleader>lG  |<plug>(vimtex-status-all)|                     `n`
   <localleader>lc  |<plug>(vimtex-clean)|                          `n`
   <localleader>lC  |<plug>(vimtex-clean-full)|                     `n`
   dse              |<plug>(vimtex-env-delete)|                     `n`
   dsc              |<plug>(vimtex-cmd-delete)|                     `n`
   cse              |<plug>(vimtex-env-change)|                     `n`
   csc              |<plug>(vimtex-cmd-change)|                     `n`
   <F7>             |<plug>(vimtex-cmd-create)|                     `nxi`
   ]]               |<plug>(vimtex-delim-close)|                    `i`
  ---------------------------------------------------------------------~ 
```

> 科普专区： `<localleader>`是一个特殊的字符，区分出插件自定义的mappings 默认是一个反斜杠，也可以使用`let maplocalleader`配置自己的`<localleader>`字符。 比如，执行 vimtex-compile 在Normal模式下敲`\ll`就可以了

## 第一次编译

好了，你现在有了一份LaTeX源码，现在可以在Normal模式下敲`\ll`启动编译了。之后，Vimtex会调用 Latexmk 来调度不同的程序完成一次完整编译过程。（一般为了生成正确的交叉引用等，需要对源文件进行多次编译。）

这里 MiKTeX 会提醒你：“还没有安装Latexmk呢，需要安装吗？” 这里狠狠地点击“Install”就完事了。如果使用的是Windows，Latexmk还会提醒你还没有安装Perl解释器。啥都别说了，乖乖去 perl.org下载安装Perl，然后再启动编译一遍吧……

![](v2-20eaf223a59c4c5d8e2895f3042c78b2_b.png)

然后继续。这时MiKTeX会提示你这个包要不要装，那个包要不要装，咱当然是一路“Install”。如果你的代码没问题的话，稍等片刻 Vimtex 就会启动 SumatraPDF展示你第一篇 LaTeX 文档的模样了。如果不幸出了一些错误，Vimtex也会告诉你第几行出现了什么问题（即上面提到的“quickfix”功能）。

还有更方便的功能：
-   每当保存文件的时候，Vimtex（其实是Latexmk）就会自动编译新的文档，SumatraPDF也会自动更新为最新的编译输出。

配置了正反向查找后：
-   在 SumatraPDF 里双击可以让 Vim 跳转到对应的 LaTeX 代码。
-   执行`\lv`来让SumatraPDF打开编译出的文档，并跳转到光标当前所在源码处的对应位置。
    

最后的效果就像这样——一个很简单的例子
![](v2-31f3a11c06c35b30014b16d5bfbf4a60_b.png)

----------

接下来你可以换一个好用又好看的终端。我选择的是 ConEmu+PowerShell，搭配双显示器效果更佳~

![](v2-cf14b93eab0497b429330df4ef5241d1_b.png)
 
## 题外话：几个我用到的宏包

（我这次用到的宏包估计大部分情况下也会用到吧）
```latex
\usepackage{graphicx} % 插图片
\usepackage{amsmath}  % 数学公式拓展
\usepackage{float}    % 浮动体控制
\usepackage{listings} % 插入代码，不过据说 minted 的效果更好一些
```

 <!--
<u>**其它参考**</u>
[使用 Latexmk 编译 tex 文件](https://macplay.github.io/posts/shi-yong-latexmk-bian-yi-tex-wen-jian/)
-->

