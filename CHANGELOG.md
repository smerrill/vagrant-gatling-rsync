## 0.0.3 (May 02, 2014)

Bugfix release.

BUG FIXES:

- Fix the plugin under multi-box environments. Thanks to @mattchannelgrabber. [GH-5]

## 0.0.2 (April 27, 2014)

Bugfix release.

BUG FIXES:

- Catch ThreadErrors (this sometimes happens in practice on OS X.)
- Reflect that this plugin requires Vagrant 1.5.1+.

## 0.0.1 (March 23, 2014)

Initial release.

FEATURES:

- Implement an rb-fsevent adapter for Mac.
- Implement an rb-inotify adapter for Linux.
- Add the `vagrant gatling-rsync-auto` command.
- Implement the first draft of a config option to allow changing the latency.

## Backlog

- Test and release the Windows adapter.
- Allow configuring and running the rsync daemon to avoid SSH overhead.
- Get latency validation working.
