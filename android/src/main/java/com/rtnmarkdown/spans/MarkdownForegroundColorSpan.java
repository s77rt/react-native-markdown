package com.rtnmarkdown.spans;

import android.graphics.Typeface;
import android.text.style.ForegroundColorSpan;
import androidx.annotation.Nullable;

public class MarkdownForegroundColorSpan
    extends ForegroundColorSpan implements MarkdownSpan {
  private int mColor;

  public MarkdownForegroundColorSpan(int color) {
    super(color);
    mColor = color;
  }

  @Override
  public MarkdownForegroundColorSpan
  hardClone(@Nullable Typeface defaultTypeface) {
    return new MarkdownForegroundColorSpan(mColor);
  }
}
