---
layout: post
title: Document your steps through scripts
date: 2021-07-16 22:02 -0700
---
Step 1. Step 2. Step 3...and then sometimes you're done...setting up your workstation, pulling some data from your phone, or trying to bring up a <a href="https://jekyllrb.com/docs/installation/macos/" target="_blank" rel="noreferrer noopener">blog</a>. Sometimes not, sometimes there are more steps. Why not write a script instead?

A script can both document the steps and provide a way for the computer to run them for you. The disadvantage of writing a script is the time it takes to do so.

One strategy I've found is to iteratively develop the script over a few runs of the same steps. I'll start out with a script that is mostly comments or just a URL reference to the steps. Then flush it out making many hardcoded assumptions. Then I'll parameterize it and flush it out more. Each time I work on the script I'll devote only as much time as I'm willing to: 5 minutes, 10 minutes, 30 minutes, and then move on with my day. Eventually I have a script.

This is the strategy I used to write the <a href="https://github.com/dydz/dydz.github.io/blob/main/configure-machine-for-blogging" target="_blank" rel="noreferrer noopener">script to configure my machine for blogging</a>.

## Example

To make this post more concrete, I'll walk through creating a part of my <a href="https://github.com/dydz/dydz.github.io/blob/main/configure-machine-for-blogging" target="_blank" rel="noreferrer noopener">configure-machine-for-blogging</a> script from scratch.

First I open my browser to <a href="https://jekyllrb.com/docs/installation/macos" target="_blank" rel="noreferrer noopener">https://jekyllrb.com/docs/installation/macos</a>.

<img src="/assets/images/jekyll-install-command-line-tools.png" alt="Jekyll's first step: Install command line tools by running xcode-select --install" width="567" height="423" srcset="/assets/images/jekyll-install-command-line-tools.png 1x, /assets/images/jekyll-install-command-line-tools@2x.png 2x">

Then I create a new text file with:

```bash
#!/bin/sh

xcode-select --install
```

Boom! I keep myself focused on writing the script just for me and my machine:

```bash
#!/bin/sh

xcode-select --install

export SDKROOT=$(xcrun --show-sdk-path)
```

Now I run my script. Next I hit section <a href="https://jekyllrb.com/docs/installation/macos/#install-ruby" target="_blank" rel="noreferrer noopener">Install Ruby</a> and read through it. Then I amend my script to ignore the output of "xcode-select" and check if "ruby" is in my PATH because the latter is the invariant:

```bash
#!/bin/sh

xcode-select --install >/dev/null 2>&1

if ! which ruby >/dev/null 2>&1; then
    echo "Couldn't find ruby. Is it installed?" >&2
    exit 1
fi

export SDKROOT=$(xcrun --show-sdk-path)
```

By the way, I redirect my "echo" output to standard error (`>&2`) since such a message reads like an error. This also future proofs the script for use in a <a href="https://en.wikipedia.org/wiki/Pipeline_(Unix" target="_blank" rel="noreferrer noopener">pipeline</a>.

Continuing, I skip some sections that don't apply to my machine and get to the <a href="https://jekyllrb.com/docs/installation/macos/#install-jekyll" target="_blank" rel="noreferrer noopener">Install Jekyl</a> section:

<img src="/assets/images/jekyll-install-jekyll.png" alt="Jekyll's third step: Install Jekyll" width="561" height="574" srcset="/assets/images/jekyll-install-jekyll.png 1x, /assets/images/jekyll-install-jekyll@2x.png 2x">

It tells me to install Jekyll. Then get my Ruby version to build the PATH to export, but it only uses the major and minor version numbers. I chose to compute that version string and after reading the Ruby API docs came up with a Ruby script and encoded that into my shell script:

```bash
#!/bin/sh

xcode-select --install >/dev/null 2>&1

if ! which ruby >/dev/null 2>&1; then
    echo "Couldn't find ruby. Is it installed?" >&2
    exit 1
fi

export SDKROOT=$(xcrun --show-sdk-path)
gem install --user-install bundler jekyll

rubyVersion=$(ruby -e 'puts [RbConfig::CONFIG["MAJOR"], RbConfig::CONFIG["MINOR"], 0].join(".")') # Ignore teeny version
pathToRubyGemBinaryDirectory="$HOME/.gem/ruby/$rubyVersion/bin"
```

Now I have a variable  `pathToRubyGemBinaryDirectory` whose value is exactly the path that needs to be in my PATH. I only need to export it if it's not already in my PATH. I wrote some helper functions to check if it's already in my PATH. When I got to the part of exporting the PATH and amending my .zshrc I chose to just emit instructions to do this for now because I keep that file organized and didn't want to code something more involved:

```bash
#!/bin/sh

hasDirectoryInPathLikeVariable()
{
    ... # Elided for brevity. 
}

hasDirectoryInPathEnvironmentVariable()
{
    ... # Elided for brevity. 
}

xcode-select --install >/dev/null 2>&1

if ! which ruby >/dev/null 2>&1; then
    echo "Couldn't find ruby. Is it installed?" >&2
    exit 1
fi

export SDKROOT=$(xcrun --show-sdk-path)
gem install --user-install bundler jekyll

rubyVersion=$(ruby -e 'puts [RbConfig::CONFIG["MAJOR"], RbConfig::CONFIG["MINOR"], 0].join(".")') # Ignore teeny version
pathToRubyGemBinaryDirectory="$HOME/.gem/ruby/$rubyVersion/bin"

hasRubyGemBinaryDirectoryInPath=$(hasDirectoryInPathEnvironmentVariable "$pathToRubyGemBinaryDirectory")
if [ "$hasRubyGemBinaryDirectoryInPath" = "0" ]; then
    echo "Ensure the following is in your PATH:" >&2
    echo "    $pathToRubyGemBinaryDirectory" >&2
fi
```

And that's it for this example. The script evolved from this: I encoded more steps, enabled some diagnostics, and ran it through <a href="https://www.shellcheck.net" target="_blank" rel="noreferrer noopener">ShellCheck</a>. The full script is at:

<a href="https://github.com/dydz/dydz.github.io/blob/main/configure-machine-for-blogging" target="_blank" rel="noreferrer noopener">https://github.com/dydz/dydz.github.io/blob/main/configure-machine-for-blogging</a>

