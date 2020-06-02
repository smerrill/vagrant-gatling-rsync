## 1.0 (June 02, 2020)

This release adds compatibility with Vagrant 2.2.5+.

Small parts of the example Vagrantfile and the Gemfile and Gemspec have also been cleaned up.

FEATURES:

- Add compatibility with Vagrant 2.2.5+. Thanks to @leejo for the PR. [GH-37]

## 0.9.0 (June 28, 2015)

This release adds two big features: Windows support and automatic sync on startup.

It also adds the `config.gatling.rsync_on_startup` configuration option to turn automatic rsync on startup off if you
do not want it.

It also updates the Gemfile to use Vagrant 1.7.2 for development. The gem should still work with Vagrant 1.5.1+.

FEATURES:

- Add support for Windows. Thanks to @mfradcourt for wiring it up. [GH-21]
- Add automatic sync startup on `vagrant up` or `vagrant reload` if rsync folders are present. [GH-14]

## 0.1.0 (January 04, 2015)

This release adds feature parity with Vagrant core rsync-auto by doing a sync when gatling-rsync is started.

FEATURES:

- Perform an initial rsync when the watcher starts. [GH-13]

## 0.0.4 (August 24, 2014)

This release adds notification of time and duration of rsyncs.

It also adds the `config.gatling.time_format` configuration option to allow customization of the time format string when
time information is printed to the console.

It also updates the Gemfile to use Vagrant 1.6.4 so that I can test on Linux using the Docker provider. This should not
have any impact on using the gem with 1.5.1+ versions of Vagrant, however.

FEATURES:

- Add output to note when an rsync finishes and how long it took. [GH-7, GH-10]

BUG FIXES:

- The plugin now correctly outputs an error instead of failing to load on Vagrant versions < 1.5.1. [GH-11]

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
