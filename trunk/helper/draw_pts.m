function draw_pts(pt)
s = 0.5;
for i=1:size(pt,1)
  rectangle('Position',[pt(i,1)-s,pt(i,2)-s,2*s,2*s],'Curvature',[0 0],'FaceColor','r', 'EdgeColor','r');
end
