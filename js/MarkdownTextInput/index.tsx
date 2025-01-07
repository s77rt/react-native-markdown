import React, { useMemo } from "react";
import { TextInput, processColor } from "react-native";
import RTNMarkdownNativeComponent from "../RTNMarkdownNativeComponent";
import type { MarkdownTextInputProps } from "../types";

const processFontWeight = (fontWeight: any) => {
	if (typeof fontWeight === "number") {
		return fontWeight.toString();
	}
	return fontWeight;
};

const processStyles = (obj: {}) => {
	Object.keys(obj).forEach((key) => {
		if (typeof obj[key] === "object" && obj[key] !== null) {
			processStyles(obj[key]);
			return;
		}
		if (["backgroundColor", "color", "stripeColor"].includes(key)) {
			obj[key] = processColor(obj[key]);
			return;
		}
		if (["fontWeight"].includes(key)) {
			obj[key] = processFontWeight(obj[key]);
			return;
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
