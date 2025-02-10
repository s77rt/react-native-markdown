import React, { useMemo, forwardRef } from "react";
import type { ForwardedRef } from "react";
import { TextInput } from "react-native";
import RTNMarkdownNativeComponent from "../RTNMarkdownNativeComponent";
import type { MarkdownTextInputProps } from "../types";
import { processStyles } from "../utils";

function MarkdownTextInput(
	{ markdownStyles: markdownStylesProp, ...rest }: MarkdownTextInputProps,
	ref: ForwardedRef<TextInput>
) {
	const markdownStyles = useMemo(() => {
		const styles = JSON.parse(JSON.stringify(markdownStylesProp));
		processStyles(styles);
		return styles;
	}, [markdownStylesProp]);

	return (
		<RTNMarkdownNativeComponent markdownStyles={markdownStyles}>
			<TextInput ref={ref} {...rest} />
		</RTNMarkdownNativeComponent>
	);
}

export default React.memo(forwardRef(MarkdownTextInput));
