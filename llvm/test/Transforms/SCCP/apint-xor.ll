; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=sccp -S | FileCheck %s

; Test some XOR simplifications / range propagation.
define void@xor1(i1 %cmp) {
; CHECK-LABEL: @xor1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_TRUE:%.*]], label [[END:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    ret void
;
entry:
  br i1 %cmp, label %if.true, label %end

if.true:
  br label %end

end:
  %p = phi i32 [ 11, %entry ], [ 11, %if.true]
  %xor.1 = xor i32 %p, %p
  %c.1 = icmp eq i32 %xor.1, 0
  call void @use(i1 %c.1)
  %c.2 = icmp eq i32 %xor.1, 10
  call void @use(i1 %c.2)
  %xor.2 = xor i32 %p, 1
  %c.3 = icmp eq i32 %xor.2, 11
  call void @use(i1 %c.3)
  %c.4 = icmp eq i32 %xor.2, 10
  call void @use(i1 %c.4)
  ret void
}

declare void @use(i1)
