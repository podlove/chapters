# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2019-07-08
### Added
- `Chapters.Chapter.sanitize/1` to trim and nil url strings in `href` and `image`

### Changed
- Use `sanitize` in export to not produce values with empty strings or whitespace padding.

## [1.0.0] - 2019-06-26
### Added
- Import and export of image fields from `psc` and `json`
- This CHANGELOG file to hopefully serve as an evolving example of a
  standardized open source project CHANGELOG.
  
### Changed 
- `Chapters.Chapter` type field changes to be more in line with the formats. 
  `time`→`start` and `url`→`href`
- More consise and ordered output. `href` and `img` entries are omitted if empty, 
  all formats produce a consistent order of `start`, `title`, `href`, `image`

## [0.1.0] - 2019-04-02
### Added
- Core functionality, parse and export of `psc`, `json` and `mp4chaps` chapter formats


[1.0.1]: https://github.com/podlove/chapters/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/podlove/chapters/compare/v0.1.0...v1.0.0
[0.1.0]: https://github.com/podlove/chapters/releases/tag/v0.1.0
