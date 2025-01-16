import React, { useMemo } from "react";
import { TextInput } from "react-native";
import RTNMarkdownNativeComponent from "../RTNMarkdownNativeComponent";
import type { MarkdownTextInputProps } from "../types";
import { processStyles } from "../utils";

function MarkdownTextInput({
	markdownStyles: _markdownStyles,
	...rest
}: MarkdownTextInputProps) {
	const markdownStyles = useMemo(() => {
		const styles = JSON.parse(JSON.stringify(_markdownStyles));
		processStyles(styles);
		return styles;
	}, [_markdownStyles]);

	return (
		<RTNMarkdownNativeComponent markdownStyles={markdownStyles}>
			<TextInput {...rest} />
		</RTNMarkdownNativeComponent>
	);
}

export default MarkdownTextInput;
