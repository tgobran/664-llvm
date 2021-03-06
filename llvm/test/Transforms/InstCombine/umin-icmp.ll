; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

; If we have a umin feeding an unsigned or equality icmp that shares an
; operand with the umin, the compare should always be folded.
; Test all 4 foldable predicates (eq,ne,uge,ult) * 4 commutation
; possibilities for each predicate. Note that folds to true/false
; (predicate is ule/ugt) or folds to an existing instruction should be
; handled by InstSimplify.

; umin(X, Y) == X --> X <= Y

define i1 @eq_umin1(i32 %x, i32 %y) {
; CHECK-LABEL: @eq_umin1(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ult i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp eq i32 %sel, %x
  ret i1 %cmp2
}

; Commute min operands.

define i1 @eq_umin2(i32 %x, i32 %y) {
; CHECK-LABEL: @eq_umin2(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ult i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp eq i32 %sel, %x
  ret i1 %cmp2
}

; Disguise the icmp predicate by commuting the min op to the RHS.

define i1 @eq_umin3(i32 %a, i32 %y) {
; CHECK-LABEL: @eq_umin3(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp ult i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp eq i32 %x, %sel
  ret i1 %cmp2
}

; Commute min operands.

define i1 @eq_umin4(i32 %a, i32 %y) {
; CHECK-LABEL: @eq_umin4(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp ult i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp eq i32 %x, %sel
  ret i1 %cmp2
}

; umin(X, Y) >= X --> X <= Y

define i1 @uge_umin1(i32 %x, i32 %y) {
; CHECK-LABEL: @uge_umin1(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ult i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp uge i32 %sel, %x
  ret i1 %cmp2
}

; Commute min operands.

define i1 @uge_umin2(i32 %x, i32 %y) {
; CHECK-LABEL: @uge_umin2(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ult i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp uge i32 %sel, %x
  ret i1 %cmp2
}

; Disguise the icmp predicate by commuting the min op to the RHS.

define i1 @uge_umin3(i32 %a, i32 %y) {
; CHECK-LABEL: @uge_umin3(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp ult i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp ule i32 %x, %sel
  ret i1 %cmp2
}

; Commute min operands.

define i1 @uge_umin4(i32 %a, i32 %y) {
; CHECK-LABEL: @uge_umin4(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp ult i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp ule i32 %x, %sel
  ret i1 %cmp2
}

; umin(X, Y) != X --> X > Y

define i1 @ne_umin1(i32 %x, i32 %y) {
; CHECK-LABEL: @ne_umin1(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ult i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp ne i32 %sel, %x
  ret i1 %cmp2
}

; Commute min operands.

define i1 @ne_umin2(i32 %x, i32 %y) {
; CHECK-LABEL: @ne_umin2(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i32 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp ult i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp ne i32 %sel, %x
  ret i1 %cmp2
}

; Disguise the icmp predicate by commuting the min op to the RHS.

define i1 @ne_umin3(i32 %a, i32 %y) {
; CHECK-LABEL: @ne_umin3(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp ult i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp ne i32 %x, %sel
  ret i1 %cmp2
}

; Commute min operands.

define i1 @ne_umin4(i32 %a, i32 %y) {
; CHECK-LABEL: @ne_umin4(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp ult i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp ne i32 %x, %sel
  ret i1 %cmp2
}

; umin(X, Y) < X --> X > Y

define i1 @ult_umin1(i32 %x, i32 %y) {
; CHECK-LABEL: @ult_umin1(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ult i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp ult i32 %sel, %x
  ret i1 %cmp2
}

; Commute min operands.

define i1 @ult_umin2(i32 %x, i32 %y) {
; CHECK-LABEL: @ult_umin2(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i32 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp ult i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp ult i32 %sel, %x
  ret i1 %cmp2
}

; Disguise the icmp predicate by commuting the min op to the RHS.

define i1 @ult_umin3(i32 %a, i32 %y) {
; CHECK-LABEL: @ult_umin3(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp ult i32 %x, %y
  %sel = select i1 %cmp1, i32 %x, i32 %y
  %cmp2 = icmp ugt i32 %x, %sel
  ret i1 %cmp2
}

; Commute min operands.

define i1 @ult_umin4(i32 %a, i32 %y) {
; CHECK-LABEL: @ult_umin4(
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A:%.*]], 3
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %x = add i32 %a, 3 ; thwart complexity-based canonicalization
  %cmp1 = icmp ult i32 %y, %x
  %sel = select i1 %cmp1, i32 %y, i32 %x
  %cmp2 = icmp ugt i32 %x, %sel
  ret i1 %cmp2
}

