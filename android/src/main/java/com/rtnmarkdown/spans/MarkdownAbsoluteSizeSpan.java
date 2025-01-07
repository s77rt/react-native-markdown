package com.rtnmarkdown.spans;

import android.graphics.Typeface;
import android.text.style.AbsoluteSizeSpan;
import androidx.annotation.Nullable;

public class MarkdownAbsoluteSizeSpan
    extends AbsoluteSizeSpan implements MarkdownSpan {
  private int mSize;

  public MarkdownAbsoluteSizeSpan(int size) {
    super(size);
    mSize = size;
  }

  @Override
  public MarkdownAbsoluteSizeSpan spanWith(@Nullable Typeface defaultTypeface) {
    return new MarkdownAbsoluteSizeSpan(mSize);
  }
}
