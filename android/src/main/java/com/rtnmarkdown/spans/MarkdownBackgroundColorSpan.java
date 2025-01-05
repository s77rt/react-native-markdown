package com.rtnmarkdown.spans;

import android.graphics.Typeface;
import android.text.style.BackgroundColorSpan;
import androidx.annotation.Nullable;

public class MarkdownBackgroundColorSpan
    extends BackgroundColorSpan implements MarkdownSpan {
  private int mColor;

  public MarkdownBackgroundColorSpan(int color) {
    super(color);
    mColor = color;
  }

  @Override
  public MarkdownBackgroundColorSpan
  hardClone(@Nullable Typeface defaultTypeface) {
    return new MarkdownBackgroundColorSpan(mColor);
  }
}
