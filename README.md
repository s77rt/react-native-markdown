<div align="center">
	<img alt="logo" src="https://raw.githubusercontent.com/s77rt/react-native-markdown/refs/heads/main/assets/logo.png" />
</div>

---

@s77rt/react-native-markdown is a components library that provides drop-in replacements for React Native components with a built-in Markdown formatter.

## Installation

```bash
npm install @s77rt/react-native-markdown
```

## Components

### `<MarkdownTextInput />`

`<MarkdownTextInput />` is a drop-in replacement for `<TextInput />` with a built-in Markdown formatter that takes an additional prop `markdownStyles` allowing you to customize the format of each Markdown fragment. Please refer to [Markdown Styles](#markdown-styles) for the list of supported styles.

#### Usage

```tsx
const markdownStyles = useMemo<MarkdownStyles>(
	() => ({
		h1: {
			fontSize: 24,
			fontWeight: "bold",
		},
		h2: {
			fontSize: 20,
			fontWeight: "bold",
		},
		blockquote: {
			stripeColor: "lightgray",
			stripeWidth: 4,
			gapWidth: 4,
		},
		bold: {
			fontWeight: "bold",
		},
		italic: {
			fontStyle: "italic",
		},
		link: {
			color: "blue",
		},
		/* ... */
	}),
	[]
);
```

```tsx
// Render
<MarkdownTextInput markdownStyles={markdownStyles} multiline />
```

## Markdown Styles

|                        |                                                                                                                           |
| :--------------------: | :-----------------------------------------------------------------------------------------------------------------------: |
| Heading (`h1` -> `h6`) |                     `backgroundColor`, `color`, `fontFamily`, `fontSize`, `fontStyle`, `fontWeight`,                      |
|      `blockquote`      | `backgroundColor`, `color`, `fontFamily`, `fontSize`, `fontStyle`, `fontWeight`, `gapWidth`, `stripeWidth`, `stripeColor` |
|      `codeblock`       |                      `backgroundColor`, `color`, `fontFamily`, `fontSize`, `fontStyle`, `fontWeight`                      |
|    `horizontalRule`    |                      `backgroundColor`, `color`, `fontFamily`, `fontSize`, `fontStyle`, `fontWeight`                      |
|         `bold`         |                      `backgroundColor`, `color`, `fontFamily`, `fontSize`, `fontStyle`, `fontWeight`                      |
|        `italic`        |                      `backgroundColor`, `color`, `fontFamily`, `fontSize`, `fontStyle`, `fontWeight`                      |
|         `link`         |                      `backgroundColor`, `color`, `fontFamily`, `fontSize`, `fontStyle`, `fontWeight`                      |
|        `image`         |                      `backgroundColor`, `color`, `fontFamily`, `fontSize`, `fontStyle`, `fontWeight`                      |
|         `code`         |                      `backgroundColor`, `color`, `fontFamily`, `fontSize`, `fontStyle`, `fontWeight`                      |
|    `strikethrough`     |                      `backgroundColor`, `color`, `fontFamily`, `fontSize`, `fontStyle`, `fontWeight`                      |
|      `underline`       |                      `backgroundColor`, `color`, `fontFamily`, `fontSize`, `fontStyle`, `fontWeight`                      |

Something is missing? [Submit an issue](https://github.com/s77rt/react-native-markdown/issues/new)

## Markdown Parsers

-   Uses [MD4C](https://github.com/mity/md4c/) ([forked](https://github.com/s77rt/md4c))

## Markdown Flavors

CommonMark is used with extended support for:

-   Auto links
-   Strikethrough

## License

[MIT](LICENSE)
