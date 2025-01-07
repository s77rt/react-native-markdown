# React Native Markdown Components

```bash
npm install @s77rt/react-native-markdown
```

## `<MarkdownTextInput />`

A drop-in replacement for `<TextInput />` with Markdown support!

### Usage

| Android Demo                                                                                                                                         | iOS Demo                                                                                                                                             |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| <img width="480" alt="Screenshot 2025-01-08 at 12 20 45 AM" src="https://github.com/user-attachments/assets/262c02d0-8de5-4d12-ab2f-0655ac62a6e0" /> | <img width="559" alt="Screenshot 2025-01-08 at 12 20 18 AM" src="https://github.com/user-attachments/assets/8c806055-89e4-45e2-b206-f1cffe8c25f0" /> |

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

// Render
<MarkdownTextInput markdownStyles={markdownStyles} multiline />;
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

Currently only CommonMark is supported with extended support for:

-   Auto links
-   Strikethrough

## License

[MIT](LICENSE)
