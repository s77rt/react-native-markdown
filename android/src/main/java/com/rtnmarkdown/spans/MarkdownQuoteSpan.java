package com.rtnmarkdown.spans;

import android.text.style.QuoteSpan;

public class MarkdownQuoteSpan extends QuoteSpan implements MarkdownSpan {
  public MarkdownQuoteSpan(int color, int stripeWidth, int gapWidth) {
    super(color, stripeWidth, gapWidth);
  }
}
