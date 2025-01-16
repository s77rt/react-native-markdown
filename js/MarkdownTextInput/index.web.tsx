import React, { useMemo } from "react";
import { TextInput } from "react-native";
import type { MarkdownTextInputProps } from "../types";
import { processStyles } from "../utils";

function MarkdownTextInput({
	markdownStyles: _markdownStyles,
	style: _style,
	...rest
}: MarkdownTextInputProps) {
	const markdownStyles = useMemo(() => {
		const styles = JSON.parse(JSON.stringify(_markdownStyles));
		processStyles(styles);
		return styles;
	}, [_markdownStyles]);

	const style = useMemo(
		() => ({
			..._style,
			// This style is used to identify our TextInput in the React.createElement stage
			"--MarkdownTextInput": true,
		}),
		[_style]
	);

	return <TextInput style={style} {...rest} />;
}

export default MarkdownTextInput;
