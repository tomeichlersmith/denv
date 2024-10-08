# How to Contribute

**All contributing is helpful!**
Anything from correcting a spelling mistake in the documentation,
adding a new example, patching bugs, or adding features
is highly encouraged. 
Below, I've collected some notes on these
various levels of contribution.

## Documentation Updates
If you are writing more detailed explanation or adding in a new
example, please `git clone` the repository and make sure the updated
documentation can be built into a website by 
[mdbook](https://rust-lang.github.io/mdBook/guide/installation.html) 
and has the format you expect. 

This website actually has a helpful edit button in the top-right
corner that will take you to the file on GitHub to edit and submit a pull
request with any updates you wish to suggest. This is especially helpful
for smaller updates that don't affect the format of the website pages.

### New Examples
As far as I'm concerned, the more the merrier! If you are writing an example,
please be detailed about which runner you are using, the version of `denv`,
and how you've configured `denv` to aid in your workflow.

## Patching Bugs or Adding Features
If you find a bug or think of a new feature to add, please open a
[GitHub Issue](https://github.com/tomeichlersmith/denv/issues/new)
to start the discussion. This allows all collaborators to see what you plan
to work on as well as potentially offer some insight on how to get going.

## Code Contributions
When you work on developing `denv` make sure to install 
[shellcheck](https://github.com/koalaman/shellcheck)
add run the check and test scripts.
```
./ci/check # uses shellcheck to avoid common issues writing shell scripts
./ci/test <your-runner> # basic functionality checking
```
The GitHub workflows test all of the currently supported runners,
so make sure to enable them in your fork of the repository so that
they will test runners that you may not have installed on your system!

If the code being developed is anything larger than an extremely small one-line change,
please open an issue and reference the issue number in your branch name. Generally,
I like the format `<issue_number>-short-title` for example `19-connect-net` was used
when developing network-connection supported related to issue 19.

## Version Control
When changing the `denv` version number, one must change it in three locations.
- `denv` itself at the top
- `install` so future pullers will get the latest version
- `man/man1/denv.1` so the man page has the new version number

This is annoying to always have to remember to do, so there is a short shell
script to do this for you.
```
./ci/set-version X.Y.Z
```

## Writing tests
`denv` uses [bats](ttps://bats-core.readthedocs.io/en/stable/) to run tests
and pins its version (as well as the necessary plugins) using submodules.
Look to these resources for the `assert_*` family of functions and how
tests are structured and run.
- [bats-core](https://bats-core.readthedocs.io/en/stable/)
- [bats-assert](https://github.com/bats-core/bats-assert#usage)
- [bats-file](https://github.com/bats-core/bats-file#index-of-all-functions)
