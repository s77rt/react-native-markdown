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
  static { System.loadLibrary("md4c-jni"); }

  private native void parseJNI(String markdownString);

  public void format(Spannable markdownString) {
    this.parseJNI(markdownString.toString());
  }
}
