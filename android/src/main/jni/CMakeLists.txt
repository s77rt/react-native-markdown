cmake_minimum_required(VERSION 3.4.1)

project(rtnmarkdown)

add_library(parser-jni SHARED parser-jni.cpp ../../../../cpp/parser.cpp ../../../../md4c/src/md4c.c)
target_include_directories(parser-jni PRIVATE ../../../../cpp/)
target_include_directories(parser-jni PRIVATE ../../../../md4c/src/)
