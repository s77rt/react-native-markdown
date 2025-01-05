package com.rtnmarkdown.spans;

import android.text.style.ForegroundColorSpan;

public class MarkdownForegroundColorSpan
    extends ForegroundColorSpan implements MarkdownSpan {
  private int mColor;

  public MarkdownForegroundColorSpan(int color) {
    super(color);
    mColor = color;
  }

  @Override
  public MarkdownForegroundColorSpan clone() {
    return new MarkdownForegroundColorSpan(mColor);
  }
}
