crowbar
=======

Crowbar is theoretically a scheduler for OSX.

In actual fact, it may or may not eventuate.

Usage
-----

When crowbar loads it'll read the contents of `.crowtab`; which will be formatted like:

```
(1234) echo foo
(9001) cd code; for i in *; do (cd $i; git fetch); done
```

which will echo foo every `1234` seconds, and fetch all your git repos every `9001` seconds.

Output will show up in the notification center.
