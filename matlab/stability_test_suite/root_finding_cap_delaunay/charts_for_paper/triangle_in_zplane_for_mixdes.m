% V = [sin(0:0.5:2*pi)' cos(0:0.5:2*pi)'];
close all
clear all
% number_of_steps = 8;
% step = (2*pi)/number_of_steps;
% 
% V = [sin(0:step:2*pi)' cos(0:step:2*pi)'];
% mid_point = (V(1,:) + V(2,:))/2
% distance = sqrt(mid_point(1)^2 + mid_point(2)^2)
% multiplier = 1/distance;
% plot(V(:,1), V(:,2))
% hold on
% plot(multiplier*V(:,1), multiplier*V(:,2))
% plot(sin(0:0.0001:2*pi), cos(0:0.0001:2*pi));
% 


t = 0.0:0.01:5;
% y = [4*t.^2 - 0.5*t.^3 + 1*t];
% plot(t, y);
% hold on
% y = [4*t.^2 - 0.5*t.^3 + 1*t];
% plot(t, -y + 25);


y = [4*t.^2 - 0.5*t.^3 + 2*t];
y2 = -y + 34;
y = y./max(y);
y2 = y2./max(y2);
t = t./max(t);

h = figure;
plot(t, y, 'k--');
hold on
plot(t, y2, 'k--');

t2 = [t, fliplr(t)];
inBetween = [y, fliplr(y2)];
fill(t2, inBetween, [0.85 0.85 0.85], 'LineStyle','none');

line_seg_x = [0.25 0.5 0.75 0.25];
line_seg_y = [0.3 0.7 0.3 0.3];
plot(line_seg_x, line_seg_y, 'k');

x_seg_locs = line_seg_x(1):((line_seg_x(2) - line_seg_x(1))/4):line_seg_x(2);
y_seg_locs = line_seg_y(1):((line_seg_y(2) - line_seg_y(1))/4):line_seg_y(2);

% TOP_LEFT
scatter(x_seg_locs,y_seg_locs, 'kx')
text(x_seg_locs(2)-0.05, y_seg_locs(2)+0.05,'...', 'FontSize',12, 'FontName', 'TimesNewRoman')
text(x_seg_locs(3)-0.09, y_seg_locs(3)+0.05,'w_p_-_1', 'FontSize',12, 'FontName', 'TimesNewRoman')
text(x_seg_locs(4)-0.06, y_seg_locs(4)+0.05,'w_p', 'FontSize',12, 'FontName', 'TimesNewRoman')
text(x_seg_locs(5)-0.02, y_seg_locs(5)+0.05,'w_1', 'FontSize',12, 'FontName', 'TimesNewRoman')
scatter((x_seg_locs(1) + x_seg_locs(2))/2, (y_seg_locs(1) + y_seg_locs(2))/2, 'k<')
% text(x_seg_locs(5)-0.05, y_seg_locs(5)+0.05,'p_n', 'FontSize',12, 'FontName', 'TimesNewRoman')

% TOP_RIGHT
x_seg_locs = line_seg_x(2):((line_seg_x(3) - line_seg_x(2))/4):line_seg_x(3);
y_seg_locs = line_seg_y(2):((line_seg_y(3) - line_seg_y(2))/4):line_seg_y(3);
text(x_seg_locs(2)+0.0, y_seg_locs(2)+0.05,'w_2', 'FontSize',12, 'FontName', 'TimesNewRoman')
text(x_seg_locs(3)-0.0, y_seg_locs(3)+0.05,'w_3', 'FontSize',12, 'FontName', 'TimesNewRoman')
text(x_seg_locs(4)-0.0, y_seg_locs(4)+0.05,'...', 'FontSize',12, 'FontName', 'TimesNewRoman')

scatter((x_seg_locs(1) + x_seg_locs(2))/2, (y_seg_locs(1) + y_seg_locs(2))/2, 'k<')
% quiver
scatter(x_seg_locs,y_seg_locs, 'kx')

% BOTTOM
x_seg_locs = line_seg_x(3):((line_seg_x(1) - line_seg_x(3))/4):line_seg_x(1);
% y_seg_locs = line_seg_y(3):((line_seg_y(1) - line_seg_y(3))/4):line_seg_y(1);
y_seg_locs = line_seg_y(3)*ones(length(x_seg_locs), 1);
text(x_seg_locs(3)-0.02, y_seg_locs(3)-0.05,'...', 'FontSize',12, 'FontName', 'TimesNewRoman')
scatter((x_seg_locs(1) + x_seg_locs(2))/2, (y_seg_locs(1) + y_seg_locs(2))/2, 'k<')
scatter(x_seg_locs,y_seg_locs, 'kx')

% plot(t, max(y, y2));

% patch([t flip(t)], [max(y, y2) ones(1, length(t))], 'red');
% patch([t flip(t)], [min(y, y2) zeros(1, length(t))], 'red');
xlim([0 1])
xlabel('Re[F(w)]')
ylabel('Im[F(w)]')
ylim([0 1])
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);

text(0.5, 0.9,'I', 'FontSize',14, 'FontName', 'TimesNewRoman')
text(0.1, 0.5,'II', 'FontSize',14, 'FontName', 'TimesNewRoman')
text(0.4, 0.1,'III', 'FontSize',14, 'FontName', 'TimesNewRoman')
text(0.9, 0.4,'IV', 'FontSize',14, 'FontName', 'TimesNewRoman')


plot([0 55],[0 0], 'k');


% patch(y, y2, 'red')

axis square
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,'triangle_phase_integral','-dpdf','-r0')