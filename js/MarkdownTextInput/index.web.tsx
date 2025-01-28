import React, {
	useMemo,
	forwardRef,
	useRef,
	useEffect,
	useLayoutEffect,
} from "react";
import type { ForwardedRef } from "react";
import { TextInput } from "react-native";
import type { MarkdownTextInputProps } from "../types";
import { processStyles } from "../utils";

// s77rt onChangeSelection
// s77rt set selection
// s77rt value="const string" - not worth it yet?
// s77rt format text
// s77rt retest controlled input (and cursor jump)
// s77rt replace useLayoutEffect with useEffect?
// s77rt undo functionality
// s77rt inject css styles so we don't build same styles multiple times + account for multiple components with diff styles OR just use a template
// s77rt verify both single line and multi line

function format(text: string): string {
	if (!window["739b9b2c-40c9-4772-9bf5-3ff5930ed2c4"].format) {
		console.warn("not ready yet, fix this s77rt"); // s77rt
		return text;
	}

	return window["739b9b2c-40c9-4772-9bf5-3ff5930ed2c4"].format(text);
}

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
					innerRef.current.innerHTML = format(newValue);
					return;
				}

				innerRef.current.innerHTML = format(newValue);
				return;

				const selectionRange = selection.getRangeAt(0);
				const offset = Math.min(
					selectionRange.startOffset,
					newValue.length
				);

				const newSelectionRange = document.createRange();
				newSelectionRange.selectNodeContents(innerRef.current);
				newSelectionRange.deleteContents();

				const textNode = document.createTextNode("hi");
				newSelectionRange.insertNode(textNode);
				const textNode2 = document.createTextNode("there");
				newSelectionRange.insertNode(textNode2);
				const node3 = document.createElement("b");
				node3.textContent = "kaa";
				newSelectionRange.insertNode(node3);

				/*const textNode = document.createTextNode(newValue);
				newSelectionRange.insertNode(textNode);
				newSelectionRange.setStart(textNode, offset);
				newSelectionRange.setEnd(textNode, offset);*/

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
		if (defaultValue != undefined) {
			innerRef.current.value = defaultValue;
		}
	}, []);

	// Mimic controlled value
	useEffect(() => {
		if (value != undefined) {
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
