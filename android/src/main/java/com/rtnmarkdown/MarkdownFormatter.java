package com.rtnmarkdown;

import android.content.Context;
import android.graphics.Typeface;
import android.text.Spannable;
import android.text.style.TypefaceSpan;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.common.ReactConstants;
import com.facebook.react.uimanager.PixelUtil;
import com.facebook.react.views.text.ReactTypefaceUtils;
import com.rtnmarkdown.spans.MarkdownAbsoluteSizeSpan;
import com.rtnmarkdown.spans.MarkdownBackgroundColorSpan;
import com.rtnmarkdown.spans.MarkdownForegroundColorSpan;
import com.rtnmarkdown.spans.MarkdownQuoteSpan;
import com.rtnmarkdown.spans.MarkdownSpan;
import com.rtnmarkdown.spans.MarkdownTypefaceSpan;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class MarkdownFormatter {
  static { System.loadLibrary("parser-jni"); }

  /* Copied from cpp/parser/parser.h */
  private static final int Attribute_Unknown = 0;

  private static final int Attribute_Document = 1;
  private static final int Attribute_Heading = 2;
  private static final int Attribute_Blockquote = 3;
  private static final int Attribute_Codeblock = 4;
  private static final int Attribute_HorizontalRule = 5;

  private static final int Attribute_Bold = 6;
  private static final int Attribute_Italic = 7;
  private static final int Attribute_Link = 8;
  private static final int Attribute_Image = 9;
  private static final int Attribute_Code = 10;
  private static final int Attribute_Strikethrough = 11;
  private static final int Attribute_Underline = 12;
  /* end */

  private final HashMap<String, MarkdownSpan[]> mSpans =
      new HashMap<String, MarkdownSpan[]>();

  public MarkdownFormatter(Context context, ReadableMap markdownStyles) {
    Iterator<Map.Entry<String, Object>> iterator =
        markdownStyles.getEntryIterator();
    while (iterator.hasNext()) {
      Map.Entry<String, Object> entry = iterator.next();

      String styleKey = entry.getKey();
      ReadableMap styleValue = (ReadableMap)entry.getValue();
      ArrayList<MarkdownSpan> styleSpansList = new ArrayList<MarkdownSpan>();

      if (styleValue.hasKey("backgroundColor")) {
        styleSpansList.add(new MarkdownBackgroundColorSpan(
            styleValue.getInt("backgroundColor")));
      }
      if (styleValue.hasKey("color")) {
        styleSpansList.add(
            new MarkdownForegroundColorSpan(styleValue.getInt("color")));
      }
      {
        boolean hasFontStyle = styleValue.hasKey("fontStyle");
        boolean hasFontWeight = styleValue.hasKey("fontWeight");
        boolean hasFontFamily = styleValue.hasKey("fontFamily");
        if (hasFontStyle || hasFontWeight || hasFontFamily) {
          int style = hasFontStyle ? ReactTypefaceUtils.parseFontStyle(
                                         styleValue.getString("fontStyle"))
                                   : ReactConstants.UNSET;
          int weight = hasFontWeight ? ReactTypefaceUtils.parseFontWeight(
                                           styleValue.getString("fontWeight"))
                                     : ReactConstants.UNSET;
          String family =
              hasFontFamily ? styleValue.getString("fontFamily") : null;

          styleSpansList.add(new MarkdownTypefaceSpan(
              null, style, weight, family, context.getAssets()));
        }
      }
      if (styleValue.hasKey("fontSize")) {
        styleSpansList.add(new MarkdownAbsoluteSizeSpan(
            (int)Math.ceil(PixelUtil.toPixelFromDIP(
                (float)styleValue.getDouble("fontSize")))));
      }

      if (styleKey.equals("blockquote")) {
        {
          boolean hasStripeColor = styleValue.hasKey("stripeColor");
          boolean hasStripeWidth = styleValue.hasKey("stripeWidth");
          boolean hasGapWidth = styleValue.hasKey("gapWidth");
          if (hasStripeColor || hasStripeWidth || hasGapWidth) {
            int stripeColor = hasStripeColor ? styleValue.getInt("stripeColor")
                                             : ReactConstants.UNSET;
            int stripeWidth =
                hasStripeWidth
                    ? (int)Math.ceil(PixelUtil.toPixelFromDIP(
                          (float)styleValue.getDouble("stripeWidth")))
                    : ReactConstants.UNSET;
            int gapWidth = hasGapWidth
                               ? (int)Math.ceil(PixelUtil.toPixelFromDIP(
                                     (float)styleValue.getDouble("gapWidth")))
                               : ReactConstants.UNSET;
            styleSpansList.add(
                new MarkdownQuoteSpan(stripeColor, stripeWidth, gapWidth));
          }
        }
      }

      if (styleSpansList.isEmpty()) {
        continue;
      }

      MarkdownSpan[] styleSpans = styleSpansList.toArray(new MarkdownSpan[0]);
      mSpans.put(styleKey, styleSpans);
    }
  }

  private native AttributeFeature[] parseJNI(String markdownString);

  public void format(Spannable markdownString, Typeface defaultTypeface) {
    AttributeFeature[] attributes = this.parseJNI(markdownString.toString());

    MarkdownSpan[] markdownSpans =
        markdownString.getSpans(0, markdownString.length(), MarkdownSpan.class);
    for (MarkdownSpan markdownSpan : markdownSpans) {
      markdownString.removeSpan(markdownSpan);
    }

    for (AttributeFeature attribute : attributes) {
      if (attribute.length == 0) {
        continue;
      }
      if (attribute.attribute == Attribute_Unknown) {
        continue;
      }

      String styleKey = switch (attribute.attribute) {
      case Attribute_Heading: {
        yield switch (attribute.data1) {
        case 1:
          yield "h1";
        case 2:
          yield "h2";
        case 3:
          yield "h3";
        case 4:
          yield "h4";
        case 5:
          yield "h5";
        case 6:
          yield "h6";
        default:
          yield "";
        };
      }
      case Attribute_Blockquote:
        yield "blockquote";
      case Attribute_Codeblock:
        yield "codeblock";
      case Attribute_HorizontalRule:
        yield "horizontalRule";
      case Attribute_Bold:
        yield "bold";
      case Attribute_Italic:
        yield "italic";
      case Attribute_Link:
        yield "link";
      case Attribute_Image:
        yield "image";
      case Attribute_Code:
        yield "code";
      case Attribute_Strikethrough:
        yield "strikethrough";
      case Attribute_Underline:
        yield "underline";
      default:
        yield "";
      };

      MarkdownSpan[] spans = mSpans.get(styleKey);
      if (spans == null) {
        continue;
      }

      int start = attribute.location;
      int end = attribute.location + attribute.length;
      int flags = Spannable.SPAN_EXCLUSIVE_EXCLUSIVE;

      Typeface baseTypeface = defaultTypeface;
      for (TypefaceSpan typefaceSpan :
           markdownString.getSpans(start, end, TypefaceSpan.class)) {
        baseTypeface = typefaceSpan.getTypeface();
      }

      for (MarkdownSpan span : spans) {
        markdownString.setSpan(span.spanWith(baseTypeface), start, end, flags);
      }
    }
  }
}

class AttributeFeature {
  public int attribute;
  public int location;
  public int length;
  public int data1;

  AttributeFeature(int attribute, int location, int length, int data1) {
    this.attribute = attribute;
    this.location = location;
    this.length = length;
    this.data1 = data1;
  }
};
