; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -simplifycfg -sink-common-insts -simplifycfg-require-and-preserve-domtree=1 -opaque-pointers -S < %s | FileCheck %s

define ptr @test_sink_gep(i1 %c, ptr %p) {
; CHECK-LABEL: @test_sink_gep(
; CHECK-NEXT:  join:
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i32, ptr [[P:%.*]], i64 1
; CHECK-NEXT:    ret ptr [[GEP2]]
;
  br i1 %c, label %if, label %else

if:
  %gep1 = getelementptr i32, ptr %p, i64 1
  br label %join

else:
  %gep2 = getelementptr i32, ptr %p, i64 1
  br label %join

join:
  %phi = phi ptr [ %gep1, %if ], [ %gep2, %else]
  ret ptr %phi
}

define ptr @test_sink_gep_different_types(i1 %c, ptr %p) {
; CHECK-LABEL: @test_sink_gep_different_types(
; CHECK-NEXT:  join:
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr i32, ptr [[P:%.*]], i64 1
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i64, ptr [[P]], i64 1
; CHECK-NEXT:    [[PHI:%.*]] = select i1 [[C:%.*]], ptr [[GEP1]], ptr [[GEP2]]
; CHECK-NEXT:    ret ptr [[PHI]]
;
  br i1 %c, label %if, label %else

if:
  %gep1 = getelementptr i32, ptr %p, i64 1
  br label %join

else:
  %gep2 = getelementptr i64, ptr %p, i64 1
  br label %join

join:
  %phi = phi ptr [ %gep1, %if ], [ %gep2, %else]
  ret ptr %phi
}
