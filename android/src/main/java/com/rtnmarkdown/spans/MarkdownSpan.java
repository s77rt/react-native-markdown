package com.rtnmarkdown.spans;

import android.graphics.Typeface;
import androidx.annotation.Nullable;

public interface MarkdownSpan {
  /* Creates a new span with passed arguments */
  MarkdownSpan hardClone(@Nullable Typeface defaultTypeface);
}
