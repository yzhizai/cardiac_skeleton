#!/bin/sh
Usage() {
    echo ""
    echo "Usage: tbss_deproject <skeletonisedname> <refname> <spacename>"
    echo ""
    echo "skeletonisedname is the name of the skeletonised image"
    echo "refname is the name of the image which is used to generate the skeleton"
    echo "spacename is the name of the image which is to project the image to the skeleton"
    echo ""
    exit 1
}

[ "$2" = "" ] && Usage
basename=`${FSLDIR}/bin/remove_ext $1`
refname=`${FSLDIR}/bin/remove_ext $2`
spacename=`${FSLDIR}/bin/remove_ext $3`

echo "output from stage 1 deprojection will be ${basename}_to_origin"
$FSLDIR/bin/tbss_skeleton -i ${refname}_tfce_thr -p 0 ${refname}_skeleton_mask_dst $FSLDIR/data/standard/LowerCingulum_1mm ${spacename} \
${basename}_tmp -D $basename
$FSLDIR/bin/immv ${basename}_tmp_deprojected ${basename}_to_origin
$FSLDIR/bin/imrm ${basename}_tmp
echo "de-projection done"
