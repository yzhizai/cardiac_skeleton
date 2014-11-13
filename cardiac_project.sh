#!/bin/bash

#This is used to project the value of voxel to the skeleton

Usage(){
    cat <<EOF
 Usage: cardiac_project -i <basename> -r <refname>
EOF
exit 1
}

[ "$1" = "" ] && Usage

source /etc/fsl/fsl.sh
basename=$2;
refname=$4;
fslmaths ${refname}_tfce_mask -mul -1 -add 1 -add ${refname}_skeleton_mask  ${refname}_skeleton_mask_dst
distancemap -i  ${refname}_skeleton_mask_dst -o  ${refname}_skeleton_mask_dst
tbss_skeleton -i ${refname}_tfce_thr -p 0 ${refname}_skeleton_mask_dst  ${FSLDIR}/data/standard/LowerCingulum_1mm \
${basename} ${basename}_skeletonised

# the next step is used to fill the skeleton completely
#fslmaths ${basename}_skeletonised -bin ${basename}_skeletonised_mask
#fslmaths ${basename}_skeletonised_mask -mul -1 -add ${refname}_skeleton_mask ${basename}_residual_mask
#fslmaths ${basename} -mul ${basename}_residual_mask -add ${basename}_skeletonised ${basename}_skeletonised
#fslchfiletype ANALYZE ${basename}_skeletonised

#end
