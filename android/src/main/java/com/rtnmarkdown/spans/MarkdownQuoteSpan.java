package com.rtnmarkdown.spans;

import android.graphics.Typeface;
import android.text.style.QuoteSpan;
import androidx.annotation.Nullable;

public class MarkdownQuoteSpan extends QuoteSpan implements MarkdownSpan {
  private int mStripeColor;
  private int mStripeWidth;
  private int mGapWidth;

  public MarkdownQuoteSpan(int stripeColor, int stripeWidth, int gapWidth) {
    super(stripeColor, stripeWidth, gapWidth);
    mStripeColor = stripeColor;
    mStripeWidth = stripeWidth;
    mGapWidth = gapWidth;
  }

  @Override
  public MarkdownQuoteSpan hardClone(@Nullable Typeface defaultTypeface) {
    return new MarkdownQuoteSpan(mStripeColor, mStripeWidth, mGapWidth);
  }
}
