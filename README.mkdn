# NAME

App::TeleGramma - A modular Telegram Bot

# SYNOPSIS

Install App::TeleGramma and its dependencies

    $ cpanm App::TeleGramma

The first time run, a basic configuration file is automatically created for you.

    $ telegramma
    Your new config has been created in /Users/username/.telegramma/telegramma.ini

    Please edit it now and update the Telegram Bot token, then
    re-run bin/telegramma.

    The configuration will have an entry for each plugin currently available on
    your system, but disabled.

Edit the config file, adding (at least) the Telegram Bot API key.

Now you can run, first in foreground mode for testing purposes:

    $ telegramma --nodaemon

When it's all good, you'll want to run it as a daemon:

    $ telegramma

You can monitor the status of the running process, and shut it down.

    $ telegramma --status

    $ telegramma --shutdown

# DESCRIPTION

TeleGramma is an easy to use, extensible bot to use with Telegram `www.telegram.org`.

Its plugin architecture makes it easy to add new modules either from other authors,
or yourself.

# BUGS

None known.

# AUTHOR

Justin Hawkins `justin@eatmorecode.com`

# SEE ALSO

[Telegram::Bot](https://metacpan.org/pod/Telegram::Bot) - the lower level API
