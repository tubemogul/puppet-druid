# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- addec the management of the license for druid-pivot
- systemd unit files

### Changed
- Puppet archive version 1.3.0 is the last one compatible with puppet 3.x and
  the last one compatible with this module for now. Changing the `.fixtures.yml`
  to reflect that.
- Same for puppetlabs-apt dependency
- Fix puppet-lint warnings
- Manifests to deploy unit files


## [1.0.1] - 2017-01-31
### Fixed
- The path to the archive module in the `metadata.json` was incorrect
- The path in the `.fixtures.yml` was referencing an old path currently
  deprecated

## [1.0.0] - 2017-01-30
### Added
- Add `extensions_dir` to be compatible with Imply 1.2.x

### Changed
- Move the changelog to markdown and start using semver
- Change classes `druid::bart*` classes to `druid::pivot*`
- Default imply version changed from 1.1.0 to 1.2.1
- Change name of pivot config file from `pivot_config.yaml` to `config.yaml`
- Update the `metadata.json` to meet the correct requirements and supported OS

### Dropped
- Removed the `CONTRIBUTORS` file. You can get the contributors via the GitHub API
- Removed the `Gemfile.lock` file as version-dependent

### Fixed
- Fix middleManager node
- Fix variable contains an uppercase letter puppet-lint warnings which means
  renaming parameter `druid::pivot::source_list_refresh_onLoad` to
  `druid::pivot::source_list_refresh_onload`
- Fixed typos in the `metadata.json`
- Fixed some failing rspec tests with the latest puppet versions
- Fixed some puppet warnings mainly class included by relative name
- Code quality cleanup using rubocop
- Documentation updates

## [0.1.1] - 2016-03-07
### Changed
- Better service notifications
- Default imply version changed from 1.0.0 to 1.1.0

## [0.1.0] - 2016-02-15
### Added
- Initial Github commit
