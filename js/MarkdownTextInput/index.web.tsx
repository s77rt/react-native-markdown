import React from "react";
import { TextInput } from "react-native";
import { MarkdownTextInputProps } from "./types";

function MarkdownTextInput({
	_markdownStyles,
	...rest
}: MarkdownTextInputProps) {
	return <TextInput {...rest} />;
}

export default MarkdownTextInput;
