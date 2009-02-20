Hi all!

here is our texture detection package up to now.

to train a model on data you should do the following:
create a directory containing the following sub-directories.
directory named test containing test examples , a directory named train
containing training examples. each of these dierctories should have
a directory called positive and negative . positive should contain positive
examples and negative should negative examples.

to train an SVM you should call:
process( pos_directory , neg_directory ,posfile , negfile, cellsize , ori_binsize , dist_binsize , trainfile , paramfile)

there are comments in each file describing parameters

and to test your model you should call 
test_model(.....)
