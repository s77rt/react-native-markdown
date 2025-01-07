package com.rtnmarkdown;

import android.text.Editable;
import android.text.TextWatcher;
import androidx.annotation.Nullable;
import com.facebook.react.views.textinput.ReactEditText;

public class MarkdownTextWatcher implements TextWatcher {
  private ReactEditText mReactEditText;
  @Nullable private MarkdownFormatter mFormatter;
  @Nullable private String mPreviousText;

  public void watch(ReactEditText editText) {
    mReactEditText = editText;
    mReactEditText.addTextChangedListener(this);
  }

  public void setFormatter(MarkdownFormatter formatter) {
    mFormatter = formatter;
    mPreviousText = null;
  }

  @Override
  public void beforeTextChanged(CharSequence s, int start, int count,
                                int after) {}

  @Override
  public void onTextChanged(CharSequence s, int start, int before, int count) {}

  @Override
  public void afterTextChanged(Editable s) {
    if (mFormatter == null) {
      return;
    }

    String newText = s.toString();

    if (mPreviousText != null && mPreviousText.equals(newText)) {
      return;
    }

    mFormatter.format(s, mReactEditText.getTypeface());

    mPreviousText = newText;
  }
}
