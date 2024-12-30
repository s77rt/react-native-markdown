#include "md4c.h"
#include <jni.h>
#include <string.h>

JNIEXPORT void JNICALL Java_com_rtnmarkdown_MarkdownFormatter_parseJNI(
    JNIEnv *env, jobject thiz, jstring markdownString) {
  const MD_CHAR *input = (*env)->GetStringUTFChars(env, markdownString, NULL);
  const MD_SIZE inputSize = strlen(input);

  (*env)->ReleaseStringUTFChars(env, markdownString, input);
}
