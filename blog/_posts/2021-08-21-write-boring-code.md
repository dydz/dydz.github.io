---
layout: post
title: Write boring code
description: "Code should be simple to help make it easier to read and more obvious when a bug is introduced. Here's a technique I use to come up with boring code."
date: 2021-08-21 22:46 -0700
---
Code should be simple to help make it easier to read and more obvious when a bug is introduced.

> <a href="https://youtu.be/QhhFQ-3w5tE?t=1496" target="_blank" rel="noreferrer noopener" title="Link to Steve's direct quote">The least expensive, most bug-free line of code is the one you didn't have to write.</a> – <a href="https://www.informit.com/articles/article.aspx?p=1353402" target="_blank" rel="noreferrer noopener">Steve Jobs as quoted by Eric Buck</a>

<!--
I could not determine if this is direct quote of Jobs or not. It seems to be an indirect quote by Erik Buck. He attributed the quote to Jobs in the Jun 5th, 2009 article "From NeXTSTEP to Cocoa: Erik Buck on the Development of Cocoa and Objective-C, <https://www.informit.com/articles/article.aspx?p=1353402>. As far as I can tell, the direct quote is: "The line of code that the developer can write the fastest, the line of code that the developer can maintain the cheapest, and the line of code that never breaks for the user, is the line of code that the developer never had to write." (MacWorld Expo in San Francisco, 7 Jan. 2012, <https://youtu.be/QhhFQ-3w5tE?t=1496>).
-->

It's also entirely possible, though may be hard to achieve, to write code that is easy to read and maintain with few comments. Both can be achieved by using simple algorithms and data structures, picking the right data types for plain old data, the right control flow directives (`if` vs `while` vs `do while`, etc.), and choosing good names for things. When a more complicated solution is needed for performance (identified by measurement) or other business purposes then it should be bottled up behind an interface that is simple to use correctly and hard to use incorrectly.

Here's a technique I use to come up with the simplest solution: first solve the problem for correctness using whatever approach comes to mind. Then iteratively reduce the solution to the fewest machine instructions and smallest memory footprint, devoting only as much time as I'm willing to.

Be practical when doing this step: if the code can't be reduced without becoming harder to understand then reduce the code to the fewest source level lines that are still understandable. For example, logically you may be able to reduce the binary- and runtime- size of some code that uses a hash table by using a plain array of (key, value) objects, but it may be more practical to use a hash table to map keys to values.

The reduced solution tends to be very clever and requires comments. Then I work backwards from this, replacing low level primitives (e.g. `for (unsigned i = 0; i < size; ++i)`) with higher level ones (e.g. `items.contains(item)`) until the solution needs few or no comments.

How do you know when to stop? When you're bored reading the code and want to move on.

(Pro tip: Write some tests after first solving the problem for correctness. Then use those tests to sanity check the re-write).

## Example

Here's a concrete example (just glance at the code):

**Involved**:

```javascript
function toggleAttribute(elementID, attributeName)
{
    var element = document.getElementById(elementID);
    if (!element.hasAttribute(attributeName))
        element.setAttribute(attributeName, "true");
    if (element.getAttribute(attributeName) === "true")
        element.setAttribute(attributeName, "false");
    else
        element.setAttribute(attributeName, "true");
    return element.getAttribute(attributeName) === "true";
}

toggleAttribute(... /* elided for brevity */, "collapsed");
```

Did you roll your eyes? This code is complicated. Now, glance at this code:

**Boring:**

```javascript
function toggleCollapsed(element)
{
    element.classList.toggle("collapsed");
}

toggleCollapsed(... /* elided for brevity */);
```

It's boring. Just like it should be.

