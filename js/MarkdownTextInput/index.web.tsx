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
	TextInputKeyPressEventData,
} from "react-native";
import type { MarkdownTextInputProps } from "../types";
import { processStyles } from "../utils";
import parser from "../../wasm/parser/parser.mjs";

// s77rt
document.head.insertAdjacentHTML(
	"beforeend",
	`<style>md-div{display:inline}</style>`
);

// WebAssembly parser
let format = (text: string) => {
	console.warn("not ready yet, fix this s77rt"); // s77rt
	return "fix me";
};

parser().then((m) => {
	format = (text) => {
		if (text.length === 0) {
			return "";
		}

		const textPtr = m._malloc((text.length + 1) * 2);
		m.stringToUTF16(text, textPtr);

		const formatedTextPtr = m._PARSEANDFORMAT(textPtr, text.length);
		m._free(textPtr);

		const formatedText = m.UTF16ToString(formatedTextPtr);
		m._free(formatedTextPtr);
		console.log("s77rt format");

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
// s77rt paste add extra \n if last char is \n
// s77rt format should be called once
// s77rt use state?
// s77rt add cache
// s77rt remove console logs
// s77rt cache selection dom
// s77rt fix bug: write "text\na" remove the "a", you should be in the second line
// s77rt test on safari
// s77rt fix bug: type '\na\nb' and set selection to 0,2 and 1,4
// s77rt in safari sometimes we can't add line breaks after ctrl+a and delete
// s77rt selection default value to value.length
// s77rt usecallback on ref
// s77rt default value

function getSelectionDOM(node: HTMLElement) {
	const sel = window.getSelection();
	if (!sel) {
		return;
	}

	if (sel.rangeCount === 0) {
		return;
	}

	const range = sel.getRangeAt(0);

	let cursor = 0;
	let start = 0;
	let end = 0;
	let startNode: Node | undefined;
	let endNode: Node | undefined;
	let currentNode: Node | undefined;
	const nodeStack: Node[] = [node];

	while ((currentNode = nodeStack.pop())) {
		if (currentNode.nodeType === Node.TEXT_NODE) {
			const textLength = (currentNode as Text).length;
			cursor += textLength;
			if (currentNode === range.startContainer) {
				start = cursor - textLength + range.startOffset;
			}
			if (currentNode === range.endContainer) {
				end = cursor - textLength + range.endOffset;
				break;
			}
		} else {
			if (currentNode.nodeName === "BR") {
				cursor++;
			} else {
				if (currentNode === range.startContainer) {
					startNode = currentNode.childNodes[range.startOffset - 1];
				}
				if (currentNode === range.endContainer) {
					endNode = currentNode.childNodes[range.endOffset - 1];
				}
			}

			if (currentNode === startNode) {
				start = cursor + (currentNode as HTMLElement).innerText.length;
			}
			if (currentNode === endNode) {
				end = cursor + (currentNode as HTMLElement).innerText.length;
				break;
			}

			let i = currentNode.childNodes.length;
			while (i--) {
				nodeStack.push(currentNode.childNodes[i]);
			}
		}
	}

	return { start, end };
}

function setSelectionDOM(
	node: HTMLElement,
	{ start, end }: { start: number; end: number }
) {
	const sel = window.getSelection();
	if (!sel) {
		return;
	}

	if (start === end && (end === 0 || end === node.innerText.length)) {
		const range = document.createRange();
		range.selectNodeContents(node);
		range.collapse(end === 0);
		sel.removeAllRanges();
		sel.addRange(range);
		return;
	}

	const range = document.createRange();

	let cursor = 0;
	let startContainer: Node | undefined;
	let startOffset = 0;
	let endContainer: Node | undefined;
	let endOffset = 0;
	let currentNode: Node | undefined;
	const nodeStack: Node[] = [node];

	while ((currentNode = nodeStack.pop())) {
		if (currentNode.parentNode === startContainer) {
			startOffset++;
		}
		if (currentNode.parentNode === endContainer) {
			endOffset++;
		}

		if (currentNode.nodeType === Node.TEXT_NODE) {
			const textLength = (currentNode as Text).length;
			const startOffset = start - cursor;
			const endOffset = end - cursor;
			cursor += textLength;

			if (startOffset > -1 && cursor >= start) {
				range.setStart(currentNode, startOffset);
			}
			if (endOffset > -1 && cursor >= end) {
				range.setEnd(currentNode, endOffset);
				break;
			}
		} else {
			if (currentNode.nodeName === "BR") {
				cursor++;
			} else {
				const textLength = (currentNode as HTMLElement).innerText
					.length;

				if (cursor + textLength >= start) {
					startContainer = currentNode;
					startOffset = 0;
				}
				if (cursor + textLength >= end) {
					endContainer = currentNode;
					endOffset = 0;
				}
			}

			// Don't break so that we keeping selecting the smallest containers
			// and also to give the text nodes the chance of being the containers
			if (cursor === start) {
				range.setStart(startContainer as Node, startOffset);
			}
			if (cursor === end) {
				range.setEnd(endContainer as Node, endOffset);
			}

			let i = currentNode.childNodes.length;
			while (i--) {
				nodeStack.push(currentNode.childNodes[i]);
			}
		}

		// It's safe to break now as we are past the end position
		if (cursor > end) {
			break;
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
		multiline,
		...rest
	}: MarkdownTextInputProps,
	outerRef: ForwardedRef<TextInput>
) {
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

	const innerRef = useRef<TextInput>();

	const ref = useCallback((el: HTMLElement) => {
		innerRef.current = el;
		if (typeof outerRef === "function") {
			outerRef(el);
		} else if (outerRef) {
			outerRef.current = el;
		}
	}, []);

	const isDeleteContentForward = useRef(false);

	/** Value data */
	const [value, setValueInternal] = useState(
		defaultValueProp ?? valueProp ?? ""
	);
	const valueStore = useRef(value);
	const isValueStale = useRef(false);

	/** Selection data */
	const [selection, setSelectionInternal] = useState(
		selectionProp ?? { start: value.length, end: value.length }
	);
	const selectionStore = useRef(selection);

	/** Selection setter */
	const setSelection = useCallback(
		(newSelection: { start: number; end: number }) => {
			setSelectionInternal(newSelection);
			selectionStore.current = newSelection;
		},
		[]
	);

	/** Sync cursor position */
	const syncCursorPosition = useCallback(
		(oldText: string, newText: string) => {
			const oldTextIgnoredOffset = oldText.at(-1) === "\n" ? 1 : 0;
			const newTextIgnoredOffset = newText.at(-1) === "\n" ? 1 : 0;

			const position = isDeleteContentForward.current
				? selectionStore.current.start
				: selectionStore.current.end -
				  (oldText.length - oldTextIgnoredOffset) +
				  (newText.length - newTextIgnoredOffset);

			setSelection({ start: position, end: position });
		},
		[setSelection]
	);

	/** Value setter */
	const setValue = useCallback(
		(newValue: string) => {
			setValueInternal(newValue);
			syncCursorPosition(valueStore.current, newValue);
			valueStore.current = newValue;
			isValueStale.current = true;
		},
		[syncCursorPosition]
	);

	/** Events */
	const onSelectionChange = useCallback(
		(event: NativeSyntheticEvent<TextInputSelectionChangeEventData>) => {
			console.log("selection");
			setSelection(event.nativeEvent.selection);
			onSelectionChangeProp?.(event);
		},
		[setSelection, onSelectionChangeProp]
	);
	const onChangeText = useCallback(
		(text: string) => {
			console.log("change");
			const newValue = multiline ? text : text.replaceAll("\n", "");
			setValue(newValue);
			onChangeTextProp?.(newValue);
		},
		[setValue, onChangeTextProp, multiline]
	);

	/** Sync props to state */
	if (selectionProp !== undefined && selectionProp != selection) {
		setSelection(selectionProp);
	}
	if (valueProp !== undefined && valueProp != value) {
		setValue(valueProp);
	}

	/** Sync state to DOM */
	if (innerRef.current && isValueStale.current) {
		innerRef.current.innerHTML = format(value);
		isValueStale.current = false;
	}

	// Add missing properties that are used in RNW TextInput implementation
	// https://github.com/necolas/react-native-web/blob/fcbe2d1e9225282671e39f9f639e2cb04c7e1e65/packages/react-native-web/src/exports/TextInput/index.js
	useLayoutEffect(() => {
		Object.defineProperty(innerRef.current, "value", {
			/** Used to get the `text` value that is sent with events e.g. onFocus */
			get: () => innerRef.current.innerText,
			/** Used to clear the input (thus innerText is enough) */
			set: (newValue) => (innerRef.current.innerText = newValue),
		});

		Object.defineProperty(innerRef.current, "selectionStart", {
			/** Used to check if the selection is stale (DOM vs state).
			 *
			 * If the selection is 0 return undefined instead to force setting the selection because on Safari after Ctrl+A and Delete,
			 * the selection becomes broken and can't enter new lines.
			 */
			get: () => {
				const selectionDOM = getSelectionDOM(innerRef.current);
				if (selectionDOM?.start === 0 && selectionDOM?.end === 0) {
					return undefined;
				}
				return selectionDOM?.start;
			},
		});
		Object.defineProperty(innerRef.current, "selectionEnd", {
			/** Used to check if the selection is stale (DOM vs state).
			 *
			 * If the selection is 0 return undefined instead to force setting the selection because on Safari after Ctrl+A and Delete,
			 * the selection becomes broken and can't enter new lines.
			 */
			get: () => {
				const selectionDOM = getSelectionDOM(innerRef.current);
				if (selectionDOM?.start === 0 && selectionDOM?.end === 0) {
					return undefined;
				}
				return selectionDOM?.end;
			},
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

	useEffect(() => {
		const handleSelectionChange = (
			event: NativeSyntheticEvent<TextInputSelectionChangeEventData>
		) => {
			const isFocused = document.activeElement === innerRef.current;
			if (!isFocused) {
				return;
			}

			const selectionDOM = getSelectionDOM(innerRef.current);
			if (!selectionDOM) {
				return;
			}

			const isSelectionStale =
				selectionDOM.start != selectionStore.current.start ||
				selectionDOM.end != selectionStore.current.end;
			if (!isSelectionStale) {
				return;
			}

			event.nativeEvent = {
				target: innerRef.current,
				selection: selectionDOM,
			};

			onSelectionChange(event);
		};

		document.addEventListener("selectionchange", handleSelectionChange);
		return () =>
			document.removeEventListener(
				"selectionchange",
				handleSelectionChange
			);
	}, [onSelectionChange]);

	useEffect(() => {
		const handleBeforeInput = (event: NativeSyntheticEvent<any>) => {
			isDeleteContentForward.current =
				event.inputType === "deleteContentForward";
		};

		innerRef.current.addEventListener("beforeinput", handleBeforeInput);
		return () =>
			innerRef.current.removeEventListener(
				"beforeinput",
				handleBeforeInput
			);
	}, []);

	useEffect(() => {
		innerRef.current.innerHTML = format(value);
	}, []);

	return (
		<TextInput
			ref={ref}
			style={style}
			selection={selection}
			onChangeText={onChangeText}
			multiline={multiline}
			{...rest}
		/>
	);
}

export default React.memo(forwardRef(MarkdownTextInput));
