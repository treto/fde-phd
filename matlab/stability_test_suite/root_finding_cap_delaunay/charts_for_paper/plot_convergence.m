% V = [sin(0:0.5:2*pi)' cos(0:0.5:2*pi)'];
close all
h = figure();
plot_lim = 1.1;
% clear all
triplot(tri, V(:, 1), V(:, 2), 'k');

xlim([-plot_lim plot_lim])
ylim([-plot_lim plot_lim])
% title('Delaunay triangulation')
hold on
aux_x = 0:0.05:(2*pi+0.05);
plot(sin(aux_x), cos(aux_x),'k--', 'LineWidth', 1.5);
% plot(sin(aux_x), cos(aux_x),'k--')
xlabel('Re[F(w)]')
ylabel('Im[F(w)]')

axis square

set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,'debug','-dpdf','-r0')

%%%%%%%%% PLOTTING CLOSE UP ON THE ZERO, zero location must be
%%%%%%%%% copy-paseted! :(
%zero_place = -0.9974 - 0.0015i; %ruszewski for -1.415
% zero_place = 0.5944 - 0.8030i; %latawiec for 0.775
% zero_place = 0.82924+0.53674i; %LPC
% zero_place = 0.34712+0.021899i; %butter
precision = 1e-3;
%zero_place = -0.9974 - 0.0015i; % ruszewski 4x4
zero_place = -0.56991+3.2206e-05i; % kaczorek
h = figure();
plot_lim = 1.1;
% clear all
triplot(tri, V(:, 1), V(:, 2), 'k');

xlim([real(zero_place) - precision*3 real(zero_place) + precision*3])
ylim([imag(zero_place) - precision*3 imag(zero_place) + precision*3])
% ylim([-plot_lim plot_lim])
% title('Delaunay triangulation')
hold on
aux_x = 0:0.05:(2*pi+0.05);

plot(sin(aux_x), cos(aux_x),'k--', 'LineWidth', 1.5);
% plot(sin(aux_x), cos(aux_x),'k--')
scatter(real(zero_place), imag(zero_place), 'kx', 'LineWidth', 1.5);
xlabel('Re[F(w)]')
ylabel('Im[F(w)]')

axis square

set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,'closeup','-dpdf','-r0')
