#!/bin/bash

#This shell is used to create the images' skeleton.

Usage(){
    cat <<EOF
Usage cardiac_skeleton -i <infile> n
 You should add a input argument for this shell.
EOF

    exit 1
}
source /etc/fsl/fsl.sh
[ "$1" = "" ] && Usage
basename=$2
fslmaths $2 -tfce 2 0.5 6 ${basename}_tfce
fslmaths ${basename}_tfce -thrP 20 ${basename}_tfce_thr
fslchfiletype ANALYZE ${basename}_tfce_thr
fslchfiletype ANALYZE ${basename}_tfce
if [ $3 = 2 ];then
    exit 0
fi
fslmaths ${basename}_tfce_thr -bin ${basename}_tfce_mask
tbss_skeleton -i ${basename}_tfce -o ${basename}_skeleton_1
fslmaths ${basename}_skeleton_1 -thrP 20 ${basename}_skeleton_1
fslchfiletype ANALYZE ${basename}_skeleton_1
#rm tfce_temp.* 
#end