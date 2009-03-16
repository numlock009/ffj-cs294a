cd scratch/project
cd classifiers/svm
make clean
make
cd ../..

DISPLAY=''
script_name="${script_name}${weighted}${threshold}${expnum}.sh"

echo "matlab -nodesktop -nosplash << EOF" > $script_name
echo "expnum='$expnum'" >> $script_name
echo "text='$text'" >> $script_name
echo "img_fol='/$img_fol'" >> $script_name
echo "neg_fol='/$neg_fol'" >> $script_name
echo "weighted = $weighted" >> $script_name
echo "st='$st'" >> $script_name
echo "width=$width" >> $script_name
echo "height=$height" >> $script_name
echo "keypt='$keypt'" >> $script_name
echo "max_pts=$max_pts" >> $script_name
echo "threshold=$threshold" >> $script_name
echo "desc='$desc'" >> $script_name
echo "cl_algo='$cl_algo'" >> $script_name
echo "vis_dir = '$vis_dir'" >> $script_name
echo "final_directory = [vis_dir, '/fp']" >> $script_name
echo "full_script(expnum, text, width, height, img_fol, neg_fol, st, ..." >> $script_name
echo "            max_pts, threshold, ..." >> $script_name
echo "            desc, keypt, cl_algo, vis_dir, final_directory, weighted)" >> $script_name
echo "EOF" >> $script_name  
chmod +x $script_name
. $script_name
