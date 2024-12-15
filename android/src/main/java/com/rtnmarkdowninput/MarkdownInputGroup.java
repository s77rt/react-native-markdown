package com.rtnmarkdowninput;

import android.content.Context;
import android.graphics.Color;
import android.text.Editable;
import android.text.Spannable;
import android.text.TextWatcher;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.Nullable;
import com.facebook.react.views.text.internal.span.ReactForegroundColorSpan;
import com.facebook.react.views.text.internal.span.ReactSpan;
import com.facebook.react.views.textinput.ReactEditText;
import com.facebook.react.views.view.ReactViewGroup;

public class MarkdownInputGroup extends ReactViewGroup {
  public MarkdownInputGroup(Context context) { super(context); }

  @Override
  public void addView(View child, int index,
                      @Nullable ViewGroup.LayoutParams params) {
    ReactEditText editText = (ReactEditText)child;
    editText.addTextChangedListener(new MarkdownInputTextWatcher());
    super.addView(child, index, params);
  }
}
