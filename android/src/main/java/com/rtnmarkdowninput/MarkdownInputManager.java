package com.rtnmarkdowninput;

import androidx.annotation.NonNull;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.views.textinput.ReactEditText;
import com.facebook.react.views.textinput.ReactTextInputManager;

@ReactModule(name = MarkdownInputManager.NAME)
public class MarkdownInputManager extends ReactTextInputManager {
  static final String NAME = "RTNMarkdownInput";

  @NonNull
  @Override
  public String getName() {
    return MarkdownInputManager.NAME;
  }
}
