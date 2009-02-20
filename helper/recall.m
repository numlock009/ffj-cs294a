function R = recall(classification, actual, pos, neg)
tp = sum(classification == test_actual && classification == pos);
fn = sum(classification ~= test_actual && classification == neg);
R = tp/(tp+fn);