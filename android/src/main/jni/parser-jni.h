#include <jni.h>

#ifndef _Included_com_rtnmarkdown_MarkdownFormatter
#define _Included_com_rtnmarkdown_MarkdownFormatter
#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT void JNICALL Java_com_rtnmarkdown_MarkdownFormatter_parseJNI(JNIEnv *,
                                                                       jobject,
                                                                       jstring);

#ifdef __cplusplus
}
#endif
#endif
