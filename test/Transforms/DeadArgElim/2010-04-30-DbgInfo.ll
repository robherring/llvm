; RUN: opt -S -deadargelim < %s | FileCheck %s

@.str = private constant [1 x i8] zeroinitializer, align 1 ; <[1 x i8]*> [#uses=1]

define i8* @vfs_addname(i8* %name, i32 %len, i32 %hash, i32 %flags) nounwind ssp {
entry:
  call void @llvm.dbg.value(metadata !{i8* %name}, i64 0, metadata !0, metadata !{})
  call void @llvm.dbg.value(metadata !{i32 %len}, i64 0, metadata !10, metadata !{})
  call void @llvm.dbg.value(metadata !{i32 %hash}, i64 0, metadata !11, metadata !{})
  call void @llvm.dbg.value(metadata !{i32 %flags}, i64 0, metadata !12, metadata !{})
; CHECK:  call fastcc i8* @add_name_internal(i8* %name, i32 %hash) [[NUW:#[0-9]+]], !dbg !{{[0-9]+}}
  %0 = call fastcc i8* @add_name_internal(i8* %name, i32 %len, i32 %hash, i8 zeroext 0, i32 %flags) nounwind, !dbg !13 ; <i8*> [#uses=1]
  ret i8* %0, !dbg !13
}

declare void @llvm.dbg.declare(metadata, metadata, metadata) nounwind readnone

define internal fastcc i8* @add_name_internal(i8* %name, i32 %len, i32 %hash, i8 zeroext %extra, i32 %flags) noinline nounwind ssp {
entry:
  call void @llvm.dbg.value(metadata !{i8* %name}, i64 0, metadata !15, metadata !{})
  call void @llvm.dbg.value(metadata !{i32 %len}, i64 0, metadata !20, metadata !{})
  call void @llvm.dbg.value(metadata !{i32 %hash}, i64 0, metadata !21, metadata !{})
  call void @llvm.dbg.value(metadata !{i8 %extra}, i64 0, metadata !22, metadata !{})
  call void @llvm.dbg.value(metadata !{i32 %flags}, i64 0, metadata !23, metadata !{})
  %0 = icmp eq i32 %hash, 0, !dbg !24             ; <i1> [#uses=1]
  br i1 %0, label %bb, label %bb1, !dbg !24

bb:                                               ; preds = %entry
  br label %bb2, !dbg !26

bb1:                                              ; preds = %entry
  br label %bb2, !dbg !27

bb2:                                              ; preds = %bb1, %bb
  %.0 = phi i8* [ getelementptr inbounds ([1 x i8]* @.str, i64 0, i64 0), %bb ], [ %name, %bb1 ] ; <i8*> [#uses=1]
  ret i8* %.0, !dbg !27
}

declare void @llvm.dbg.value(metadata, i64, metadata, metadata) nounwind readnone

; CHECK: attributes #0 = { nounwind ssp }
; CHECK: attributes #1 = { nounwind readnone }
; CHECK: attributes #2 = { noinline nounwind ssp }
; CHECK: attributes [[NUW]] = { nounwind }

!llvm.dbg.cu = !{!3}
!llvm.module.flags = !{!30}
!0 = metadata !{metadata !"0x101\00name\008\000", metadata !1, metadata !2, metadata !6} ; [ DW_TAG_arg_variable ]
!1 = metadata !{metadata !"0x2e\00vfs_addname\00vfs_addname\00vfs_addname\0012\000\001\000\006\000\000\000", metadata !28, metadata !2, metadata !4, null, null, null, null, null} ; [ DW_TAG_subprogram ]
!2 = metadata !{metadata !"0x29", metadata !28} ; [ DW_TAG_file_type ]
!3 = metadata !{metadata !"0x11\001\004.2.1 (Based on Apple Inc. build 5658) (LLVM build 9999)\001\00\000\00\000", metadata !28, metadata !29, metadata !29, null, null, null} ; [ DW_TAG_compile_unit ]
!4 = metadata !{metadata !"0x15\00\000\000\000\000\000\000", metadata !28, metadata !2, null, metadata !5, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!5 = metadata !{metadata !6, metadata !6, metadata !9, metadata !9, metadata !9}
!6 = metadata !{metadata !"0xf\00\000\0064\0064\000\000", metadata !28, metadata !2, metadata !7} ; [ DW_TAG_pointer_type ]
!7 = metadata !{metadata !"0x26\00\000\008\008\000\000", metadata !28, metadata !2, metadata !8} ; [ DW_TAG_const_type ]
!8 = metadata !{metadata !"0x24\00char\000\008\008\000\000\006", metadata !28, metadata !2} ; [ DW_TAG_base_type ]
!9 = metadata !{metadata !"0x24\00unsigned int\000\0032\0032\000\000\007", metadata !28, metadata !2} ; [ DW_TAG_base_type ]
!10 = metadata !{metadata !"0x101\00len\009\000", metadata !1, metadata !2, metadata !9} ; [ DW_TAG_arg_variable ]
!11 = metadata !{metadata !"0x101\00hash\0010\000", metadata !1, metadata !2, metadata !9} ; [ DW_TAG_arg_variable ]
!12 = metadata !{metadata !"0x101\00flags\0011\000", metadata !1, metadata !2, metadata !9} ; [ DW_TAG_arg_variable ]
!13 = metadata !{i32 13, i32 0, metadata !14, null}
!14 = metadata !{metadata !"0xb\0012\000\000", metadata !28, metadata !1} ; [ DW_TAG_lexical_block ]
!15 = metadata !{metadata !"0x101\00name\0017\000", metadata !16, metadata !2, metadata !6} ; [ DW_TAG_arg_variable ]
!16 = metadata !{metadata !"0x2e\00add_name_internal\00add_name_internal\00add_name_internal\0022\001\001\000\006\000\000\000", metadata !28, metadata !2, metadata !17, null, null, null, null, null} ; [ DW_TAG_subprogram ]
!17 = metadata !{metadata !"0x15\00\000\000\000\000\000\000", metadata !28, metadata !2, null, metadata !18, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!18 = metadata !{metadata !6, metadata !6, metadata !9, metadata !9, metadata !19, metadata !9}
!19 = metadata !{metadata !"0x24\00unsigned char\000\008\008\000\000\008", metadata !28, metadata !2} ; [ DW_TAG_base_type ]
!20 = metadata !{metadata !"0x101\00len\0018\000", metadata !16, metadata !2, metadata !9} ; [ DW_TAG_arg_variable ]
!21 = metadata !{metadata !"0x101\00hash\0019\000", metadata !16, metadata !2, metadata !9} ; [ DW_TAG_arg_variable ]
!22 = metadata !{metadata !"0x101\00extra\0020\000", metadata !16, metadata !2, metadata !19} ; [ DW_TAG_arg_variable ]
!23 = metadata !{metadata !"0x101\00flags\0021\000", metadata !16, metadata !2, metadata !9} ; [ DW_TAG_arg_variable ]
!24 = metadata !{i32 23, i32 0, metadata !25, null}
!25 = metadata !{metadata !"0xb\0022\000\000", metadata !28, metadata !16} ; [ DW_TAG_lexical_block ]
!26 = metadata !{i32 24, i32 0, metadata !25, null}
!27 = metadata !{i32 26, i32 0, metadata !25, null}
!28 = metadata !{metadata !"tail.c", metadata !"/Users/echeng/LLVM/radars/r7927803/"}
!29 = metadata !{i32 0}
!30 = metadata !{i32 1, metadata !"Debug Info Version", i32 2}
