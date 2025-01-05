import type { ViewProps } from "ViewPropTypes";
import type { HostComponent, ColorValue } from "react-native";
import codegenNativeComponent from "react-native/Libraries/Utilities/codegenNativeComponent";
import { Float } from "react-native/Libraries/Types/CodegenTypes";

type CommonStyle = {
	backgroundColor?: ColorValue | undefined;
	color?: ColorValue | undefined;
	fontFamily?: string | undefined;
	fontSize?: Float | undefined;
	fontStyle?: string | undefined;
	fontWeight?: string | undefined;
};

export interface RTNMarkdownNativeProps extends ViewProps {
	markdownStyles: {
		headingBlock?: CommonStyle | undefined;
		heading?: CommonStyle | undefined;

		blockquoteBlock?:
			| (CommonStyle & {
					gapWidth?: Float | undefined;
					stripeWidth?: Float | undefined;
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
}

export default codegenNativeComponent<RTNMarkdownNativeProps>(
	"RTNMarkdown"
) as HostComponent<RTNMarkdownNativeProps>;
