import React, {
	useMemo,
	forwardRef,
	useRef,
	useEffect,
	useState,
	useLayoutEffect,
	useCallback,
} from "react";
import type { ForwardedRef } from "react";
import { TextInput } from "react-native";
import type {
	NativeSyntheticEvent,
	TextInputSelectionChangeEventData,
} from "react-native";
import type { MarkdownTextInputProps } from "../types";
import { processStyles } from "../utils";
import parser from "../../wasm/parser/parser.mjs";

// WebAssembly parser
let format = (text: string) => {
	console.warn("not ready yet, fix this s77rt"); // s77rt
	return "fix me";
};

parser().then((m) => {
	format = (text) => {
		console.log("s77rt format");
		const textPtr = m._malloc((text.length + 1) * 2);
		m.stringToUTF16(text, textPtr);

		const formatedTextPtr = m._PARSEANDFORMAT(textPtr, text.length);
		m._free(textPtr);

		const formatedText = m.UTF16ToString(formatedTextPtr);
		m._free(formatedTextPtr);

		return formatedText;
	};
});

// React.createElement monkey patch
const originalCreateElement = React.createElement;
const modifiedCreateElement = (type, props, ...children) => {
	const isMarkdownTextInput = props?.style?.["--MarkdownTextInput"];
	if (!isMarkdownTextInput) {
		return originalCreateElement(type, props, ...children);
	}

	const modifiedType = "div";
	const modifiedProps = props ?? {};

	// div does not support readOnly prop. Instead contentEditable is used.
	modifiedProps.contentEditable = modifiedProps.readOnly
		? false
		: "plaintext-only";
	modifiedProps.readOnly = undefined;

	// div does not support onChange event handler. Instead onInput is used.
	modifiedProps.onInput = modifiedProps.onChange;
	modifiedProps.onChange = undefined;

	// div does not support value prop. Instead dangerouslySetInnerHTML is used.
	modifiedProps.dangerouslySetInnerHTML = {
		__html: format(modifiedProps.value),
	};
	modifiedProps.value = undefined;

	return originalCreateElement(modifiedType, modifiedProps, ...children);
};
Object.assign(React, { createElement: modifiedCreateElement });

// s77rt onChangeSelection
// s77rt set selection
// s77rt value="const string" - not worth it yet?
// s77rt format text
// s77rt retest controlled input (and cursor jump)
// s77rt replace useLayoutEffect with useEffect?
// s77rt undo functionality
// s77rt inject css styles so we don't build same styles multiple times + account for multiple components with diff styles OR just use a template
// s77rt verify both single line and multi line
// s77rt if we change the text (e.g. truncate text), make sure we still land on the correct cursor position - or I think this is the responsibility of the user
// s77rt check newlines
// s77rt add selectionEnd, selectionStart getters and setSelectionRange
// s77rt if current index is last, new cursor should be srt last directly without loop
// s77rt on paste we should be at the end of the pasted text
// s77rt paste same text twice on same place and verify that we format it
// s77rt format should be called once
// s77rt use state?
// s77rt add cache

function getSelectionDOM(node: Node) {
	const sel = window.getSelection();
	if (!sel) {
		return;
	}

	if (sel.rangeCount === 0) {
		return;
	}

	const range = sel.getRangeAt(0);
	const clonedRange = range.cloneRange();
	clonedRange.selectNodeContents(node);
	clonedRange.setEnd(range.startContainer, range.startOffset);

	const start = clonedRange.toString().length;
	const end = start + range.toString().length;

	return { start, end };
}

function setSelectionDOM(
	node: Node,
	{ start, end }: { start: number; end: number }
) {
	const sel = window.getSelection();
	if (!sel) {
		return;
	}

	if (start === end && end === 0) {
		const range = document.createRange();
		range.selectNodeContents(node);
		range.setEnd(range.startContainer, range.startOffset);
		sel.removeAllRanges();
		sel.addRange(range);
		return;
	}
	if (start === end && end === node.textContent?.length) {
		const range = document.createRange();
		range.selectNodeContents(node);
		range.setStart(range.endContainer, range.endOffset);
		sel.removeAllRanges();
		sel.addRange(range);
		return;
	}

	const range = document.createRange();
	range.setStart(node, 0);
	range.collapse(true);

	let cursor = 0;
	let foundStart = false;
	let foundEnd = false;
	let currentNode: Node | undefined;
	const nodeStack: Node[] = [node];

	while ((currentNode = nodeStack.pop())) {
		if (currentNode.nodeType === Node.TEXT_NODE) {
			const textLength = (currentNode as Text).length;
			cursor += textLength;
			if (!foundStart && cursor >= start) {
				range.setStart(currentNode, start + textLength - cursor);
				foundStart = true;
			}
			if (!foundEnd && cursor >= end) {
				range.setEnd(currentNode, end + textLength - cursor);
				foundEnd = true;
			}
			if (foundEnd) {
				break;
			}
		} else {
			let i = currentNode.childNodes.length;
			while (i--) {
				nodeStack.push(currentNode.childNodes[i]);
			}
		}
	}

	sel.removeAllRanges();
	sel.addRange(range);
}

