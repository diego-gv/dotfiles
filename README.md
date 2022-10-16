# [diego-gv][profile]’s dotfiles

These are the base dotfiles that I start with when I set up
a new environment (for more specific local needs I use the
[`*.local`](#local-settings) files).

## Local Settings

The dotfiles can be easily extended to suit additional local
requirements by using the following files:

### `~/.bash.local`

The `~/.bash.local` file will be automatically sourced after all
the other [Bash related files][shell], thus, allowing its content
to add to or overwrite the existing aliases, settings, `PATH`, etc.

Here is an example:

```shell
#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set PATH additions.

PATH="/Users/diego-gv/dotfiles/src/bin/:$PATH"

export PATH

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set local aliases.

alias g="git"
```

### `~/.gitconfig.local`

The `~/.gitconfig.local` file will be automatically included after
the configurations from `~/.gitconfig`, thus, allowing its content
to overwrite or add to the existing Git configurations.

__Note:__ Use `~/.gitconfig.local` to store sensitive information
such as the Git user credentials, e.g.:

```gitconfig
[commit]

    # Sign commits using GPG.
    # https://help.github.com/articles/signing-commits-using-gpg/

    gpgSign = true

[user]

    name = Your Name
    email = account@example.com
    signingKey = XXXXXXXX
```

## Credits

These dotfiles are based on the [Cătălin's dotfiles][alrra-credit]. The installation scripts and OS duality system have been obtained from its repository.

## License

The code is available under the [MIT license][license].

<!-- Link labels: -->
[profile]: https://github.com/diego-gv
[alrra-credit]: https://github.com/alrra/dotfiles/tree/main
[license]: LICENSE
