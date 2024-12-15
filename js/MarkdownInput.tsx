import React from "react";
import { View, TextInput } from "react-native";
import type { TextInputProps } from "react-native";
import RTNMarkdownInputNativeComponent from "./RTNMarkdownInputNativeComponent";

type MarkdownInputProps = TextInputProps;

function MarkdownInput(props: MarkdownInputProps) {
	return (
		<RTNMarkdownInputNativeComponent>
			<TextInput {...props} />
		</RTNMarkdownInputNativeComponent>
	);
}

export default MarkdownInput;
