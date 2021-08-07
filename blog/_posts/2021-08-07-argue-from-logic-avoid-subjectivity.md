---
layout: post
title: Argue from a position of logic; avoid subjectivity
date: 2021-08-07 14:27 -0700
---
The most important thing to consider is the customer impact of doing something. The goal should be to always improve the customer experience with each change or, if that is a herculean effort at the moment, make it suck less. (Note that who the customer is will vary depending on the application. It doesn't just refer to the people that have paid for some product or service. The customer could be yourself.).

When applied to coding it can select for the [small, easily reviewed, logical changes (SLCs)]({% post_url 2021-07-22-git-done-right %}) that actually improve the customer experience. When applied in technical discussion, it will bring the discussion back to the most important thought: will doing X improve the customer experience? If so, why?

# Argue from a position of logic

Towards the principle, good debate requires that there be at least two or more solutions to the problem at hand and that these solutions have been compared against each other to produce a list of pros and cons. If the pros and cons are relatively equal then produce new pros and cons lists taking the following into account:

1. what's the likelihood the solution's assumptions will be violated in the near future (where near is on the order of 3-6 months)?

2. how simple is the implementation? how contained is it in the code base?

3. could the solution make it harder to work on other features or fix bugs in other areas?

4. could it make the code less understandable to a new hire?

5. how hard will it be to un-implement within 3-6 months if it turns out the solution isn't good? If not hard, how much time will it take?


After all this, if there are still two equally good (or bad) solutions then flip a coin because this means it doesn't matter anymore. Career wise, coin flipping should be done once in a blue moon. If you find you are doing this more than that then either you didn't find all the pros and cons or you may be burned out. Start over if the former. Take a small break or a vacation if the latter.

