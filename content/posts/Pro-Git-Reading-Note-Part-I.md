---
title: Pro Git Reading Note Part I
date: 2018-10-18 13:13:12
summary: "<q>Pro Git</q>读书笔记——那些我还不会的知识"
draft: true
tags:
  - Git
---


<!-- <div class="ql-editor" data-gramm="false" contenteditable="true">  -->

`git remote show`

<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);">为这种情况下的合并操作没有需要解决的分歧——这就叫做 “快进（fast-forward）”</span>

<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);">Git 自动将 </span>`serverfix`<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);"> 分支名字展开为</span>`refs/heads/serverfix:refs/heads/serverfix`<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);">，那意味着，“推送本地的 serverfix 分支来更新远程仓库上的 serverfix 分支。” 我们将会详细学习 </span>[Git 内部原理](https://git-scm.com/book/zh/v2/ch00/ch10-git-internals)<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);"> 的 </span>`refs/heads/`<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);"> 部分，但是现在可以先把它放在儿。 你也可以运行 </span>`gi`

# 3.5 Git 分支 - 远程分支

### **跟踪分支**

从一个远程跟踪分支检出一个本地分支会自动创建一个叫做 “跟踪分支”（有时候也叫做 “上游分支”）。 跟踪分支是与远程分支有直接关系的本地分支。 如果在一个跟踪分支上输入 `git pull`，Git 能自动地识别去哪个服务器上抓取、合并到哪个分支。

当克隆一个仓库时，它通常会自动地创建一个跟踪 origin/master 的 master 分支。 然而，如果你愿意的话可以设置其他的跟踪分支 - 其他远程仓库上的跟踪分支，或者不跟踪 master 分支。 最简单的就是之前看到的例子，运行 git checkout -b [branch] [remotename]/[branch]。 这是一个十分常用的操作所以 Git 提供了 --track 快捷方式：
<pre spellcheck="false">$ git checkout --track origin/serverfix       
</pre>

https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E8%BF%9C%E7%A8%8B%E5%88%86%E6%94%AF

clone下来的repo在本地默认只有master分支。

上游快捷方式

<span style="background-color: rgb(255, 242, 133);">当设置好跟踪分支后，可以通过 </span>`@{upstream}`<span style="background-color: rgb(255, 242, 133);"> 或 </span>`@{u}`<span style="background-color: rgb(255, 242, 133);"> 快捷方式来引用它</span>。 所以在 `master` 分支时并且它正在跟踪 `origin/master` 时，如果愿意的话可以使用 `git merge @{u}` 来取代 `git merge origin/master`。

### **删除远程分支**
<pre spellcheck="false">git push origin --delete serverfix          
</pre>

# 3.6 Git 分支 - 变基
<pre spellcheck="false"> git rebase --onto master server client          
</pre>

*   <span style="background-color: rgb(255, 242, 133);">如果不加 onto 会发生什么？</span>
*   好好研究一下 rebase 的 options

<pre spellcheck="false">git rebase [-i | --interactive] [&lt;options&gt;] [--exec &lt;cmd&gt;] [--onto &lt;newbase&gt;]  [&lt;upstream&gt; [&lt;branch&gt;]] git rebase [-i | --interactive] [&lt;options&gt;] [--exec &lt;cmd&gt;] [--onto &lt;newbase&gt;]  --root [&lt;branch&gt;] git rebase --continue | --skip | --abort | --quit | --edit-todo | --show-current-patch          
</pre>

### **用变基解决变基**

如果你 **真的** 遭遇了类似的处境，Git 还有一些高级魔法可以帮到你。 如果团队中的某人强制推送并覆盖了一些你所基于的提交，你需要做的就是检查你做了哪些修改，以及他们覆盖了哪些修改。<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);">如果你或你的同事在某些情形下决意要这么做，请一定要通知每个人执行 </span>`git pull --rebase`<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);"> </span>_总的原则是，只对尚未推送或分享给别人的本地修改执行变基操作清理历史，从不对已推送至别处的提交执行变基操作，这样，你才能享受到两种方式带来的便利_<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);">。</span>

# 4.1 服务器上的 Git - 协议

HTTPS 如何指定证书？

<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);">裸仓库目录名以 .git 结尾</span>

# 5.2 分布式 Git - 向一个项目贡献

<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);">运行 </span>`git diff --check`<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);">，它将会找到可能的空白错误并将它们为你列出来</span>

# 7.1 Git 工具 - 选择修订版本

