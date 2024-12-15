package com.rtnmarkdowninput;

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
import com.rtnmarkdowninput.spans.MarkdownForegroundColorSpan;
import com.rtnmarkdowninput.spans.MarkdownSpan;

public class MarkdownInputTextWatcher implements TextWatcher {
  @Override
  public void beforeTextChanged(CharSequence s, int start, int count,
                                int after) {}

  @Override
  public void onTextChanged(CharSequence s, int start, int before, int count) {}

  @Override
  public void afterTextChanged(Editable s) {
    if (s.length() > 4) {
      MarkdownSpan foregroundSpan = new MarkdownForegroundColorSpan(Color.RED);
      s.setSpan(foregroundSpan, 2, 4, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
    }
  }
}
