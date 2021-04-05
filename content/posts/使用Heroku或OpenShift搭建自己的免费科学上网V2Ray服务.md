---
title: 使用 Heroku 或 OpenShift 搭建自己的免费科学上网 V2Ray 服务
date: 2019-02-12 22:16:40
tags:
  - 科学上网
  - V2Ray
---



# 使用 Heroku 或 OpenShift 搭建自己的免费科学上网 V2Ray 服务


## 选择一款墙外的云服务

### 如果有点钱：买一个云

这里还是推荐使用付费的云服务器，因为它的性能更加稳定，而且有良好的技术支持。只要所选的服务器位于墙外的网络上就可以。

### 蓐羊毛：使用免费云

如果不想出这笔钱，也可选择境外的免费云服务。这里选择的是 Heroku 和 OpenShift，而且也**不需要信用卡**认证。这两个网站的登录、注册和管理页面需要翻墙才能进入。所以，需要提前备一个翻墙服务，直到完成服务器的部署。

免费的服务一般速度会比较慢，延迟高，而且也不稳定。如果你需要快速、更稳定的翻墙服务就不要在这上面打主意了，买一个靠谱的云服务吧！

### 使用 Heroku

1. 进入 [Heroku](https://heroku.com)，注册一个账户，登录。可能需要翻墙才能进入注册页面。

2. 进入管理页面， `New` -> `Create New App`   选择服务器位置，选择 "Europe" 还是 "US" 看自己，可以都试一试。

3. 进入新建的 App，“Settings”中，添加一个环境变量 “`V2RAY_CONFIG_JSON`”，内容为你的 JSON 配置内容。（这里的 value 框可以输入多行，这个设计很不错！）

4. 进入“Deploy”，选择使用“Heroku CLI”，照网页上的指导进行操作，完成部署。

    > 另外也有几个命令值得关注：
    >
    > `heroku git:remote` - 添加 remote 到现有的仓库 [Link](https://devcenter.heroku.com/articles/heroku-cli-commands#heroku-git-remote)
    >
    > ...
    >
    > 更详细的步骤可见 [Deploy the app](https://devcenter.heroku.com/articles/getting-started-with-nodejs#deploy-the-app)

    一般来说，只要一 push，部署过程就会自动执行。

#### 服务端配置示例

```json
{
  "log": {
    "error": "./error.log",
    "loglevel": "warning"
  },
  "inbounds": [{
    "port": "env:PORT",           // 要监听的端口使用环境变量定义的值
    "listen": "0.0.0.0",          // 监听来自所有网络的流量
    "protocol": "shadowsocks",    // 使用 SS 协议
    "settings": {
      "method": "aes-256-cfb",    // 加密方式
      "password": "your_password" // 你自己的密码
    },
    "streamSettings": {
      "network":"ws"              // 使用 WebSocket 作为传输协议
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}
```

#### 一些问题

- Heroku 貌似只允许  HTTP 和 WebSocket 协议访问。
- Heroku 的免费版服务30 分钟无流量会进入休眠状态，之后再次有访问就会再唤醒服务。但是唤醒是需要时间的。这会表现为首次访问的卡顿。这是服务提供方的限制。可以使用网上的定时访问服务来实现 30 分钟做一次 HTTP 访问，阻止休眠。

  > 可到 <https://uptimerobot.com/> 设置每5分钟访问一次你的heroku app网址，防休眠。

- 每个 Heroku 账户一共有 550 小时的免费服务使用时间（认证账户有 1000 小时）。如果你的账户只有一个 V2Ray 的服务，一个月 550 小时应该够用了。

  > Heroku 免费账户的限制可见 https://www.heroku.com/pricing

- V2Ray 运行起来后，访问服务地址应有 “Bad Request” 字样。（服务地址可用 “Open app” 按钮来打开。）如果没有，可能是 V2Ray 程序未启动。此时应 使用 “More” -> “Run Console” 手动运行 `./Procfile` 的 `web:` 后的脚本。

  > Procfile 的编写可见 https://devcenter.heroku.com/articles/procfile 

#### 如果要修改代码

- `PORT` 环境变量是由 Heroku 自定的，代表 Heroku 对我们暴露的端口。配置中可以用 `"port": "env:PORT"`   来将 `PORT` 环境变量作为服务端 `port` 的配置。Heroku 做了端口映射，这里的 `PORT` 对应 Heroku App 对外的 80 端口。[见这里](https://devcenter.heroku.com/articles/runtime-principles#web-servers)
- ...



### 使用 OpenShift

1. GitHub 上新建自己的代码仓库，将代码提交到上面

2. 注册账户，登录，选择使用 Starter Plan。进入 Starter Plan 的控制台。（可能需要翻墙才能进入注册页面。）
3. 新建一个 Project ，进入，选 “Browser Catalog” -> "Node.js" 。 “Git Respository” 填入你的仓库地址。点 “Create”。
4. 现在，OpenShift 应该已经迫不及待地先拉取代码，Build，再 Deploy 了。
5. 但是，还有几步要做。配置环境变量：
   - 进入 “Overview” ，在 Application - Deploy Config 下，点击三个点 -> “Edit”
   - "Environment Variables" 下新增两个环境变量，保存：
     - `V2RAY_CONFIG_JSON` ：填写 V2Ray 配置，只能填一行。填入的内容要符合 JSON 格式，*注意剔除注释*。
     - `PORT`：指定 inbound 端口，这里是 “8080”。（和 “Application” -> “Routes” 下的配置一致。）
6. 调整路由：
   - 前往 “Overview” - <你的Application名称> - “Networking”。
   - 未配置路由请点击 “Create Route” 。已配置路由则进入 “Application” -> “Routes”，进入对应项目，执行 “Action” - “Edit”。
   - “Security” 下勾选 “Secure route”，保存。
7. 重新部署。 “Application” -> “Deployment” -> *<你的Application名称>* -> 点 “Deploy” 按钮。 
8. 如果你更新了代码仓库，想更新 Project，要先到 “Builds” -> "Builds" 下进行构建，再到 “Application” -> “Deploy” 做部署。
9. 如果返回 Overview 界面能看到服务器地址了，那么服务端已经大功告成。直接访问服务的 HTTPS 地址应有 “Bad Request” 字样。

#### 一些问题

- OpenShift 免费的 Starter Plan [亦有限制](https://www.OpenShift.com/products/online/)：
  - Starter Plan 下只许有一个 Project
  - 同样在 30min 无活动后休眠，且每 72 小时内需有 18 小时的休眠时间。（如果你不是三天三夜不合眼翻墙，应该也够了。）
  - 60 天之后自动过期，到时需 resubscribe 。
- 不过 OpenShift 支持 TCP 直连，所以你也可使用性能更好的 TCP 传输协议而不是本仓库中用的 WebSocket。

#### 如果你要修改代码

- 只有 Build 环节才可 `chmod`，一旦构建为 Image，部署后执行`chmod`是没有权限的。
- 默认在 Node.js 项目中，Build 过程调用 `npm build`；Deploy 过程调用 `npm start` 运行程序。
- 也可以使用自己的 Build / Deploy 脚本。参见 [Stackoverflow](https://stackoverflow.com/questions/46091601/cannot-chmod-file-on-OpenShift-online-v3-operation-not-permitted)。
- ...

#### 服务端 V2Ray 配置示例

```json
/* 和 Heroku 的几乎完全一样，复制过去注意删去注释 */
{
  "log": {
    "error": "./error.log",
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": "env:PORT",
      "listen": "0.0.0.0",
      "protocol": "shadowsocks",
      "settings": {
        "method": "aes-256-cfb",
        "password": "your_password"   // 修改为你的密码
      },
      "streamSettings": {
        "network": "ws"
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
```



## V2Ray 客户端配置

### 关于 V2Ray

V2Ray 是新一代的科学上网利器。它更为小众，支持的协议也更多，更不容易被封禁。

V2Ray **原生支持多协议**，包括但不限于Socks、HTTP、Shadowsocks、VMess等；也支持使用 WebSocket，TCP，TLS 等**多种传输协议进行传输**。此外，V2Ray 内置灵活的路由，通过内置的路由功能，它可以灵活地实现选择性转发、直连或是阻止部分连接。对 DNS 服务也有基本的支持。

可见 [V2Ray 文档](https://www.**v2ray**.com) 和 [V2Ray 白话文教程](https://toutyrater.github.io/)

###### 本文为什么使用 V2Ray？

因为 Heroku 只支持 HTTP 和 WebSocket 协议，所以原生支持 WebSocket 作为传输协议的 V2Ray 就是不二之选了。（OpenShift 貌似没这一限制。）

另外，需要注意的是，“协议”和“传输协议”是不一样的。“传输协议”是“协议”的载体。

### 使用客户端

到 [github.com/v2ray/v2ray-core](https://github.com/v2ray/v2ray-core/releases) 下载 V2Ray，按照 V2Ray 文档所述运行。如果不指定 `-config` 参数，默认使用同目录下的 `config.json` 文件。

可以将配置文件保存为同目录下的 `config.json`， 然后直接运行 `v2ray`。

> Windows 下的 GUI 可使用 V2RayN 
>
> macOS GUI 可用 V2RayX 
>
> Android 下可使用 BifrostV、V2Ray Go、V2RayNG、Actinium
>
> 可见 [这篇文章](https://www.i5seo.com/v2ray-android-v2rayng-actinium-bifrostv-v2ray-go-actinium.html)

#### 客户端配置示例 (Heroku)


```JSON
{
  "inbounds": [
    {
      "port": 1081,
      "protocol": "socks",
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls"]
      },
      "settings": {
        "auth": "noauth"
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "your_app_name.herokuapp.com", // 域名，可在 Settings 中找到
            "method": "aes-256-cfb",                  // 对应
            "password": "your_password",              // 服务端配置中对应的密码
            "port": 80                                // 默认 80 端口
          }
        ]
      },
      "streamSettings":{
        "network":"ws"
      },
      "mux": { "enabled": true }                      // 多路复用
    }
  ]
}
```

#### 客户端配置示例 (OpenShift)

```json
{
  "inbounds": [
    {
      "port": 1081,
      "protocol": "socks",
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls"]
      },
      "settings": {
        "auth": "noauth"
      }
    }
  ],
  "outbounds": [
    {
      "tag": "OpenShift",
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "your.name.OpenShiftapps.com", // 域名，在 Overview 或 Routes 中找到
            "method": "aes-256-cfb",
            "password": "your_password",              // 服务端配置中对应的密码
            "port": 443                               // wss 默认使用 433 端口
          }
        ]
      },
      "streamSettings":{
        "network":"ws",
        "security": "tls",          // 对应服务端的设置，这里使用加密的 WebSocket 协议
        "tlsSettings": {
          "allow Insecure": true
        }
      },
      "mux": { "enabled": true }
    }
  ]
}
```

### 浏览器连接到 V2Ray 客户端

自行 Google

配置要和客户端 `inbounds` 配置对应



------



## 参考

1. https://51.ruyo.net/1469.html
2. [利用OpenShift搭建免(翻)费(墙)科技](https://51.ruyo.net/1469.html)
3. [利用Heroku搭建免费科学爬墙（亲测可行）](https://51.ruyo.net/1461.html)
4. [OpenShift使用方法介绍](http://www.live-in.org/archives/1818.html)
5. [OpenShift V3版操作使用指南-入门版（附福利）](https://51.ruyo.net/4023.html)
6. [使用OpenShift的免费服务器搭建V2Ray](http://suki.live/2018/10/25/%E4%BD%BF%E7%94%A8OpenShift%E7%9A%84%E5%85%8D%E8%B4%B9%E6%9C%8D%E5%8A%A1%E5%99%A8%E6%90%AD%E5%BB%BAV2Ray/)
7. [openshift 部署 V2Ray  Websocket 服务端成功，客户端怎么弄，谢谢大神解惑！](https://github.com/wangyi2005/v2ray/issues/8#)
8. [shadowsocks-heroku（美国）配合DnsJumper小公举，速度稳定在2M](https://github.com/onplus/shadowsocks-heroku/issues/57#)  
9. [Heroku部署免费的V2Ray节点](https://xlesun.com/v2ray-1.html)
10. https://bbs.hupu.com/19816661.html
11. [heroku部署SS](http://cyjun.win/2017/06/03/heroku%E9%83%A8%E7%BD%B2SS/)
12. [【教程】使用OpenShift搭建V2ray出国旅游](https://lsland.cn/Technical/OpenShift.html)