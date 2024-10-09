# Forms

> UI library for creating applications in GameMaker

[![License](https://img.shields.io/github/license/blueburncz/Forms)](LICENSE)
[![Discord](https://img.shields.io/discord/298884075585011713?label=Discord)](https://discord.gg/ep2BGPm)

> **WARNING:** Forms is currently in development and usage in real-world apps is not advised before 1.0.0 is released!

## Table of Contents

* [About](#about)
* [Contributing](#contributing)

## About

Forms is a UI library for creating applications in GameMaker. Its origins trace back to [PushEd for GameMaker: Studio 1.4](https://github.com/GameMakerDiscord/PushEd), and after several years, it evolved into the system used in [BBMOD GUI](https://blueburn.cz/index.php?menu=bbmod_gui), with significant modifications. The version of Forms you see here is a complete rewrite, built on the foundations of its predecessors, but now leveraging modern GML features.

## Contributing

Forms is open for pull requests! You're welcome to choose any of the open issues or open a new one yourself and start a discussion. **It is mandatory that your coding style matches with the rest of the repo!** To ensure this, we are using the Python version of [js-beautify](https://github.com/beautifier/js-beautify) and a pre-commit hook. Here's how to set it up:

1. Install [Python 3](https://www.python.org/downloads/)
2. `git clone https://github.com/blueburncz/Forms.git`
3. `cd Forms; pip3 install -r requirements.txt`
4. `git config core.hooksPath hooks`

From now on, when running `git commit`, the hook will check whether staged `*.gml` files are formatted using js-beautify. If they're not, it won't allow you to commit the files. Use `./format-gml.py` to fix formatting of all staged files. You can also run it with argument `--all` to fix formatting of all `*.gml` files present in the repo or `--file FILE` to fix format of given file.

Since js-beautify is a JavaScript formatter, it doesn't work properly with GML in all cases, breaking the code and making it not compile. So far we've encountered this problem only when using `#macro`s. This can be worked around by surrounding them with `/* beautify ignore:start */` and `/* beautify ignore:end */` like so:

```gml
/* beautify ignore:start */
#macro FORMS_FANCY_MACRO \
    do
    { \
        some_stuff_here(); \
    } \
    until (0)
/* beautify ignore:end */
```
