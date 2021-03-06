basedir='/seastor/helenhelen/Cicero'
roi_name=("CA1" "CA2" "DG" "CA3" "head" "tail" "MISC" "subiculum" "ERC")
#for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
for ((m=1; m<=31; m++))
do
    if [ ${m} -lt 10 ];
    then
       SUB=MOL0${m}
       sub=sub0${m}
    else
        SUB=MOL${m}
        sub=sub${m}
    fi
    echo $SUB
    datadir=$basedir/${SUB}/data/anatomy/seg_hipp/final
    for s in left right
    do
        resultdir=$basedir/${SUB}/data/anatomy/sub_hipp/${s}
        mkdir ${resultdir} -p
        datafile=${datadir}/seg_hipp_${s}_lfseg_corr_usegray.nii.gz
        for ((n=0; n<=8; n++))
        do
            t=$[$n+1]
            roi=${roi_name[${n}]}
            fsl_sub fslmaths $datafile -thr $t -uthr $t -bin ${resultdir}/${roi}.nii.gz
        done
    fsl_sub fslmaths $datafile -thr 10 -uthr 11 -bin ${resultdir}/PRC.nii.gz
    done
done
