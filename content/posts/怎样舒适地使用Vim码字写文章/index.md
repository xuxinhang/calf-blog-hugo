---
title: 怎样舒适地使用 Vim 码字写文章
date: 2020-06-28 19:39:00
categories:
- LaTeX
tags:
- Vim
- LaTeX
---


在 Vim 中使用 LaTeX 或者 Markdown 码字总会感到两种痛苦：一是开启自动折行后一个自然段的东西显示为好几行，可敲 `j`  `k` 会让光标直接跳到下一个自然段；二是写码汉字的时候输入法总是要不停地切换——插入模式下写文章要用中文输入法码字，回到普通模式还得切换回英文敲命令。

> 提出这个问题是因为这段时间一直在使用 LaTeX 写中文文章，以上两个问题相当影响效率。我想很多人也遇到了这个问题，所以在这里分享一下解决方案。 
> 另外，上一篇文章写到了怎样使用 Vim 愉快地写 LaTeX，这一篇也算是对前面文章的补充。 
> 当然，你也可以把这里的方法应用到任何需要使用 Vim 写大量中文的地方。

毗邻：LaTeX 入门小记：Vim + Vimtex + LaTeX 初体验​zhuanlan.zhihu.com![图标](v2-0c924e835b6c9ccc4888771e4c41a38f_180x120.jpg)

所以，是时候解决这两个问题了！

<!--more-->

  

## (一) 修改 `j`  `k` 的上下移动光标的行为

Vim 以换行标记为一行的结束。在 Vim 中，可以开启对长行自动回绕，也就是当一行过长超过显示区域的时候自动回绕，绕出来的行称为虚拟行。在写文章的时候，你经常会输入好多这样的长行，也许你更喜欢称之为“自然段”，但 Vim 认为是这是一行。

Vim 默认是开启自动回绕的。你如果关闭了也可以使用 `:set wrap` 来开启，也可写在 `.vimrc` 里。 Vim 默认使用 `gk` 与 `gj` 来在虛拟行间上下移动光标，使用 `k` 与 `j` 在行间移动光标。

考虑到经常需要在虚拟行间移动光标，而且按 `gk`与`gj`并不方便，所以不妨把这两组按键的功能交换一下：

```vim
noremap  <buffer>  j gj
noremap  <buffer>  k gk
noremap  <buffer> gj j  
noremap  <buffer> gk k  
set  wrap  
```

这里 `noremap` 定义了一个不进行重映射的键映射。 如果使用 `map` 这样的命令，第三行的 `gj->j` 就会应用到第一行的 `j->gj` 上，导致 `j->gj->j`，还是没用。`<buffer>` 表示此键映射只应用到缓冲区内，毕竟这个功能只在你写文章的时候才需要。

你也可以依葫芦画瓢修改方向键 `<Up><Down>` 的键映射。

> 想要了解键映射的更多技术细节可以看 `:help usr_40`。

下面把这段 Vim 脚本放到哪里呢？我推荐使用 Vim 的文件类型插件特性。例如对 tex 文件创建文件插件，就在 `~/.vim/ftplugin` 或 `~/vimfiles/ftplugin` 中创建文件 `tex.vim` ，然后把上面的键映射写在里面。下次再打开 tex 文件就可以体验到独特的 `j`  `k` 了。

你也可以把你自己的其它针对 tex 文件的配置脚本写到里面。

> 关于文件类型插件的技术细节参见 `:help filetype-plugin`。

  

##  (二) 借助 vim-xkbswitch 插件实现不同模式间输入法的自动切换

vim-xkbswitch 配合额外的动态链接库实现了在不同模式间切换时记录与恢复键盘布局的功能。 这样，就可以在我们切回插入模式时自动回到中文输入法了。这是 vim-xkbswitch 的文档：[lyokha/vim-xkbswitch](https://github.com/lyokha/vim-xkbswitch)

首先把 vim-xkbswitch 本身安装好：

```vim
" 此处以 vim-plug 为例，你可以使用其它的插件管理器
Plug 'lyokha/vim-xkbswitch'  
let g:XkbSwitchEnabled =  1  "不要忘记这一行
```

不要忘记配置 `g:XkbSwitchEnabled` 的值。vim-xkbswitch还有更多高级的配置，可以了解一下。

然后，安装配套的动态库。你可以在 vim-xkbswitch 文档的 About 章节下找到不同平台下的动态链接库及安装指引。动态链接库应该位于变量 g:XkbSwitchLib 指定的位置处，你可以自行指定也可以直接使用默认值，使用下面的命令查看它的值：
```
:echo g:XkbSwitchLib
```
重启 Vim 之后就应该可以使用了。

**针对 Windows 用户最后要特别强调一点。** 切换到英文的时候是要切换到**英文布局**而不是中文输入法的英文模式。请大家多调整调整试试。大概就是下面这个样子。Windows 10 用户可能需要手动添加英文布局，可以使用 Alt+Shift 切换。

![](v2-c1a9af5e5206ffbb931fa6f3f8ce5ba3_b.png)


----------

这就是这两个问题的解决方案。最后祝各位使用 Vim 码字愉快！
