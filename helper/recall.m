function R = recall(classification, actual, pos, neg)
tp = sum(classification == actual & classification == pos);
fn = sum(classification ~= actual & classification == neg);
R = tp/(tp+fn);