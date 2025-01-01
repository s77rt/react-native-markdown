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
import com.facebook.react.views.textinput.ReactEditText;
import com.facebook.react.views.view.ReactViewGroup;
import com.rtnmarkdown.spans.MarkdownForegroundColorSpan;
import com.rtnmarkdown.spans.MarkdownQuoteSpan;
import com.rtnmarkdown.spans.MarkdownSpan;

public class MarkdownFormatter {
  static { System.loadLibrary("parser-jni"); }

  /* Copied from cpp/parser.h */
  private static final int Attribute_Unknown = 0;

  private static final int Attribute_Document_Block = 1;
  private static final int Attribute_Document = 2;

  private static final int Attribute_Heading_Block = 3;
  private static final int Attribute_Heading = 4;

  private static final int Attribute_Blockquote_Block = 5;
  private static final int Attribute_Blockquote = 6;

  private static final int Attribute_Code_Block = 7;
  private static final int Attribute_Code = 8;

  private static final int Attribute_HorizontalRule_Block = 9;
  private static final int Attribute_HorizontalRule = 10;

  private static final int Attribute_Bold = 11;
  private static final int Attribute_Italic = 12;
  private static final int Attribute_Link = 13;
  private static final int Attribute_Image = 14;
  private static final int Attribute_InlineCode = 15;
  private static final int Attribute_Strikethrough = 16;
  private static final int Attribute_Underline = 17;
  /* end */

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

      int start = attribute.location;
      int end = attribute.location + attribute.length;
      int flags = Spannable.SPAN_EXCLUSIVE_EXCLUSIVE;

      switch (attribute.attribute) {
      case Attribute_Blockquote_Block: {
        MarkdownSpan quoteSpan = new MarkdownQuoteSpan(Color.BLUE, 4, 4);
        markdownString.setSpan(quoteSpan, start, end, flags);
        break;
      }
      case Attribute_Bold: {
        MarkdownSpan foregroundSpan =
            new MarkdownForegroundColorSpan(Color.RED);
        markdownString.setSpan(foregroundSpan, start, end, flags);
        break;
      }
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
