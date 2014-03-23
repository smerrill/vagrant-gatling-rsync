# vagrant-gatling-rsync

An rsync watcher for Vagrant 1.5+ that uses fewer host resources at the
potential cost of more rsync actions.

## Authors

Steven Merrill (@stevenmerrill) originally had the idea to tap into rb-fsevent
and rb-inotify to more efficiently rsync files.

Doug Marcey (@dougmarcey) provided considerable guidance in the implementation
of the coalescing functionality and wrote the initial sketch of the Linux and
Windows adapters.

## Why "gatling"?

The gatling gun was the first gun capable of firing continuously.

## This plugin

The built-in rsync-auto plugin sometimes uses a lot of CPU and disk I/O when
it starts up on very large rsynced directories. This plugin is designed to
work well with such large rsynced folders.

The rsync-auto command that ships with Vagrant 1.5 uses the listen gem. The
Listen gem is quite thorough - it uses Celluloid to spin up an actor system
and it checks file contents on OS X to ensure that running "touch" on a file
(to do a write but not update its content) will not fire the rsync command.

The downside of using Listen is that it takes a large amount of host resources
to monitor large directory structures. This gem works well with to monitor
directories hierarchies with 10,000-100,000 files.

## Event coalescing

This plugin also coalesces events for you. The default latency is 1.5 seconds.
(This will be a configurable option in future versions.) If you specify a
latency of two seconds, this plugin will not fire a `vagrant rsync` until two
contiguous seconds without file events have passed. This will delay rsyncs from
happening if many writes are happening on the host (during a `make` or a
`git clone`, for example) until the activity has leveled off.
