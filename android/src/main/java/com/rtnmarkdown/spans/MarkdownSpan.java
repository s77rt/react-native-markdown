package com.rtnmarkdown.spans;

import android.graphics.Typeface;
import androidx.annotation.Nullable;

public interface MarkdownSpan {
  MarkdownSpan spanWith(@Nullable Typeface defaultTypeface);
}
