#include "parser-jni.h"
#include "parser.h"

static jint JNI_VERSION = JNI_VERSION_1_6;

static jclass JC_AttributeFeature;
static jmethodID JMID_AttributeFeature_constructor;

JNIEXPORT jobjectArray JNICALL parseJNI(JNIEnv *env, jobject thiz,
                                        jstring markdownString) {
  const char *input = env->GetStringUTFChars(markdownString, NULL);
  std::vector<AttributeFeature> attributes = parse(input);
  env->ReleaseStringUTFChars(markdownString, input);

  jobjectArray ret =
      env->NewObjectArray(attributes.size(), JC_AttributeFeature, NULL);

  int i;
  for (i = 0; i < attributes.size(); i++) {
    jobject obj =
        env->NewObject(JC_AttributeFeature, JMID_AttributeFeature_constructor,
                       attributes[i].attribute, attributes[i].location,
                       attributes[i].length, attributes[i].data1);
    env->SetObjectArrayElement(ret, i, obj);
  }

  return ret;
}

JNIEXPORT jint JNI_OnLoad(JavaVM *vm, void *reserved) {
  JNIEnv *env;
  if (vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION) != JNI_OK) {
    return JNI_ERR;
  }

  jclass c = env->FindClass("com/rtnmarkdown/MarkdownFormatter");
  if (c == nullptr)
    return JNI_ERR;

  static const JNINativeMethod methods[] = {
      {"parseJNI", "(Ljava/lang/String;)[Lcom/rtnmarkdown/AttributeFeature;",
       reinterpret_cast<void *>(parseJNI)},
  };
  int rc = env->RegisterNatives(c, methods,
                                sizeof(methods) / sizeof(JNINativeMethod));
  if (rc != JNI_OK)
    return rc;

  jclass tmpJC_AttributeFeature =
      env->FindClass("com/rtnmarkdown/AttributeFeature");

  JC_AttributeFeature =
      reinterpret_cast<jclass>(env->NewGlobalRef(tmpJC_AttributeFeature));
  JMID_AttributeFeature_constructor =
      env->GetMethodID(JC_AttributeFeature, "<init>", "(IIII)V");

  return JNI_VERSION;
}

void JNI_OnUnload(JavaVM *vm, void *reserved) {
  JNIEnv *env;
  vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION);

  env->DeleteGlobalRef(JC_AttributeFeature);
}
