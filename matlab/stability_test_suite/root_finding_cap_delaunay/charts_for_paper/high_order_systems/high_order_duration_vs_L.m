close all
% clear all

f_dur_length_delaunay = [
    50 18.7798 
    100 28.9823
    150 45.6513
    200 77.8948
    250 106.7658 
    300 157.2958
    350  183.9027 
    400  203.5486 
    450  250.7676 
    500 294.7975 
];
f_dur_length_delaunay = system_data;

f_dur_roots = [
   50.0000    0.0029
  100.0000    0.0084
  150.0000    0.0188
  200.0000    0.0332
  250.0000    0.0572
  300.0000    0.0814
  350.0000    0.1188
  400.0000    0.1587
  450.0000    0.2128
  500.0000    0.2656
];


f_dur_large_roots = [10 0.0006916
100 0.0065117
200 0.032404
300 0.081687
400 0.1567
500 0.25647
600 0.40606
700 0.52959
800 0.68948
900 0.84343
1000 1.0512
2000 4.6361
3000 15.4354
4000 31.4393
5000 56.1282
6000 109.6903
7000 163.7921
8000 263.9699
9000 352.1217
10000 472.232805];

h = figure();
f_dur_length_delaunay(:, 2) = f_dur_length_delaunay(:, 2)/max(f_dur_length_delaunay(:, 2));
f_dur_roots(:, 2) = f_dur_roots(:, 2)/max(f_dur_roots(:, 2));
f_dur_large_roots(:, 2) = f_dur_large_roots(:, 2)/max(f_dur_large_roots(:, 2));


total_line = 9;

% plot(f_dur_large_roots(:, 1), f_dur_large_roots(:, 2));
plot(f_dur_length_delaunay(:, 1), f_dur_length_delaunay(:, 2), 'k');
hold on
plot(f_dur_roots(:, 1), f_dur_roots(:, 2), 'k-', 'LineWidth', 1.7);

for line_id=1:total_line
    plot(f_dur_roots(:, 1), ones(length(f_dur_length_delaunay), 1)*0.1*line_id, 'k--', 'LineWidth', .001);
    hold on
end

for line_id=2:length(f_dur_length_delaunay)-1
    plot(f_dur_roots(line_id, 1)*ones(11, 1), 0:0.1:1, 'k--', 'LineWidth', .001);
    hold on
end


xlabel('number of stable zeros')
ylabel('duration (normalized)');
% axis square

set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,'high_order_up_to_500','-dpdf','-r0')

close all
h = figure();
plot(f_dur_large_roots(:, 1), f_dur_large_roots(:, 2), 'k-', 'LineWidth', 1.7);
hold on
grid on

% plot(f_dur_length_delaunay(:, 1), f_dur_length_delaunay(:, 2), 'k--');
xlabel('number of stable zeros')
ylabel('duration (normalized)');
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])


for line_id=1:total_line
    plot(f_dur_large_roots(:, 1), ones(length(f_dur_large_roots), 1)*0.1*line_id, 'k--', 'LineWidth', .001);
    hold on
end

for line_id=11:length(f_dur_large_roots)-1
    plot(f_dur_large_roots(line_id, 1)*ones(11, 1), 0:0.1:1, 'k--', 'LineWidth', .001);
    hold on
end
print(h,'high_order_up_to_10000','-dpdf','-r0')
