; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -aarch64-neon-syntax=apple -verify-machineinstrs -o - %s | FileCheck %s

; Test signed conversion.
define <2 x float> @test1(<2 x i32> %in) {
; CHECK-LABEL: test1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    scvtf.2s v0, v0, #4
; CHECK-NEXT:    ret
entry:
  %vcvt.i = sitofp <2 x i32> %in to <2 x float>
  %div.i = fdiv <2 x float> %vcvt.i, <float 16.0, float 16.0>
  ret <2 x float> %div.i
}

; Test unsigned conversion.
define <2 x float> @test2(<2 x i32> %in) {
; CHECK-LABEL: test2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ucvtf.2s v0, v0, #3
; CHECK-NEXT:    ret
entry:
  %vcvt.i = uitofp <2 x i32> %in to <2 x float>
  %div.i = fdiv <2 x float> %vcvt.i, <float 8.0, float 8.0>
  ret <2 x float> %div.i
}

; Test which should not fold due to non-power of 2.
define <2 x float> @test3(<2 x i32> %in) {
; CHECK-LABEL: test3:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fmov.2s v1, #9.00000000
; CHECK-NEXT:    scvtf.2s v0, v0
; CHECK-NEXT:    fdiv.2s v0, v0, v1
; CHECK-NEXT:    ret
entry:
  %vcvt.i = sitofp <2 x i32> %in to <2 x float>
  %div.i = fdiv <2 x float> %vcvt.i, <float 9.0, float 9.0>
  ret <2 x float> %div.i
}

; Test which should not fold due to power of 2 out of range.
define <2 x float> @test4(<2 x i32> %in) {
; CHECK-LABEL: test4:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi.2s v1, #80, lsl #24
; CHECK-NEXT:    scvtf.2s v0, v0
; CHECK-NEXT:    fdiv.2s v0, v0, v1
; CHECK-NEXT:    ret
entry:
  %vcvt.i = sitofp <2 x i32> %in to <2 x float>
  %div.i = fdiv <2 x float> %vcvt.i, <float 0x4200000000000000, float 0x4200000000000000>
  ret <2 x float> %div.i
}

; Test case where const is max power of 2 (i.e., 2^32).
define <2 x float> @test5(<2 x i32> %in) {
; CHECK-LABEL: test5:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    scvtf.2s v0, v0, #32
; CHECK-NEXT:    ret
entry:
  %vcvt.i = sitofp <2 x i32> %in to <2 x float>
  %div.i = fdiv <2 x float> %vcvt.i, <float 0x41F0000000000000, float 0x41F0000000000000>
  ret <2 x float> %div.i
}

; Test quadword.
define <4 x float> @test6(<4 x i32> %in) {
; CHECK-LABEL: test6:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    scvtf.4s v0, v0, #2
; CHECK-NEXT:    ret
entry:
  %vcvt.i = sitofp <4 x i32> %in to <4 x float>
  %div.i = fdiv <4 x float> %vcvt.i, <float 4.0, float 4.0, float 4.0, float 4.0>
  ret <4 x float> %div.i
}

; Test unsigned i16 to float
define <4 x float> @test7(<4 x i16> %in) {
; CHECK-LABEL: test7:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ushll.4s v0, v0, #0
; CHECK-NEXT:    ucvtf.4s v0, v0, #1
; CHECK-NEXT:    ret
  %conv = uitofp <4 x i16> %in to <4 x float>
  %shift = fdiv <4 x float> %conv, <float 2.0, float 2.0, float 2.0, float 2.0>
  ret <4 x float> %shift
}

; Test signed i16 to float
define <4 x float> @test8(<4 x i16> %in) {
; CHECK-LABEL: test8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sshll.4s v0, v0, #0
; CHECK-NEXT:    scvtf.4s v0, v0, #2
; CHECK-NEXT:    ret
  %conv = sitofp <4 x i16> %in to <4 x float>
  %shift = fdiv <4 x float> %conv, <float 4.0, float 4.0, float 4.0, float 4.0>
  ret <4 x float> %shift
}

; Can't convert i64 to float.
define <2 x float> @test9(<2 x i64> %in) {
; CHECK-LABEL: test9:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ucvtf.2d v0, v0
; CHECK-NEXT:    movi.2s v1, #64, lsl #24
; CHECK-NEXT:    fcvtn v0.2s, v0.2d
; CHECK-NEXT:    fdiv.2s v0, v0, v1
; CHECK-NEXT:    ret
  %conv = uitofp <2 x i64> %in to <2 x float>
  %shift = fdiv <2 x float> %conv, <float 2.0, float 2.0>
  ret <2 x float> %shift
}

define <2 x double> @test10(<2 x i64> %in) {
; CHECK-LABEL: test10:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ucvtf.2d v0, v0, #1
; CHECK-NEXT:    ret
  %conv = uitofp <2 x i64> %in to <2 x double>
  %shift = fdiv <2 x double> %conv, <double 2.0, double 2.0>
  ret <2 x double> %shift
}
