; RUN: opt < %s -passes=instsimplify

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"

; PR15791
define <2 x i64> @test1() {
  %a = and <2 x i64> undef, bitcast (<4 x i32> <i32 undef, i32 undef, i32 undef, i32 2147483647> to <2 x i64>)
  ret <2 x i64> %a
}
