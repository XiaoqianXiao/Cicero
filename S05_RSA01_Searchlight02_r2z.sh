basedir='/seastor/helenhelen/Cicero'
datadir=$basedir/pattern/Searchlight_RSM/ref_space/r
resultdir=$basedir/pattern/Searchlight_RSM/ref_space/z
mkdir $resultdir -p
cd $datadir
for x in *.nii.gz
do
dataname=`echo $x|sed -e "s/.nii.gz//g"`
fslmaths $x -uthr 1 $x

fslmaths $x -add 1 -log tmp
fslmaths $x -sub 1 -mul -1 -log tmp1
fslmaths tmp -sub tmp1 -div 2 ${resultdir}/${dataname}
done
