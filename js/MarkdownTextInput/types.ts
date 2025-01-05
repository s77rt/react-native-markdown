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

type BlockquoteStyle = CommonStyle & {
	gapWidth?: number | undefined;
	stripeWidth?: number | undefined;
	stripeColor?: ColorValue | undefined;
};

type RTNMarkdownProps = {
	markdownStyles: {
		h1?: CommonStyle | undefined;
		h2?: CommonStyle | undefined;
		h3?: CommonStyle | undefined;
		h4?: CommonStyle | undefined;
		h5?: CommonStyle | undefined;
		h6?: CommonStyle | undefined;
		blockquote?: BlockquoteStyle | undefined;
		codeblock?: CommonStyle | undefined;

		bold?: CommonStyle | undefined;
		italic?: CommonStyle | undefined;
		link?: CommonStyle | undefined;
		image?: CommonStyle | undefined;
		code?: CommonStyle | undefined;
		strikethrough?: CommonStyle | undefined;
		underline?: CommonStyle | undefined;
	};
};

export type MarkdownTextInputProps = TextInputProps & RTNMarkdownProps;
