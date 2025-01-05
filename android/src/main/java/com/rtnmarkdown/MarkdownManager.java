package com.rtnmarkdown;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.facebook.common.logging.FLog;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.ViewManagerDelegate;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.viewmanagers.RTNMarkdownManagerDelegate;
import com.facebook.react.viewmanagers.RTNMarkdownManagerInterface;

@ReactModule(name = MarkdownManager.NAME)
public class MarkdownManager extends ViewGroupManager<Markdown>
    implements RTNMarkdownManagerInterface<Markdown> {
  static final String NAME = "RTNMarkdown";

  private final ViewManagerDelegate<Markdown> mDelegate;

  public MarkdownManager(ReactApplicationContext context) {
    mDelegate = new RTNMarkdownManagerDelegate<>(this);
  }

  @NonNull
  @Override
  public String getName() {
    return MarkdownManager.NAME;
  }

  @Nullable
  @Override
  protected ViewManagerDelegate<Markdown> getDelegate() {
    return mDelegate;
  }

  @NonNull
  @Override
  public Markdown createViewInstance(@NonNull ThemedReactContext context) {
    return new Markdown(context);
  }

  @Override
  @ReactProp(name = "markdownStyles")
  public void setMarkdownStyles(Markdown view,
                                @Nullable ReadableMap markdownStyles) {
    view.setMarkdownStyles(markdownStyles);
  }
}
