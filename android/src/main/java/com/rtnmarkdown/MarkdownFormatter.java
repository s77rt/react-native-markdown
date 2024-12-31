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
import com.rtnmarkdown.spans.MarkdownSpan;

public class MarkdownFormatter {
  static { System.loadLibrary("parser-jni"); }

  private native AttributeFeature[] parseJNI(String markdownString);

  public void format(Spannable markdownString) {
    AttributeFeature[] attributes = this.parseJNI(markdownString.toString());
    for (AttributeFeature attribute : attributes) {
      FLog.e("s77rt", String.valueOf(attribute.attribute));
      FLog.e("s77rt", String.valueOf(attribute.length));
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
