close all


last_sample_id = 38;
final_unstable = 55;
first_sample_id = 16;
vector_length = length(sys_data(:, 1));
h = figure;
plot(sys_data(first_sample_id:vector_length, 1), abs(sys_data(first_sample_id:vector_length, 3)), 'k-', 'LineWidth', 1.5)
hold on
plot(sys_data(first_sample_id, 1)*ones(2, 1), [0 1.1], 'k-', 'LineWidth', .5)
xlabel('\alpha')
ylabel('unstable zero magnitude')
xlim([sys_data(1, 1) sys_data(vector_length, 1)])
ylim([0.7 1.1])

t = 0.6:0.01:1.1;

a = (max(t) - 0.7)/(sys_data(first_sample_id, 1) - sys_data(1, 1));
% figure

% figure
hold on

for line=t
%     plot([sys_data(1, 1) sys_data(first_sample_id, 1)], [line a*sys_data(first_sample_id, 1)/(sys_data(1,1))*line], 'k-', 'LineWidth', 0.1)
    plot([sys_data(1, 1) sys_data(first_sample_id, 1)], [line 1.1*line], 'k-', 'LineWidth', 0.1)
end

% 
% t_lines = 0.85:0.05:1.05;
t_lines = 0.75:0.05:1.05;
for line_id=t_lines
    plot([sys_data(first_sample_id, 1) sys_data(vector_length, 1)], ones(2,1)*line_id, 'k--', 'LineWidth', .1);
end

t_lines = 0.8:0.05:sys_data(vector_length - 1, 1);
for line_id=t_lines
    plot(line_id*ones(2, 1), [0.7 1.1], 'k--', 'LineWidth', .001);
end

set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,'latawiec_alpha','-dpdf','-r0')
