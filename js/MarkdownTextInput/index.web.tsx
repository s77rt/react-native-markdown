import React, {
	useMemo,
	forwardRef,
	useRef,
	useEffect,
	useLayoutEffect,
	useCallback,
} from "react";
import type { ForwardedRef } from "react";
import { TextInput } from "react-native";
import type { MarkdownTextInputProps } from "../types";
import { processStyles } from "../utils";

// s77rt onChangeSelection
// s77rt set selection
// s77rt value="const string" - not worth it yet?
// s77rt format text

function MarkdownTextInput(
	{
		markdownStyles: _markdownStyles,
		style: _style,
		defaultValue,
		value,
		...rest
	}: MarkdownTextInputProps,
	outerRef: ForwardedRef<TextInput>
) {
	const innerRef = useRef<TextInput>();

	// RNW uses `value` and `select` that are missing in the <div /> element.
	useLayoutEffect(() => {
		Object.defineProperty(innerRef.current, "value", {
			get: () => innerRef.current.textContent,
			set: (newValue) => {
				const isFocused = document.activeElement === innerRef.current;
				const selection = window.getSelection();
				if (!isFocused || !selection || !selection.rangeCount) {
					innerRef.current.textContent = newValue;
					return;
				}

				const selectionRange = selection.getRangeAt(0);
				const offset = Math.min(
					selectionRange.startOffset,
					newValue.length
				);

				const newSelectionRange = document.createRange();
				newSelectionRange.selectNodeContents(innerRef.current);
				newSelectionRange.deleteContents();

				var textNode = document.createTextNode(newValue);
				newSelectionRange.insertNode(textNode);
				newSelectionRange.setStart(textNode, offset);
				newSelectionRange.setEnd(textNode, offset);

				selection.removeRange(selectionRange);
				selection.addRange(newSelectionRange);
			},
		});
		Object.defineProperty(innerRef.current, "select", {
			value: () => {
				const isFocused = document.activeElement === innerRef.current;
				const selection = window.getSelection();
				if (!isFocused || !selection) {
					return;
				}

				const newSelectionRange = document.createRange();
				newSelectionRange.selectNodeContents(innerRef.current);

				selection.removeAllRanges();
				selection.addRange(newSelectionRange);
			},
		});
	}, []);

	// Mimic default value
	useEffect(() => {
		if (
			defaultValue != undefined &&
			defaultValue != innerRef.current.value
		) {
			innerRef.current.value = defaultValue;
		}
	}, []);

	// Mimic controlled value
	useEffect(() => {
		if (value != undefined && value != innerRef.current.value) {
			innerRef.current.value = value;
		}
	}, [value]);

	const markdownStyles = useMemo(() => {
		const styles = JSON.parse(JSON.stringify(_markdownStyles));
		processStyles(styles);
		return styles;
	}, [_markdownStyles]);

	const style = useMemo(
		() => ({
			overflow: "auto",
			..._style,
			// This style is used to identify our TextInput in the React.createElement stage
			"--MarkdownTextInput": true,
		}),
		[_style]
	);

	return (
		<TextInput
			ref={(el) => {
				innerRef.current = el;
				if (typeof outerRef === "function") {
					outerRef(el);
				} else if (outerRef) {
					outerRef.current = el;
				}
			}}
			style={style}
			{...rest}
		/>
	);
}

export default forwardRef(MarkdownTextInput);
