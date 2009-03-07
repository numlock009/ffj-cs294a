expnum="5"
text="skin_50x50"
width=50
height=50
img_fol="/skin"
st="lr"
have_pts_train=1
max_pts=1000
threshold=0.005
desc="rift"
keypt="hl"
cl_algo="svm"
matlab -nodesktop -nosplash -r training_script\(\'$expnum\',\'$text\',$width,$height,\'$img_fol\',\'$st\',$have_pts_train,$max_pts,$thresh,\'$desc\',\'$keypt\',\'$cl_algo\'\)
