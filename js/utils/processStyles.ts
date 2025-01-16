import { processColor } from "react-native";

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
