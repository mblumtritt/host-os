# HostOS

![version](https://img.shields.io/gem/v/host-os?label=)

HostOS is a module that offers details about the host operating system, the current Ruby interpreter, and the environment currently in use.

- Gem: [rubygems.org](https://rubygems.org/gems/host-os)
- Source: [github.com](https://github.com/mblumtritt/host-os)
- Help: [rubydoc.info](https://rubydoc.info/gems/host-os/HostOS)

## Description

This gem helps you write environment-specific code in a clean way.
It provides a simple API to get information about the operating system, the current Ruby interpreter, and the configured environment.

## Usage

Here is a very simple example of OS dependent code:

```ruby
require 'host-os'

if HostOS.unix?
  puts 'Hello Unix world!'
elsif HostOS.windows?
  puts 'Clean your Windows!'
elsif HostOS.os2? || HostOS.vms?
  puts 'Hello old school!'
end
```

You are free to write your code in whatever way you prefer. Here is a functionally identical but alternative to the example above:

```ruby
require 'host-os'

if HostOS.is? :unix
  puts 'Hello Unix world!'
elsif HostOS.is? 'windows'
  puts 'Clean your Windows!'
elsif %i[os2 vms].include?(HostOS.type)
  puts 'Hello old school!'
end
```

The module also assists with environment- or interpreter-specific code:

```ruby
require 'host-os'

Logger.log_level = HostOS.env.production? ? Logger::WARN : Logger::INFO
# => set the log level to 'WARN' in production, 'INFO' otherwise

require 'java' if HostOS.interpreter.jruby?
# => load the Java support for JRuby
```

There are additional methods that can support you on various platforms:

```ruby
require 'host-os/support'

HostOS.dev_null
# => returns 'NUL' on Windows, 'nul' for OS2 and '/dev/null' on Unix platforms

HostOS.app_config_path('my_app')
# => returns the directory name where 'my_app' stores its configuration files

HostOS.rss_bytes
# => memory consumtion of current process in bytes
# means "total in memory footprint"
```

📕 See [the online help](https://rubydoc.info/gems/host-os/HostOS) for more details.

## Installation

This gem is compatible with Ruby 2.3 and higher. You can install it in your system with

```shell
gem install host-os
```

or you can use [Bundler](http://gembundler.com/) to add HostOS just to your own project:

```shell
bundle add 'host-os'
```

After that you only need one line of code to have everything together

```ruby
require 'host-os'
```
