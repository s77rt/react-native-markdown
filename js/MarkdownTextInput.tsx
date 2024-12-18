import React from "react";
import { View, TextInput } from "react-native";
import type { TextInputProps } from "react-native";
import RTNMarkdownNativeComponent from "./RTNMarkdownNativeComponent";

type MarkdownTextInputProps = TextInputProps;

function MarkdownTextInput(props: MarkdownTextInputProps) {
	return (
		<RTNMarkdownNativeComponent>
			<TextInput {...props} />
		</RTNMarkdownNativeComponent>
	);
}

export default MarkdownTextInput;
