package com.rtnmarkdown.spans;

import android.text.style.ForegroundColorSpan;

public class MarkdownForegroundColorSpan
    extends ForegroundColorSpan implements MarkdownSpan {
  public MarkdownForegroundColorSpan(int color) { super(color); }
}
