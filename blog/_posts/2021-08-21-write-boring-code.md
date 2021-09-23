---
layout: post
title: Write boring code
description: "Code should be simple to help make it easier to read and more obvious when a bug is introduced. Here's a technique I use to come up with boring code."
date: 2021-08-21 22:46 -0700
last_revised: 2021-08-27 22:46 -0700
---
Code should be simple to help make it easier to read and more obvious when a bug is introduced.

> <a href="https://youtu.be/QhhFQ-3w5tE?t=1496" target="_blank" rel="noreferrer noopener" title="Link to Steve's direct quote">The least expensive, most bug-free line of code is the one you didn't have to write.</a> – <a href="https://www.informit.com/articles/article.aspx?p=1353402" target="_blank" rel="noreferrer noopener">Steve Jobs as quoted by Eric Buck</a>

It's also entirely possible, though may be hard to achieve, to write code that is easy to read and maintain with few comments. Both can be achieved by using simple algorithms and data structures, picking the right data types for plain old data, the right control flow directives (`if` vs `while` vs `do while`, etc.), and choosing good names for things. When a more complicated solution is needed for performance (identified by measurement) or other business purposes then it should be bottled up behind an interface that is simple to use correctly and hard to use incorrectly.

## Work forwards and backwards

One technique I use to come up with a simple solution is to work forwards and backwards: forwards to the most efficient solution and then backwards to the most readable. First solve the problem for correctness using whatever approach comes to mind. Then, only devoting as much time as I'm willing to, I iteratively reduce the solution to the fewest machine instructions and smallest memory footprint[^1]. The result is a solution that tends to be very clever, but would require comments. So, I selectively un-reduce (aka deoptimize); I work backwards, replacing low level primitives (e.g. `for (unsigned i = 0; i < size; ++i) { if (items[i] == ...) { ... } }`) with higher level ones (e.g. `items.contains(item)`) until the solution needs few or no comments.

Be practical when doing the reduction: if the code can't be reduced without becoming harder to read and understand then reduce the code to the fewest source level lines that are still understandable and easy to read. For example, logically you may be able to reduce the binary- and runtime- size of some code that uses a hash table by using a plain array of (key, value) objects and then iterate over them all to find something without a measurable perf. difference, but using a hash table to map keys to values may make the code easier to read.

How do you know when to stop? When you're bored reading the code and want to move on.

(Pro tip: Write some tests after first solving the problem for correctness. Then use those tests to sanity check the re-write towards boring).

## Additional thoughts

Here are some more things I think about as I am writing code:

1. Can I make use of some existing function or data structure to avoid having to write more code?
2. Can I `assert()` my invariants to avoid having to write more code?
3. Is this expression easy to understand or should I give it a name? For example, `x % 2 == 0` vs `bool isEven = x % 2 == 0;`?
4. Would this be easier to understand if I avoided reusing a variable?

[^1]: Although this seems counterintuitive, the primary motivation of this step is not to produce an efficient algorithm so much as it's to identify the absolute minimum parts that must be kept to ensure a correct solution. I stop as soon as these parts become apparent to me.
