import React from "react";
import parser from "../../wasm/parser/parser.mjs";

// Register window namespace
window["739b9b2c-40c9-4772-9bf5-3ff5930ed2c4"] = {};

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

// WebAssembly parser
parser().then((m) => {
	window["739b9b2c-40c9-4772-9bf5-3ff5930ed2c4"].format = (text) => {
		const textPtr = m._malloc((text.length + 1) * 2);
		m.stringToUTF16(text, textPtr);

		const formatedTextPtr = m._PARSEANDFORMAT(textPtr, text.length);
		m._free(textPtr);

		const formatedText = m.UTF16ToString(formatedTextPtr);
		m._free(formatedTextPtr);

		return formatedText;
	};
});
