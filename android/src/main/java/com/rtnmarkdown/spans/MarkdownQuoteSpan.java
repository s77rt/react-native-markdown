package com.rtnmarkdown.spans;

import android.text.style.QuoteSpan;

public class MarkdownQuoteSpan extends QuoteSpan implements MarkdownSpan {
  private int mColor;
  private int mStripeWidth;
  private int mGapWidth;

  public MarkdownQuoteSpan(int color, int stripeWidth, int gapWidth) {
    super(color, stripeWidth, gapWidth);
    mColor = color;
    mStripeWidth = stripeWidth;
    mGapWidth = gapWidth;
  }

  @Override
  public MarkdownQuoteSpan clone() {
    return new MarkdownQuoteSpan(mColor, mStripeWidth, mGapWidth);
  }
}
