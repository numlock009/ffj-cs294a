function [flattened] = flatten_cell(cell_matrix)
flattened = [];
for i = 1:size(cell_matrix, 1)
  for j = 1:size(cell_matrix, 2)
    if( sum(size(cell_matrix{i, j})))
      flattened(end+1:end+size(cell_matrix{i, j}, 1), :) = ...
          cell_matrix{i, j};
    end
  end
end
