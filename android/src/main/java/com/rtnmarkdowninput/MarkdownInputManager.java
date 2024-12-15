package com.rtnmarkdowninput;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.facebook.common.logging.FLog;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.ViewManagerDelegate;
import com.facebook.react.viewmanagers.RTNMarkdownInputManagerDelegate;
import com.facebook.react.viewmanagers.RTNMarkdownInputManagerInterface;

@ReactModule(name = MarkdownInputManager.NAME)
public class MarkdownInputManager extends ViewGroupManager<MarkdownInputGroup>
    implements RTNMarkdownInputManagerInterface<MarkdownInputGroup> {
  static final String NAME = "RTNMarkdownInput";

  private final ViewManagerDelegate<MarkdownInputGroup> mDelegate;

  public MarkdownInputManager(ReactApplicationContext context) {
    mDelegate = new RTNMarkdownInputManagerDelegate<>(this);
  }

  @NonNull
  @Override
  public String getName() {
    return MarkdownInputManager.NAME;
  }

  @Nullable
  @Override
  protected ViewManagerDelegate<MarkdownInputGroup> getDelegate() {
    return mDelegate;
  }

  @NonNull
  @Override
  public MarkdownInputGroup
  createViewInstance(@NonNull ThemedReactContext context) {
    return new MarkdownInputGroup(context);
  }
}
