function P = precision(classification, actual, pos, neg)
tp = sum(classification == test_actual && classification == pos);
fp = sum(classification ~= test_actual && classification == pos);
P = tp/(tp+fp);