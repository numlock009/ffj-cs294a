output_file="results/old_skin_test_50x50_1_unweighted_hsv"
matlab -nodesktop -nosplash >> $output_file 2>&1 << EOF
expnum='1'
text='skin_50x50'
img_fol='/new_skin'
neg_fol='/negs'
weighted = 0
st='lr'
width=50
height=50
keypt='hl'
max_pts=1000
threshold=0.0005
desc='rift'
feature_type='hsv'
cl_algo='svm'
vis_dir = 'images/face'
final_directory = [vis_dir, '/fp']

full_script(expnum, text, width, height, img_fol, neg_fol, st, ...
            max_pts, threshold, ...
            desc, feature_type, keypt, cl_algo, vis_dir, final_directory, weighted)
EOF
