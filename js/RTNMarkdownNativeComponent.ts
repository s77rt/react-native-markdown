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

type BlockquoteStyle = CommonStyle & {
	gapWidth?: Float | undefined;
	stripeWidth?: Float | undefined;
	stripeColor?: ColorValue | undefined;
};

type MarkdownStyles = {
	h1?: CommonStyle | undefined;
	h2?: CommonStyle | undefined;
	h3?: CommonStyle | undefined;
	h4?: CommonStyle | undefined;
	h5?: CommonStyle | undefined;
	h6?: CommonStyle | undefined;
	blockquote?: BlockquoteStyle | undefined;
	codeblock?: CommonStyle | undefined;
	horizontalRule?: CommonStyle | undefined;

	bold?: CommonStyle | undefined;
	italic?: CommonStyle | undefined;
	link?: CommonStyle | undefined;
	image?: CommonStyle | undefined;
	code?: CommonStyle | undefined;
	strikethrough?: CommonStyle | undefined;
	underline?: CommonStyle | undefined;
};

export interface RTNMarkdownNativeProps extends ViewProps {
	markdownStyles: MarkdownStyles;
}

export default codegenNativeComponent<RTNMarkdownNativeProps>(
	"RTNMarkdown"
) as HostComponent<RTNMarkdownNativeProps>;
