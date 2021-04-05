---
title: Pro Git Reading Note Part II
date: 2018-11-18 13:15:57
summary: "<q>Pro Git</q>读书笔记——那些我还不会的知识"
draft: true
tags:
  - Git
---


# Git Guide

## 7.2 Git 工具 - 交互式暂存



text-rendering
/* Keyword values */
text-rendering: auto;
text-rendering: optimizeSpeed;
text-rendering: optimizeLegibility;
text-rendering: geometricPrecision;




## 7.14 Git 工具 - 凭证存储

#### Git 凭证存储

```console
&#36; git config --global credential.helper cache
```

- default
- cache
- store
- osxkeychain
- winstore

Git 甚至允许**你配置多个辅助工具**。 当查找特定服务器的凭证时，Git 会按顺序查询，并且**在找到第一个回答时停止查询**。 当保存凭证时，Git 会将用户名和密码发送给 **所有** 配置列表中的辅助工具，它们会按自己的方式处理用户名和密码。 如果你在闪存上有一个凭证文件，但又希望在该闪存被拔出的情况下使用内存缓存来保存用户名密码，`.gitconfig` 配置文件如下：

```ini
[credential]
    helper = store --file /mnt/thumbdrive/.git-credentials
    helper = cache --timeout 30000
```

* 也可自己写一个认证程序 *
* 正如你看到的，扩展这个系统是相当简单的！



当你碰到问题时，你应该可以很容易找出是哪个分支在什么时候由谁引入了它们。 如果你想在项目中使用子项目，你也已经知道如何来满足这些需求。 到此，**你应该能毫无压力地在命令行中使用 Git 来完成日常中的大部分事情**。



## 8.1 自定义 Git - 配置 Git



```console
&#36; git config --global core.editor emacs
```
- :heart:
  ```
  &#36; git config --global commit.template ~/.gitmessage.txt
  ```

- 全局排除 :heart:
   `git config --global core.excludesfile ~/.gitignore_global`
   
    > `core.excludesFile`
    >  Specifies the pathname to the file that contains patterns to describe paths that are not meant to be tracked, in addition to .gitignore (per-directory) and .git/info/exclude. Defaults to &#36;XDG_CONFIG_HOME/git/ignore. If &#36;XDG_CONFIG_HOME is either not set or empty, &#36;HOME/.config/git/ignore is used instead. See gitignore[5].

- 如果你把 `help.autocorrect` 设置成 1，那么只要有一个命令被模糊匹配到了，Git 会自动运行该命令。

##### 外部的合并与比较工具

- `git mergetool --tool=<tool></tool>`

  > -t <tool></tool>
  >
  > --tool=<tool></tool>
  >
  > Use the merge resolution program specified by <tool></tool>. <u>Valid values include emerge, gvimdiff, kdiff3, meld, vimdiff, and tortoisemerge. Run `git mergetool --tool-help` for the list of valid <tool></tool> settings.</u>
  >
  > <u>If a merge resolution program is not specified, *git mergetool* will use the configuration variable`merge.tool`</u>. If the configuration variable `merge.tool` is not set, *git mergetool* will pick a suitable default.

- `diff.external`

  > If this config variable is set, diff generation is not performed using the internal diff machinery, but using the given command. Can be overridden with the ‘GIT_EXTERNAL_DIFF’ environment variable.
























