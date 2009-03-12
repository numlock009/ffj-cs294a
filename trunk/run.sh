output_file="results/skin_50x50_junk"
matlab -nodesktop -nosplash >> $output_file 2>&1 << EOF
expnum='junk'
text='skin_50x50'
img_fol='/test'
st='lr'
width=50
height=50
have_pts_train=false
have_pts_test=false
max_pts=1000
threshold=0.005
desc='rift'
keypt='hl'
cl_algo='svm'
img_dir = 'images/background'
final_directory = [img_dir, '/fp']

full_script(expnum, text, width, height, img_fol, st, ...
            have_pts_train, have_pts_test, max_pts, threshold, ...
            desc, keypt, cl_algo, img_dir, final_directory)
EOF
