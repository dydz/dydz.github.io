---
layout: post
title: Write boring code
description: "Code should be simple to help make it easier to read and more obvious when a bug is introduced. Here's a technique I use to come up with boring code."
date: 2021-08-21 22:46 -0700
last_revised: 2021-08-24 09:47 -0700
---
Code should be simple to help make it easier to read and more obvious when a bug is introduced.

> <a href="https://youtu.be/QhhFQ-3w5tE?t=1496" target="_blank" rel="noreferrer noopener" title="Link to Steve's direct quote">The least expensive, most bug-free line of code is the one you didn't have to write.</a> – <a href="https://www.informit.com/articles/article.aspx?p=1353402" target="_blank" rel="noreferrer noopener">Steve Jobs as quoted by Eric Buck</a>

It's also entirely possible, though may be hard to achieve, to write code that is easy to read and maintain with few comments. Both can be achieved by using simple algorithms and data structures, picking the right data types for plain old data, the right control flow directives (`if` vs `while` vs `do while`, etc.), and choosing good names for things. When a more complicated solution is needed for performance (identified by measurement) or other business purposes then it should be bottled up behind an interface that is simple to use correctly and hard to use incorrectly.

Here are some things I think about as I am writing code:

1. Can I make use of some existing function or data structure to avoid having to write more code?
3. Is this expression easy to understand or should I give it a name? For example, `x % 2 == 0` vs `bool isEven = x % 2 == 0;`?
4. Would this be easier to understand if I avoided reusing a variable?
7. Can I `assert()` my assumptions?

