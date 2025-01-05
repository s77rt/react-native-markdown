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
import com.facebook.react.views.text.internal.span.ReactForegroundColorSpan;
import com.facebook.react.views.text.internal.span.ReactSpan;
import com.facebook.react.views.textinput.ReactEditText;
import com.facebook.react.views.view.ReactViewGroup;

public class Markdown extends ReactViewGroup {
  private final Context mContext;
  private final MarkdownTextWatcher mTextWatcher = new MarkdownTextWatcher();

  public Markdown(Context context) {
    super(context);
    mContext = context;
  }

  public void setMarkdownStyles(@Nullable ReadableMap markdownStyles) {
    if (markdownStyles == null) {
      mTextWatcher.setFormatter(null);
      return;
    }
    mTextWatcher.setFormatter(new MarkdownFormatter(mContext, markdownStyles));
  }

  @Override
  public void addView(View child, int index,
                      @Nullable ViewGroup.LayoutParams params) {
    mTextWatcher.watch((ReactEditText)child);
    super.addView(child, index, params);
  }
}
