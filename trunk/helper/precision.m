function P = precision(classification, actual, pos, neg)
tp = sum(classification == actual && classification == pos);
fp = sum(classification ~= actual && classification == pos);
P = tp/(tp+fp);