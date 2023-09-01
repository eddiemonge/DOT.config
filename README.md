My config files. These replace my DOT.files

# Install
Run this with the following command
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/eddiemonge/DOT.files/HEAD/install.sh)"
```

## Git Commit Author
To set your git commit author information globally, copy the `~/.config/git/author.sample` file to
`~/.config/git/author` and update the values. This info is not set in the `git/config` file so it
can stay clean in the cloned repo.