#!/bin/bash
#!----------------------------------------------------------------------------!
#!                                                                            !
#! YRexpert : (Your Yrelay) Système Expert sous Mumps GT.M et GNU/Linux       !
#! Copyright (C) 2001-2015 by Hamid LOUAKED (HL).                             !
#!                                                                            !
#!----------------------------------------------------------------------------!

source /home/yrelay/config/env
export SHELL=/bin/bash
#Cela existent pour des raisons de compatibilité
alias gtm="$gtm_dist/mumps -dir"
alias GTM="$gtm_dist/mumps -dir"
alias gde="$gtm_dist/mumps -run GDE"
alias lke="$gtm_dist/mumps -run LKE"
alias dse="$gtm_dist/mumps -run DSE"
#/home/yrelay/scripts/admin.sh
#$gtm_dist/mumps -dir
#$gtm_dist/mupip EXTRACT -SELECT=* /home/yrelay/tmp/yxp.zwr

#$gtm_dist/mupip load /home/yrelay/src/yrexpert-m/packages/divers/globals/arc/yxp.zwr.hl170111
exit

export global=%COMPIL && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%DIRCOUR && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%ENVIRON && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%GSET && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%INCONNE && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%IS && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%MN && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%PK && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%PKLOAD && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%PKREAD && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%PKSTO && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%QUERYT && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%QUEUE && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%RQSGLO && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%RS && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%RSET && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%SCRE && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%SYS && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%SYSLOG && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%VTEMPS && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%YEXPERT && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%Z100 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%Z52 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%ZGE && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%ZPC && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=%ZWORD && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=ATRADUIR && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=COMMENT && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=COS && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=CacheTempEWDSession && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=ENVCONF && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=GDERWH && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=GLOEXEC && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=GLOMENU && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=GM1 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=GM2 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=GM3 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=GM4 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=GM5 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=GM6 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=GM7 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=INCONNE && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=MEN && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=MN && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=MNUS && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=MODEPAS && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=MOZ && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=MOZ100 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=MOZ52 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=MOZDUR && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=MOZIDF && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=MOZMEM && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=MOZSAVU && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=MOZWORD && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=NAMEFUL && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=NUMETUD && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=OAFF && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=PIMEN && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=QX && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=REMANENCE && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RPC && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RPCUSR && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RQSAUTOR && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RQSDEFAU && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RQSGLO && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RQSGLU && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RQSMDL1 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RQSMDL2 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RQSMDL3 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RQSMDL4 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RQSMDL5 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RQSMOD && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RQSMOD2 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RQSMOD3 && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RQSMODIN && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=RQSTOTEM && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=SAVMEM && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=SAVVARX && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=SIN && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=TABIDENT && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=TABIDMOZ && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=TBTOZE && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=TD && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=TEMPORAI && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=TOLISRAM && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=TOZE && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr
export global=TTLEXTER && $gtm_dist/mupip EXTRACT -SELECT=$global /home/yrelay/tmp/$global.zwr






