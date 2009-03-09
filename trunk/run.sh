output_file="results/hair_50x50_spin"
matlab -nodesktop -nosplash > $output_file 2>&1 << EOF
expnum='1'
text='hair_50x50'
img_fol='/hair'
st='lr'
width=50
height=50
have_pts_train=false
have_pts_test=false
have_
max_pts=1000
threshold=0.005
desc='rift'
keypt='hl'
cl_algo='svm'

full_script(expnum, text, width, height, img_fol, st, ...
            have_pts_train, max_pts, threshold, ...
            desc, keypt, cl_algo)
EOF
