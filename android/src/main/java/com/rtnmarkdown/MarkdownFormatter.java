package com.rtnmarkdown;

import android.content.Context;
import android.graphics.Color;
import android.text.Editable;
import android.text.Spannable;
import android.text.TextWatcher;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.Nullable;
import com.facebook.common.logging.FLog;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.views.textinput.ReactEditText;
import com.facebook.react.views.view.ReactViewGroup;
import com.rtnmarkdown.spans.MarkdownBackgroundColorSpan;
import com.rtnmarkdown.spans.MarkdownForegroundColorSpan;
import com.rtnmarkdown.spans.MarkdownQuoteSpan;
import com.rtnmarkdown.spans.MarkdownSpan;
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

  private final MarkdownSpan[][] mSpans =
      new MarkdownSpan[18][]; // 18 attributes (see above)

  public MarkdownFormatter(ReadableMap markdownStyles) {
    if (markdownStyles.hasKey("headingBlock")) {
      ReadableMap headingBlock = markdownStyles.getMap("headingBlock");
      boolean hasBackgroundColor = headingBlock.hasKey("backgroundColor");
      boolean hasColor = headingBlock.hasKey("color");
      boolean hasFontFamily = headingBlock.hasKey("fontFamily");
      boolean hasFontSize = headingBlock.hasKey("fontSize");
      boolean hasFontStyle = headingBlock.hasKey("fontStyle");
      boolean hasFontWeight = headingBlock.hasKey("fontWeight");

      int length = (hasBackgroundColor ? 1 : 0) + (hasColor ? 1 : 0) +
                   (hasFontFamily ? 1 : 0) + (hasFontSize ? 1 : 0) +
                   (hasFontStyle ? 1 : 0) + (hasFontWeight ? 1 : 0);
      int index = 0;
      MarkdownSpan[] spans = new MarkdownSpan[length];

      if (hasBackgroundColor) {
        spans[index++] = new MarkdownBackgroundColorSpan(
            headingBlock.getInt("backgroundColor"));
      }
      if (hasColor) {
        spans[index++] =
            new MarkdownForegroundColorSpan(headingBlock.getInt("color"));
      }

      mSpans[Attribute_Heading] = spans;
    }
  }

  private native AttributeFeature[] parseJNI(String markdownString);

  public void format(Spannable markdownString) {
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

      MarkdownSpan[] spans = mSpans[attribute.attribute];
      if (spans == null) {
        continue;
      }
      if (spans.length == 0) {
        continue;
      }

      int start = attribute.location;
      int end = attribute.location + attribute.length;
      int flags = Spannable.SPAN_EXCLUSIVE_EXCLUSIVE;

      for (MarkdownSpan span : spans) {
        markdownString.setSpan(span.clone(), start, end, flags);
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
