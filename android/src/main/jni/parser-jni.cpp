#include "parser-jni.h"
#include "parser.h"

JNIEXPORT void JNICALL Java_com_rtnmarkdown_MarkdownFormatter_parseJNI(
    JNIEnv *env, jobject thiz, jstring markdownString) {
  const char *input = env->GetStringUTFChars(markdownString, NULL);
  parse(input);
  env->ReleaseStringUTFChars(markdownString, input);
}
