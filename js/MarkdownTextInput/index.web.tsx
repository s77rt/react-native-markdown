import React, {
	useMemo,
	forwardRef,
	useRef,
	useEffect,
	useState,
	useLayoutEffect,
	useCallback,
	useInsertionEffect,
} from "react";
import type { ForwardedRef } from "react";
import { TextInput } from "react-native";
import type {
	NativeSyntheticEvent,
	TextInputSelectionChangeEventData,
} from "react-native";
import type { MarkdownStyles, MarkdownTextInputProps } from "../types";
import { processStyles } from "../utils";
import parser from "../../wasm/parser/parser.mjs";

/** React.createElement monkey patch */
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

/** WebAssembly parser */
const parserModule = parser();
function format(text: string): string {
	if (text.length === 0) {
		return "<md-div></md-div>";
	}

	const textPtr = parserModule._malloc((text.length + 1) * 2);
	parserModule.stringToUTF16(text, textPtr);

	const formatedTextPtr = parserModule._PARSEANDFORMAT(textPtr, text.length);
	parserModule._free(textPtr);

	const formatedText = parserModule.UTF16ToString(formatedTextPtr);
	parserModule._free(formatedTextPtr);

	return formatedText;
}

/** CSS builder */
const markdownStyleKeyHTMLTag: Record<keyof MarkdownStyles, string> = {
	h1: "md-h1",
	h2: "md-h2",
	h3: "md-h3",
	h4: "md-h4",
	h5: "md-h5",
	h6: "md-h6",
	blockquote: "md-blockquote",
	codeblock: "md-pre",
	horizontalRule: "md-hr",

	bold: "md-b",
	italic: "md-i",
	link: "md-a",
	image: "md-img",
	code: "md-code",
	strikethrough: "md-s",
	underline: "md-u",
};
function buildMarkdownStylesCSS(
	markdownStyles: MarkdownStyles,
	mdID: string
): string {
	const baseSelector = `div[data-md-id="${mdID}"]`;

	const selector = baseSelector + " md-div";
	let css = selector + "{display:inline;}";

	for (const [styleKey, styleValue] of Object.entries(markdownStyles)) {
		const selector = baseSelector + " " + markdownStyleKeyHTMLTag[styleKey];
		css += selector + "{";

		css += "display:inline;";

		if (styleValue["backgroundColor"] !== undefined) {
			css += "background-color:" + styleValue["backgroundColor"] + ";";
		}
		if (styleValue["color"] !== undefined) {
			css += "color:" + styleValue["color"] + ";";
		}
		if (styleValue["fontFamily"] !== undefined) {
			css += "font-family:" + styleValue["fontFamily"] + ";";
		}
		if (styleValue["fontSize"] !== undefined) {
			css += "font-size:" + styleValue["fontSize"] + "px;";
		}
		if (styleValue["fontStyle"] !== undefined) {
			css += "font-style:" + styleValue["fontStyle"] + ";";
		}
		if (styleValue["fontWeight"] !== undefined) {
			css += "font-weight:" + styleValue["fontWeight"] + ";";
		}

		if (styleKey === "blockquote") {
			css += "box-decoration-break: clone;";
			css += "-webkit-box-decoration-break: clone;";

			if (styleValue["gapWidth"] !== undefined) {
				css += "padding-left:" + styleValue["gapWidth"] + "px;";
			}
			if (styleValue["stripeWidth"] !== undefined) {
				css += "border-left-width:" + styleValue["stripeWidth"] + "px;";
			}
			if (styleValue["stripeColor"] !== undefined) {
				css += "border-left-color:" + styleValue["stripeColor"] + ";";
				css += "border-left-style:solid;";
			}
		}

		css += "}";
	}

	return css;
}

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
					if (range.startOffset > 0) {
						startNode =
							currentNode.childNodes[range.startOffset - 1];
					} else {
						start = cursor;
					}
				}
				if (currentNode === range.endContainer) {
					if (range.endOffset > 0) {
						endNode = currentNode.childNodes[range.endOffset - 1];
					} else {
						end = cursor;
						break;
					}
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

// s77rt: what if we add text in the middle?
// s77rt: check for equalitiy without using isEqualNode
// s77rt: undo (history)
// s77rt: avoid cloneNode, instead just change the index
const domParser = new DOMParser();
function transformNodeDOM(currentNode: HTMLElement, targetNode: HTMLElement) {
	for (
		let currentNodeChildIndex = 0, targetNodeChildIndex = 0;
		currentNodeChildIndex < currentNode.childNodes.length ||
		targetNodeChildIndex < targetNode.childNodes.length;
		currentNodeChildIndex++, targetNodeChildIndex++
	) {
		const currentNodeChild = currentNode.childNodes[currentNodeChildIndex];
		const currentNodeNextChild =
			currentNode.childNodes[currentNodeChildIndex + 1];
		const targetNodeChild = targetNode.childNodes[targetNodeChildIndex];
		const targetNodeNextChild =
			targetNode.childNodes[targetNodeChildIndex + 1];

		if (currentNodeChild && !targetNodeChild) {
			currentNode.removeChild(currentNodeChild);
			currentNodeChildIndex--;
			continue;
		}
		if (!currentNodeChild && targetNodeChild) {
			currentNode.appendChild(targetNodeChild);
			currentNodeChildIndex++;
			targetNodeChildIndex--;
			continue;
		}

		if (currentNodeChild.isEqualNode(targetNodeChild)) {
			continue;
		}

		if (currentNodeNextChild?.isEqualNode(targetNodeChild)) {
			currentNode.removeChild(currentNodeChild);
			continue;
		}

		if (targetNodeNextChild?.isEqualNode(currentNodeChild)) {
			currentNode.insertBefore(targetNodeChild, currentNodeChild);
			currentNodeChildIndex++;
			continue;
		}

		if (currentNodeChild.nodeName === targetNodeChild.nodeName) {
			if (currentNodeChild.nodeType === Node.TEXT_NODE) {
				currentNodeChild.textContent = targetNodeChild.textContent;
			} else if (currentNodeChild.nodeType === Node.ELEMENT_NODE) {
				transformNodeDOM(
					currentNodeChild as HTMLElement,
					targetNodeChild as HTMLElement
				);
			}
			continue;
		}

		currentNode.replaceChild(targetNodeChild, currentNodeChild);
		targetNodeChildIndex--;
	}
}

function MarkdownTextInput(
	{
		markdownStyles: markdownStylesProp,
		style: styleProp,
		dataSet: dataSetProp,
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
	const [id] = useState<string>(() => crypto.randomUUID());

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

	const dataSet = useMemo(
		() => ({
			...dataSetProp,
			"md-id": id,
		}),
		[dataSetProp, id]
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
	const isSelectionStale = useRef(false);

	/** Selection setter */
	const setSelection = useCallback(
		(
			newSelection: { start: number; end: number },
			shouldInvalidate: boolean
		) => {
			setSelectionInternal(newSelection);
			selectionStore.current = newSelection;
			if (shouldInvalidate) {
				isSelectionStale.current = true;
			}
		},
		[]
	);

	/** Sync cursor position */
	const syncCursorPosition = useCallback(
		(newValue: string) => {
			const oldValue = valueStore.current;

			const oldValuegnoredOffset = oldValue.at(-1) === "\n" ? 1 : 0;
			const newValueIgnoredOffset = newValue.at(-1) === "\n" ? 1 : 0;

			const position = isDeleteContentForward.current
				? selectionStore.current.start
				: selectionStore.current.end -
				  (oldValue.length - oldValuegnoredOffset) +
				  (newValue.length - newValueIgnoredOffset);

			setSelection({ start: position, end: position }, true);
		},
		[setSelection]
	);

	/** Value setter */
	const setValue = useCallback(
		(newValue: string, shouldInvalidate: boolean) => {
			setValueInternal(newValue);
			syncCursorPosition(newValue);
			valueStore.current = newValue;
			if (shouldInvalidate) {
				isValueStale.current = true;
			}
		},
		[syncCursorPosition]
	);

	/** Events */
	const onSelectionChange = useCallback(
		(event: NativeSyntheticEvent<TextInputSelectionChangeEventData>) => {
			setSelection(event.nativeEvent.selection, false);
			onSelectionChangeProp?.(event);
		},
		[setSelection, onSelectionChangeProp]
	);
	const onChangeText = useCallback(
		(text: string) => {
			const newValue = multiline
				? text.replaceAll(/\r/g, "")
				: text.replaceAll(/[\n\r]/g, "");
			setValue(newValue, true);
			onChangeTextProp?.(newValue);
		},
		[setValue, onChangeTextProp, multiline]
	);

	/** Sync state to DOM */
	if (innerRef.current && isValueStale.current) {
		transformNodeDOM(
			innerRef.current,
			domParser.parseFromString(format(value), "text/html").body
		);
		//innerRef.current.innerHTML = format(value);
		isValueStale.current = false;
	}
	if (innerRef.current && isSelectionStale.current) {
		setSelectionDOM(innerRef.current, selection);
		isSelectionStale.current = false;
	}

	/** Sync props to state */
	if (selectionProp !== undefined && selectionProp != selection) {
		setSelection(selectionProp, true);
	}
	if (valueProp !== undefined && valueProp != value) {
		setValue(valueProp, true);
	}

	/** CSS injection */
	useInsertionEffect(() => {
		const styleElement = document.createElement("style");
		styleElement.textContent = buildMarkdownStylesCSS(markdownStyles, id);
		document.head.append(styleElement);

		return () => styleElement.remove();
	}, [id, markdownStyles]);

	// Add missing properties that are used in RNW TextInput implementation
	// https://github.com/necolas/react-native-web/blob/fcbe2d1e9225282671e39f9f639e2cb04c7e1e65/packages/react-native-web/src/exports/TextInput/index.js
	useLayoutEffect(() => {
		Object.defineProperty(innerRef.current, "value", {
			/** Used to get the `text` value that is sent with events e.g. onFocus */
			get: () => innerRef.current.innerText,
			/** Used to set/clear the input */
			set: (newValue) => (innerRef.current.innerHTML = format(newValue)),
		});

		Object.defineProperty(innerRef.current, "selectionStart", {
			/** Used to check if the selection is stale */
			get: () => selectionStore.current.start,
		});
		Object.defineProperty(innerRef.current, "selectionEnd", {
			/** Used to check if the selection is stale */
			get: () => selectionStore.current.end,
		});

		Object.defineProperty(innerRef.current, "setSelectionRange", {
			/** Used to set the selection */
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

			const isSelectionDirty =
				selectionDOM.start != selectionStore.current.start ||
				selectionDOM.end != selectionStore.current.end;
			if (!isSelectionDirty) {
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
			onChangeText={onChangeText}
			multiline={multiline}
			dataSet={dataSet}
			{...rest}
		/>
	);
}

export default React.memo(forwardRef(MarkdownTextInput));
