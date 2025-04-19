# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2025-04-19

### Fixed

-   Dynamically changing `markdownStyles` does not reformat text ([#9](https://github.com/s77rt/react-native-markdown/issues/9)).
-   Codegen warnings (missing `ios.componentProvider`) ([#29](https://github.com/s77rt/react-native-markdown/issues/29)).

## [0.4.0] - 2025-03-16

### Changed

-   Web: Load WASM module asynchronously ([#23](https://github.com/s77rt/react-native-markdown/issues/23)).
-   Web: Skip syncing cursor position when possible ([#26](https://github.com/s77rt/react-native-markdown/issues/26)).

## [0.3.2] - 2025-03-04

### Fixed

-   Web (Safari) Can't type à ([#22](https://github.com/s77rt/react-native-markdown/issues/22)).
-   Web: onChange and onChangeText report different text ([#25](https://github.com/s77rt/react-native-markdown/issues/25)).

## [0.3.1] - 2025-02-28

### Fixed

-   Web: buggy selection on Firefox ([#24](https://github.com/s77rt/react-native-markdown/issues/24)).
-   Web: Safari crashes on pasting attached text ([#21](https://github.com/s77rt/react-native-markdown/issues/21)).
-   Web: MD-DIV has weird inline style ([#20](https://github.com/s77rt/react-native-markdown/issues/20)).

## [0.3.0] - 2025-02-23

### Changed

-   Web: Use DOM differ (instead of direct innerHTML replacement) ([#19](https://github.com/s77rt/react-native-markdown/pull/19)).

### Fixed

-   Web: Missing undo functionality ([#15](https://github.com/s77rt/react-native-markdown/issues/15)).

## [0.2.4] - 2025-02-17

### Fixed

-   iOS: Blockquote stripe vs cursor ([#11](https://github.com/s77rt/react-native-markdown/issues/11)).

## [0.2.3] - 2025-02-15

### Fixed

-   Web: H2 not applied correctly in an edge case ([#18](https://github.com/s77rt/react-native-markdown/issues/18)).

## [0.2.2] - 2025-02-15

### Fixed

-   Bold and Italic not working together ([#13](https://github.com/s77rt/react-native-markdown/issues/13)).
-   UTF16 decode

## [0.2.1] - 2025-02-10

### Fixed

-   Web: Can't select from end to start ([#17](https://github.com/s77rt/react-native-markdown/issues/17)).

## [0.2.0] - 2025-02-10

### Added

-   Web support ([#4](https://github.com/s77rt/react-native-markdown/issues/4)).

## [0.1.1] - 2025-01-13

### Fixed

-   iOS: Only the active paragraph is being formatted ([#10](https://github.com/s77rt/react-native-markdown/issues/10)).

## [0.1.0] - 2025-01-08

### Added

-   Initial release.

[1.0.0]: https://github.com/s77rt/react-native-markdown/compare/v0.4.0...v1.0.0
[0.4.0]: https://github.com/s77rt/react-native-markdown/compare/v0.3.2...v0.4.0
[0.3.2]: https://github.com/s77rt/react-native-markdown/compare/v0.3.1...v0.3.2
[0.3.1]: https://github.com/s77rt/react-native-markdown/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/s77rt/react-native-markdown/compare/v0.2.4...v0.3.0
[0.2.4]: https://github.com/s77rt/react-native-markdown/compare/v0.2.3...v0.2.4
[0.2.3]: https://github.com/s77rt/react-native-markdown/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/s77rt/react-native-markdown/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/s77rt/react-native-markdown/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/s77rt/react-native-markdown/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/s77rt/react-native-markdown/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/s77rt/react-native-markdown/releases/tag/v0.1.0
