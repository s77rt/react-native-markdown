cmake_minimum_required(VERSION 3.4.1)

project(rtnmarkdown)

add_library(md4c-jni SHARED md4c-jni.c)
target_include_directories(md4c-jni PRIVATE ../../../../md4c/src/)
