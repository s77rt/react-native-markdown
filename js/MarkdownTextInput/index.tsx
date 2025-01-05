import React, { useMemo } from "react";
import { TextInput, processColor } from "react-native";
import RTNMarkdownNativeComponent from "../RTNMarkdownNativeComponent";
import { MarkdownTextInputProps } from "./types";

const processStyles = (obj: {}) => {
	Object.keys(obj).forEach((key) => {
		if (typeof obj[key] === "object" && obj[key] !== null) {
			processStyles(obj[key]);
			return;
		}
		if (["backgroundColor", "color"].includes(key)) {
			obj[key] = processColor(obj[key]);
		}
	});
};

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
