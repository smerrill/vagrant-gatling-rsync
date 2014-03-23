# vagrant-gatling-rsync

An rsync watcher for Vagrant 1.5+ that uses fewer host resources at the
potential cost of more rsync actions.

The built-in rsync-auto plugin sometimes uses a lot of CPU and disk I/O when
it starts up on very large rsynced directories. This plugin is designed to
work well with such large rsynced folders.

## Authors

Steven Merrill

Doug Marcey
