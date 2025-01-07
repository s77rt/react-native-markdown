package com.rtnmarkdown.spans;

import android.content.res.AssetManager;
import android.graphics.Typeface;
import android.text.style.TypefaceSpan;
import androidx.annotation.Nullable;
import com.facebook.react.common.ReactConstants;
import com.facebook.react.views.text.ReactTypefaceUtils;

public class MarkdownTypefaceSpan extends TypefaceSpan implements MarkdownSpan {
  private int mStyle;
  private int mWeight;
  private @Nullable String mFamily;
  private AssetManager mAssetManager;

  public MarkdownTypefaceSpan(@Nullable Typeface defaultTypeface, int style,
                              int weight, @Nullable String family,
                              AssetManager assetManager) {
    super(createTypeface(defaultTypeface, style, weight, family, assetManager));
    mStyle = style;
    mWeight = weight;
    mFamily = family;
    mAssetManager = assetManager;
  }

  private static Typeface createTypeface(@Nullable Typeface defaultTypeface,
                                         int style, int weight,
                                         @Nullable String family,
                                         AssetManager assetManager) {
    int effectiveStyle =
        style == ReactConstants.UNSET && defaultTypeface != null
            ? defaultTypeface.getStyle()
            : style;
    int effectiveWeight =
        weight == ReactConstants.UNSET && defaultTypeface != null
            ? defaultTypeface.getWeight()
            : weight;

    return ReactTypefaceUtils.applyStyles(
        defaultTypeface, effectiveStyle, effectiveWeight, family, assetManager);
  }

  @Override
  public MarkdownTypefaceSpan spanWith(@Nullable Typeface defaultTypeface) {
    return new MarkdownTypefaceSpan(defaultTypeface, mStyle, mWeight, mFamily,
                                    mAssetManager);
  }
}
