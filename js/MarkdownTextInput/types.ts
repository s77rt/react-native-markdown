import type { TextInputProps, ColorValue } from "react-native";

type CommonStyle = {
	backgroundColor?: ColorValue | undefined;
	color?: ColorValue | undefined;
	fontFamily?: string | undefined;
	fontSize?: number | undefined;
	fontStyle?: "normal" | "italic" | undefined;
	fontWeight?:
		| "normal"
		| "bold"
		| "100"
		| "200"
		| "300"
		| "400"
		| "500"
		| "600"
		| "700"
		| "800"
		| "900"
		| 100
		| 200
		| 300
		| 400
		| 500
		| 600
		| 700
		| 800
		| 900
		| "ultralight"
		| "thin"
		| "light"
		| "medium"
		| "regular"
		| "semibold"
		| "condensedBold"
		| "condensed"
		| "heavy"
		| "black"
		| undefined;
};

type RTNMarkdownProps = {
	markdownStyles: {
		headingBlock?: CommonStyle | undefined;
		heading?: CommonStyle | undefined;

		blockquoteBlock?:
			| (CommonStyle & {
					gapWidth?: number | undefined;
					stripeWidth?: number | undefined;
					stripeColor?: ColorValue | undefined;
			  })
			| undefined;
		blockquote?: CommonStyle | undefined;

		codeBlock?: CommonStyle | undefined;
		code?: CommonStyle | undefined;

		bold?: CommonStyle | undefined;
		italic?: CommonStyle | undefined;
		link?: CommonStyle | undefined;
		image?: CommonStyle | undefined;
		inlineCode?: CommonStyle | undefined;
		strikethrough?: CommonStyle | undefined;
		underline?: CommonStyle | undefined;
	};
};

export type MarkdownTextInputProps = TextInputProps & RTNMarkdownProps;
