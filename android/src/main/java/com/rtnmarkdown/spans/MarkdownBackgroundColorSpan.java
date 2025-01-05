package com.rtnmarkdown.spans;

import android.text.style.BackgroundColorSpan;

public class MarkdownBackgroundColorSpan
    extends BackgroundColorSpan implements MarkdownSpan {
  private int mColor;

  public MarkdownBackgroundColorSpan(int color) {
    super(color);
    mColor = color;
  }

  @Override
  public MarkdownBackgroundColorSpan clone() {
    return new MarkdownBackgroundColorSpan(mColor);
  }
}
