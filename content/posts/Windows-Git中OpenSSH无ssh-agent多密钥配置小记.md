---
title: Windows-Git中OpenSSH无ssh-agent多密钥配置小记
date: 2018-03-17 22:34:56
tags: 
  - Git
  - SSH
  - 开发工具
---

最近Git环境崩了，只好重新配置一下。笔者使用的是Windows环境，众所周知，Windows下面配置各种环境都很坑的，Git也不例外。我感觉最大的坑就是SSH的问题。Windows下面 `ssh-agent` **不自动启动，不长驻内存**。当然，我可以强行设置一波系统自启动，也可以通过配置使得在启动 Git Bash 的时候先静默执行agent再进入环境——虽然都可以解决问题，**但是总是感觉不舒服**。此外，我手里也有多个私钥，在使用Git时，**我需要把这些私钥都载入**。

<!-- more -->

为了舒服地使用Git，当然要义无反顾地踏上配置之路。

在正式开始之前，先看看笔者之前的操作是什么样子的。

## 原先的方法：手动执行命令

打开终端，Push/Pull之前，需要手动执行命令后台启动`ssh-agent`，并向其中添加密钥。[【】](https://www.jianshu.com/p/1adbd697b249)
```bash
# 静默启动 ssh-agent
exec ssh-agent bash
eval ssh-agent -s
# 添加密钥
ssh-add "C:\Users\Administrator\.ssh\my_first_private_key"
# 你也可以添加更多的
ssh-add "C:\Users\Administrator\.ssh\my_second_private_key"
```
如此一番操作以后SSH密钥才可以使用——实在太麻烦了！


## Open SSH 命令家族

### 什么是`ssh-agent`

[OpenSSH 文档](http://www.openssh.com/manual.html)中是这么解释的：
> ssh-agent 是一个保存用于公钥认证的私钥的程序。所有其他窗口或程序都作为 ssh-agent 程序的客户端启动。

说白了，它就是一个专门用于保管密钥的程序嘛。

### `ssh` 命令

ssh应该是最常用的一条命令了。它提供了很多参数，但是有一个参数引起了我的注意。
> **-i identity_file<br>**
>    Selects a file from which the identity (private key) for public key authentication is read. **The default is ~/.ssh/id_dsa, ~/.ssh/id_ecdsa, ~/.ssh/id_ed25519 and ~/.ssh/id_rsa**. **Identity files may also be specified on a per-host basis in the configuration file.** It is possible to have multiple -i options (and multiple identities specified in configuration files). If no certificates have been explicitly specified by the CertificateFile directive, ssh will also try to load certificate information from the filename obtained by appending -cert.pub to identity filenames. 

SSH可以使用多个 `-i` 选项手动指定密钥文件，也可以使用ssh-agent。
`（文档中提到了 The most convenient way to use public key or certificate authentication may be with an authentication agent.）`

`-i` 选项的默认值包含 `~/.ssh/id_rsa`——难怪很多教程中的私钥都有这个默认的文件名——这意味着免于配置。自然，如果你的密钥是别的文件名，那就需要一番配置了。



## 如何让SSH自动加载密钥？

所以，使SSH自动加载密钥的关键就在于配置文件。那么配置文件是什么？

`ssh` 依次从下面的三个地方读取配置。
1. 命令行选项（就是指上面的`ssh -i`）
2. 用户级配置文件 `~/.ssh/config`
3. 系统级配置文件 `/etc/ssh/ssh_config`

嗯，就拿 `~/.ssh/config` 动刀子吧。（此文件或需手动创建）

### 编写配置

OpenSSH 文档里面有详尽的配置文件的编写说明，这里不再作重复叙述，其中值得关注的选项有下面几个：
* **IdentitiesOnly**
  <br>是否要仅从配置文件中确定要加载的私钥文件。值是 `yes`/`no`。设置为`yes`，ssh会忽略ssh-agent中的密钥。
* **IdentityFile**<br>
  密钥文件路径，可以添加多行`IdentityFile`。
* **AddKeysToAgent**<br>
  `yes` or `no`。是否需要把密钥自动添加进`ssh-agent`中，就好像使用了`ssh-add`。

.

大家根据自己的需要自行编写。下面是笔者的部分配置：
```bash
AddKeysToAgent yes
IdentityFile ~/.ssh/oschina_ssh_rsa
IdentityFile ~/.ssh/github_rsa
IdentityFile ~/.ssh/id_rsa  # the default path value
```
.

可以针对不同的主机使用[不同的配置](https://stackoverflow.com/questions/2419566/best-way-to-use-multiple-ssh-private-keys-on-one-client)
```bash
Host myshortname realname.example.com
    HostName realname.example.com
    IdentityFile ~/.ssh/realname_rsa  # private key for realname
    User remoteusername

# 支持使用通配符，详见文档
Host myother *.example.org
    HostName realname2.example.org
    IdentityFile ~/.ssh/realname2_rsa
    User remoteusername

# 这么写也可以
Host *
    IdentityFile ~/.ssh/id_rsa
```



## 测试配置是否正确

以Github为例

```bash
$ ssh -T git@github.com

  The authenticity of host 'github.com (IP ADDRESS)' cant be established.
  RSA key fingerprint is 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48.
  Are you sure you want to continue connecting (yes/no)?  yes
  
  Hi username! Youve successfully authenticated
```

这就没问题了！解决！

## 我遇到的奇葩的坑

我当时的情况是，私钥文件写进去总是没变化。

。。。

原来，我的 Git Cygwin Bash 中的`~`是一个奇怪的路径！我按照`C:\Users\my_username\`放置的密钥文件和配置文件自然就没作用了。

这个问题不太好发现，可解决方法却很简单：只要把系统的`HOME`环境变量改过来就可以了。

## TortoiseGit

这是我最喜爱的 Git GUI ，将它和OpenSSH对接起来就再好不过了。
参见[这篇文章](https://stackoverflow.com/a/32115724/3906760)。


最终，完美解决。