<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);">值得注意的是，引用日志只存在于本地仓库，一个记录你在你自己的仓库里做过什么的日志。 其他人拷贝的仓库里的引用日志不会和你的相同；而你新克隆一个仓库的时候，引用日志是空的，因为你在仓库里还没有操作。</span>

*   SHA-1
*   <span style="color: rgb(78, 68, 60); background-color: rgb(252, 252, 250);">当然你提供的 SHA-1 字符数量不得少于 4 个，并且没有歧义</span>
*   分支引用
*   引用日志(reflog)：`HEAD@{5}`  `master@{yesterday}`
*   `git reflog` 来查看日志
*   祖先引用： `HEAD^`     `HEAD^2`   第二父提交
*   `HEAD~2`  第一父提交的第一父提交 = `HEAD^^`
*   `^2` 与 `~2` 的区别 
*   提交区间
*   `master..experiment`   experiment 分支中未在 master 分支（哪些提交尚未被合并入 master 分支
*   `master...experiment` 如果你想看 `master` 或者 `experiment` 中包含的但不是两者共有的提交

因此下列3个命令是等价的：
<pre spellcheck="false">$ git log refA..refB $ git log ^refA refB $ git log refB --not refA      
</pre>

你想查看所有被 `refA` 或 `refB` 包含的但是不被 `refC` 包含的提交
<pre spellcheck="false">$ git log refA refB ^refC $ git log refA refB --not refC      
</pre>

另一个常用的场景是查看你即将推送到远端的内容：
<pre spellcheck="false">$ git log origin/master..HEAD          
</pre>

这个命令会输出在你当前分支中而不在远程 `origin` 中的提交。

# 7.2 Git 工具 - 交互式暂存

<span style="color: rgb(78, 68, 60); background-color: rgb(252, 252, 250);">运行 </span>`git add`<span style="color: rgb(78, 68, 60); background-color: rgb(252, 252, 250);"> 时使用 </span>`-i`<span style="color: rgb(78, 68, 60); background-color: rgb(252, 252, 250);"> 或者 </span>`--interactive`<span style="color: rgb(78, 68, 60); background-color: rgb(252, 252, 250);"> 选项，Git 将会进入一个交互式终端模式</span>

可以在命令行中使用 `git add -p` 或 `git add --patch`来启动同样的脚本。

更进一步地，可以使用 `reset --patch` 命令的补丁模式来部分重置文件，通过 `checkout --patch` 命令来部分检出文件与 `stash save --patch` 命令来部分暂存文件。

<span style="color: rgb(78, 68, 60); background-color: rgb(252, 252, 250);">默认情况下，</span>`git clean`<span style="color: rgb(78, 68, 60); background-color: rgb(252, 252, 250);"> 命令只会移除没有忽略的未跟踪文件。 任何与 </span>`.gitiignore`<span style="color: rgb(78, 68, 60); background-color: rgb(252, 252, 250);"> 或其他忽略文件中的模式匹配的文件都不会被移除。 </span>

<span style="color: rgb(78, 68, 60); background-color: rgb(252, 252, 250);">现在运行 </span>`git status`<span style="color: rgb(78, 68, 60); background-color: rgb(252, 252, 250);"> 会没有输出，因为三棵树又变得相同了。</span>

`reset`<span style="color: rgb(78, 68, 60); background-color: rgb(252, 252, 250);"> 做的第一件事是移动 HEAD 的指向。 这与改变 HEAD 自身不同（</span>`checkout`<span style="color: rgb(78, 68, 60); background-color: rgb(252, 252, 250);"> 所做的）；</span>`reset`<span style="color: rgb(78, 68, 60); background-color: rgb(252, 252, 250);"> 移动 HEAD 指向的分支。</span>

# 7.7 Git 工具 - 重置揭密 [TODO]

值得好好看一下

# 7.3 Git 工具 - 储藏与清理

*   文中出现的 `git stash` 的各种参数和用法

<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);">因为它被设计为从工作目录中移除未被追踪的文件。 如果你改变主意了，你也不一定能找回来那些文件的内容。 一个更安全的选项是运行 </span>`git stash --all`<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);"> 来移除每一样东西并存放在栈中。</span>

<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);">默认情况下，</span>`git clean`<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);"> 命令</span>**只会移除没有忽略的未跟踪文件**<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);">。</span>** ****任何与 **`**.gitiignore**`** 或其他忽略文件中的模式匹配的文件都不会被移除**<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);">。 如果你也想要移除那些文件，可以给 clean 命令增加一个 </span>`-x`<span style="background-color: rgb(252, 252, 250); color: rgb(78, 68, 60);"> 选项。</span>
