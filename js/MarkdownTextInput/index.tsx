import React, { useMemo, forwardRef } from "react";
import type { ForwardedRef } from "react";
import { TextInput } from "react-native";
import RTNMarkdownNativeComponent from "../RTNMarkdownNativeComponent";
import type { MarkdownTextInputProps } from "../types";
import { processStyles } from "../utils";

function MarkdownTextInput(
	{ markdownStyles: _markdownStyles, ...rest }: MarkdownTextInputProps,
	ref: ForwardedRef<TextInput>
) {
	const markdownStyles = useMemo(() => {
		const styles = JSON.parse(JSON.stringify(_markdownStyles));
		processStyles(styles);
		return styles;
	}, [_markdownStyles]);

	return (
		<RTNMarkdownNativeComponent markdownStyles={markdownStyles}>
			<TextInput ref={ref} {...rest} />
		</RTNMarkdownNativeComponent>
	);
}

export default forwardRef(MarkdownTextInput);
