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

public class MarkdownTextWatcher implements TextWatcher {
  @Override
  public void beforeTextChanged(CharSequence s, int start, int count,
                                int after) {}

  @Override
  public void onTextChanged(CharSequence s, int start, int before, int count) {}

  @Override
  public void afterTextChanged(Editable s) {
    FLog.e("s77rt", "afterTextChanged");
    MarkdownFormatter formatter = new MarkdownFormatter();
    formatter.format(s);
  }
}
