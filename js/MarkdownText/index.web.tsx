import React, { forwardRef } from "react";
import type { ForwardedRef } from "react";
import { Text } from "react-native";
import type { MarkdownTextProps } from "../types";

function MarkdownText(
	{
		markdownStyles: markdownStylesProp,
		children,
		...rest
	}: MarkdownTextProps,
	ref: ForwardedRef<Text>
) {
	return (
		<Text ref={ref} {...rest}>
			{children}
		</Text>
	);
}

export default React.memo(forwardRef(MarkdownText));
