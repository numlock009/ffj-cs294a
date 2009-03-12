output_file="results/new_hair_50x50_1_unweighted"
matlab -nodesktop -nosplash >> $output_file 2>&1 << EOF
expnum='1'
text='new_hair_50x50'
img_fol='/new_hair'
weighted = 0
st='lr'
width=50
height=50
have_pts_train=false
have_pts_test=false
max_pts=1000
threshold=0.0005
desc='rift'
keypt='hl'
cl_algo='svm'
img_dir = 'images/face'
final_directory = [img_dir, '/fp']

full_script(expnum, text, width, height, img_fol, st, ...
            have_pts_train, have_pts_test, max_pts, threshold, ...
            desc, keypt, cl_algo, img_dir, final_directory, weighted)
EOF
