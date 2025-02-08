import { Platform, processColor as processColorRN } from "react-native";

const processColor = (color: any) => {
	const processedColor = processColorRN(color);

	if (Platform.OS === "web") {
		// Convert aarrggbb to rrggbbaa
		const hexColor =
			((processedColor << 8) | (processedColor >>> 24)) >>> 0;
		return "#" + hexColor.toString(16).padStart(8, "0");
	}

	return processedColor;
};

const processFontWeight = (fontWeight: any) => {
	if (typeof fontWeight === "number") {
		return fontWeight.toString();
	}
	return fontWeight;
};

const processStyles = (obj: {}) => {
	Object.keys(obj).forEach((key) => {
		if (typeof obj[key] === "object" && obj[key] !== null) {
			processStyles(obj[key]);
			return;
		}
		if (["backgroundColor", "color", "stripeColor"].includes(key)) {
			obj[key] = processColor(obj[key]);
			return;
		}
		if (["fontWeight"].includes(key)) {
			obj[key] = processFontWeight(obj[key]);
			return;
		}
	});
};

export default processStyles;
