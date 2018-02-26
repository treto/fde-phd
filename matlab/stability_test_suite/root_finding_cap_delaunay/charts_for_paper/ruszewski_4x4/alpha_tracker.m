close all


last_sample_id = 45;
final_unstable = 56;
h = figure;
plot(sys_data(1:last_sample_id, 1), abs(sys_data(1:last_sample_id, 3)), 'k-', 'LineWidth', 1.5)
hold on
plot(sys_data(last_sample_id, 1)*ones(2, 1), [0 1.1], 'k-', 'LineWidth', .5)
xlabel('\alpha')
ylabel('unstable zero magnitude')
xlim([sys_data(5, 1) sys_data(final_unstable, 1)])
ylim([0.955 1.02])


t = 0.5:0.002:1.1;

% figure

hold on
for line=t
    plot([sys_data(last_sample_id, 1) line + sys_data(last_sample_id, 1)], [line 2.5*line], 'k-', 'LineWidth', 0.1)
end

t_lines = 0.85:0.01:1.01;
for line_id=t_lines
    plot([sys_data(1, 1) sys_data(last_sample_id, 1)], ones(2,1)*line_id, 'k--', 'LineWidth', .1);
end

t_lines = -1.55:0.01:sys_data(last_sample_id, 1);
for line_id=t_lines
    plot(line_id*ones(2, 1), [0.8 1.02], 'k--', 'LineWidth', .001);
end

set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,'ruszewski_n4_alpha','-dpdf','-r0')
