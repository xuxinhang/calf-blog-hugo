---
title: 关于Promise的几个Tips
date: 2018-05-18 12:54:08
summary: 天天用的 Promise，你真的了解它吗？
tags:
  - Javascript
  - Promise
---



#  Promise 概念

略

# TIPS1 返回值和方法链

```
Promise#then(resolveCallback [, rejectCallback])
Promise#catch(rejectCallback)
```

（其实就是同个方法）

如果Promise是接受态的，会调用resolveCallback，至于会传入什么参数，就要看Promise 写成什么样子了。
Promise是拒绝的，会调用rejectCallback。

Promise机制的最大好处：链式调用
Promise#then 仍然返回一个Promise，所以可以链式调用Promise#then，一次完成多个异步动作

## Callback的返回值和Promise#then的返回值

### 返回值

then方法返回一个Promise，而它的行为与then中的回调函数的返回值有关：
• 如果then中的回调函数返回一个值，那么then返回的Promise将会成为接受状态，并且将返回的值作为接受状态的回调函数的参数值。
• 如果then中的回调函数抛出一个错误，那么then返回的Promise将会成为拒绝状态，并且将抛出的错误作为拒绝状态的回调函数的参数值。

• 如果then中的回调函数返回一个已经是接受状态的Promise，那么then返回的Promise也会成为接受状态，并且将那个Promise的接受状态的回调函数的参数值作为该被返回的Promise的接受状态回调函数的参数值。
• 如果then中的回调函数返回一个已经是拒绝状态的Promise，那么then返回的Promise也会成为拒绝状态，并且将那个Promise的拒绝状态的回调函数的参数值作为该被返回的Promise的拒绝状态回调函数的参数值。
• 如果then中的回调函数返回一个未定状态（pending）的Promise，那么then返回Promise的状态也是未定的，并且它的终态与那个Promise的终态相同；同时，它变为终态时调用的回调函数参数与那个Promise变为终态时的回调函数的参数是相同的。

- Callback中 return
  \#then返回一个接受态的Promise。相当于Promise.resolve(what_returned_by_your_code)
  于是你可以在链中接进去一个#then
- Callback中 throw。
  返回拒绝的Promise。= Promise.reject(what_thrown_by_you)
  会调用接下来的#catch
- Callback中返回Promise 接受态/拒绝态/等待态
  \#then返回值就是你在Callback中返回的Promise。因为这个特性，所以你可以进行多个连续的一环套一环的异步操作了。

【注意】上面的规则无论针对resolveCb还是rejectCb都是适用的，#then返回的Promise的状态和从哪个Callback返回的无关。即使是一个失败的Promise，经过#then的处理，也可以返回一个成功的Promise以继续方法链。
“在一个失败操作（即一个 catch）之后可以继续使用链式操作，即使链式中的一个动作失败之后还能有助于新的动作继续完成。”

【注意】JS引擎抛出的错误也会导致#then返回失败的Promise，但是不会在console里有任何提示。所以特别注意“静默失败”问题。 ----下面会再谈这个事情。

# TIPS2 Callback的坑

虽然在executor 里面可以 resolve(arg1, arg2, …) 或者reject(arg1, arg2, …)。但是在Callback只有第一个参数是可用的。
MDN上 也明确指出了这一点。参看MDN文档。

```
new Promise((resolve, reject) => {
  reject({a: 1, b: 2}, 'arg2')
}).catch((...args) => {
  console.log(args)
})

/*
[…]
  0: Object { a: 1, b: 2 }
  length: 1 /* ⚠ */
  __proto__: Array []
*/

/* 只好这样了：还算优雅吧 */
new Promise((resolve) => {
  resolve({a: 1, b: 2});
}).then(({a, b}) => {
  console.log(a, b);
})
```

# TIPS3 隆重介绍：Promise#finally

finally() 方法返回一个Promise，在执行then()和catch()后，都会执行finally指定的回调函数。避免同样的语句需要在then()和catch()中各写一次的情况。
\#finally的返回值：返回此#finally附加到的Promise本身。
finally的回调函数中不接收任何参数

但是现在浏览器支持还不算很好。

# TIPS5 `.then(success, fail)` 与 `.then(success).catch(fail)` 的区别

.catch 里的fail会把.then的success中的错误捕获住。但是前一种方法不会

```
var somePromise = Promise.resolve({code: 200, data: 'OK'});

somePromise
.then(() => {
  undefined.undefined;
  // A silly error you haven't noticed
  console.log('你的表单已提交！');
})
.catch(() => {
  console.error('提交表单时遇到问题，请检查网络！');
})

/**
 * [ERROR] "提交表单时遇到问题，请检查网络！"
 * 你可能会先从 somePromise 上找问题
 * 你手抖写下的错误代码被“藏”起来了
 */


somePromise
.then(() => {
  undefined.undefined;
  // A silly error you haven't noticed
  console.log('你的表单已提交！');
}, () => {
  console.error('提交表单时遇到问题，请检查网络！');
})

/*
 * TypeError: undefined has no properties
 * 我想你一看控制台就知道问题出在哪里了
*/
```

**小调查：你们喜欢怎么写？**

# TIPS7 深入JS引擎，探究 Promise 与 Event Loop

来自hzy的解答（基于Node.js / V8）

<https://newbbs.bingyan.net/topics/850>

问题：**ECMAScript 规范中没有叫 Event Loop、Task List、Micro Task 等概念！** 所以，还是读规范吧。

开始阅读ECMA规范

Note
Typically an ECMAScript implementation will have its Job Queues pre-initialized with at least one PendingJob and one of those Jobs will be the first to be executed. An implementation might choose to free all resources and terminate if the current Job completes and all Job Queues are empty. Alternatively, it might choose to wait for a some implementation specific agent or mechanism to enqueue new PendingJob requests.

The following abstract operations are used to create and manage Jobs and Job Queues:

running execution context == 执行栈

但是，PromiseJobs执行的先后次序规范中没有提到
所以，读规范读到最后，还是不知道是怎么回事。
但是，现在的主流浏览器中Promise回调都在其他回调（如setTimeout）之前。待解答。

## 尾声：看一道题目

```
console.log(1);
new Promise(function (resolve, reject){
    reject(true);
    window.setTimeout(function (){
        resolve(false);
    }, 0);
}).then(function(){
    console.log(2);
}, function(){
    console.log(3);
});
console.log(4);
```

来自 <https://segmentfault.com/a/1190000006172528>

### 参考

<https://jakearchibald.com/2015/tasks-microtasks-queues-and-schedules/>