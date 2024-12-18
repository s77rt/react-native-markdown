package com.rtnmarkdown;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import java.util.Collections;
import java.util.List;

public class MarkdownPackage implements ReactPackage {

  @Override
  public List<ViewManager>
  createViewManagers(ReactApplicationContext reactContext) {
    return Collections.singletonList(new MarkdownManager(reactContext));
  }

  @Override
  public List<NativeModule>
  createNativeModules(ReactApplicationContext reactContext) {
    return Collections.emptyList();
  }
}
