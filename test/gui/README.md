# GUI Testing
I haven't found a nice way to non-interactively test that GUI connection
is working. The fastest way I have found is to have a proof-of-concept image
that I can then manually check with the runners occasionally.

The [`image`](image) directory contains this proof-of-concept image build
context. Basically, it just installs the xeyes application which will allow
testers to confirm that the window is shown on screen and the user can
interact with it.

## Run Test
The `run-gui-test` script is used to do the manual test.
It makes sure the proof-of-concept image is built and then
tries to launch `xeyes` using `denv`.
After `xeyes` is closed, `denv` exits and the temporary workspace is removed.

```
./run-gui-test
```
