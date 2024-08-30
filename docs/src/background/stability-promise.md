# Stability Promise

With the release of version 1.0, denv features a strong
commitment to backwards compatibility and stability.

Future releases will not introduce backwards incompatible changes
that make existing denv configurations (mostly represented by the `.denv/config`
file whose specification is [in the manual](../manual/denv-config.md#files))
stop working, or break working invocations of the command-line interface.

This does not, however, preclude fixing outright bugs, even if doing so might
break denv configurations that rely on their behavior.

There will never be a denv 2.0.
Any desirable backwards-incompatible changes will be opt-in on a per-denv basis,
so users may migrate at their leisure.

---
Stability promise text copied heavily from
[just](https://just.systems/man/en/chapter_9.html).
