import React, { useMemo, forwardRef } from "react";
import type { ForwardedRef } from "react";
import { Text } from "react-native";
import RTNMarkdownNativeComponent from "../RTNMarkdownNativeComponent";
import type { MarkdownTextProps } from "../types";
import { processStyles } from "../utils";

function MarkdownText(
	{
		markdownStyles: markdownStylesProp,
		children,
		...rest
	}: MarkdownTextProps,
	ref: ForwardedRef<Text>
) {
	const markdownStyles = useMemo(() => {
		const styles = JSON.parse(JSON.stringify(markdownStylesProp));
		processStyles(styles);
		return styles;
	}, [markdownStylesProp]);

	return (
		<RTNMarkdownNativeComponent markdownStyles={markdownStyles}>
			<Text ref={ref} {...rest}>
				{children}
			</Text>
		</RTNMarkdownNativeComponent>
	);
}

export default React.memo(forwardRef(MarkdownText));
