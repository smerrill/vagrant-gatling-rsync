## 0.0.4 (August 24, 2014)

This release adds notification of time and duration of rsyncs.

It also adds the config.gatling.time_format configuration option to allow customization of the time format string when
time information is printed to the console.

It also updates the Gemfile to use Vagrant 1.6.4 so that I can test on Linux using the Docker provider. This should not
have any impact on using the gem with 1.5.1+ versions of Vagrant, however.

FEATURES:

- Add output to note when an rsync finishes and how long it took. [GH-7, GH-10]

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