function selectAllDOM(node: Node) {
	const sel = window.getSelection();
	if (!sel) {
		return;
	}

	sel.selectAllChildren(node);
}

function MarkdownTextInput(
	{
		markdownStyles: markdownStylesProp,
		style: styleProp,
		defaultValue: defaultValueProp,
		value: valueProp,
		selection: selectionProp,
		onChangeText: onChangeTextProp,
		onSelectionChange: onSelectionChangeProp,
		...rest
	}: MarkdownTextInputProps,
	outerRef: ForwardedRef<TextInput>
) {
	const innerRef = useRef<TextInput>();

	const markdownStyles = useMemo(() => {
		const styles = JSON.parse(JSON.stringify(markdownStylesProp));
		processStyles(styles);
		return styles;
	}, [markdownStylesProp]);

	const style = useMemo(
		() => ({
			overflow: "auto",
			...styleProp,
			// This style is used to identify our TextInput in the React.createElement stage
			"--MarkdownTextInput": true,
		}),
		[styleProp]
	);

	const [selection, setSelection] = useState(
		selectionProp ?? { start: 0, end: 0 }
	);
	const onSelectionChange = useCallback(
		(event: NativeSyntheticEvent<TextInputSelectionChangeEventData>) => {
			console.log("selection");
			setSelection(event.nativeEvent.selection);
			onSelectionChangeProp?.(event);
		},
		[onSelectionChangeProp]
	);

	if (selectionProp !== undefined && selectionProp != selection) {
		setSelection(selectionProp);
	}

	const [value, setValue] = useState(defaultValueProp ?? valueProp ?? "");
	const onChangeText = useCallback(
		(text: string) => {
			console.log("change");
			setValue(text);
			onChangeTextProp?.(text);

			console.log(
				"values",
				text.length - selection.end,
				value.length - selection.end,
				selection.start,
				text.length,
				value.length
			);

			const position = selection.end + text.length - value.length;
			setSelection({ start: position, end: position });
		},
		[onChangeTextProp, selection, value]
	);

	if (valueProp !== undefined && valueProp != value) {
		setValue(valueProp);
	}

	useEffect(() => {
		// s77rt debounce
		const handleSelectionChange = (
			event: NativeSyntheticEvent<TextInputSelectionChangeEventData>
		) => {
			const isFocused = document.activeElement === innerRef.current;
			if (!isFocused) {
				return;
			}

			// getSelectionDOM is guaranteed to return a selection because the node is focused
			const { start, end } = getSelectionDOM(innerRef.current) as {
				start: number;
				end: number;
			};

			const isSelectionStale =
				start != selection.start || end != selection.end;
			if (!isSelectionStale) {
				return;
			}

			event.nativeEvent = {
				target: innerRef.current,
				selection: { start, end },
			};

			onSelectionChange(event);
		};

		document.addEventListener("selectionchange", handleSelectionChange);
		return () =>
			document.removeEventListener(
				"selectionchange",
				handleSelectionChange
			);
	}, [onSelectionChange, selection]);

	// Add missing properties that are used in RNW TextInput implementation
	// https://github.com/necolas/react-native-web/blob/fcbe2d1e9225282671e39f9f639e2cb04c7e1e65/packages/react-native-web/src/exports/TextInput/index.js
	useLayoutEffect(() => {
		Object.defineProperty(innerRef.current, "value", {
			/** Used to get the `text` value that is sent with events e.g. onFocus */
			get: () => innerRef.current.textContent,
			/** Used to clear the input (thus textContent is enough) */
			set: (newValue) => (innerRef.current.textContent = newValue),
		});

		Object.defineProperty(innerRef.current, "setSelectionRange", {
			/** Used to sync the `selection` state with the DOM selection */
			value: (start: number, end: number) =>
				setSelectionDOM(innerRef.current, { start, end }),
		});

		Object.defineProperty(innerRef.current, "select", {
			/** Used to select text on focus i.e. selectTextOnFocus prop */
			value: () => selectAllDOM(innerRef.current),
		});
	}, []);

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
			value={value}
			selection={selection}
			onChangeText={onChangeText}
			{...rest}
		/>
	);
}

export default React.memo(forwardRef(MarkdownTextInput));
