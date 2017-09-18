clear,clc,close all
syms s w t

% By using this script, unit step response of a system (integer order and
% ESPECIALLY fractional order) can be obtained. Please change the variables
% given below according to your problem and run the script. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% MODIFY PARAMETERS BELOW ACCORDING TO YOUR SYSTEM %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Please enter a model.
Gs = 1/(s^1.5+1);

% Please enter the lower - upper bound of w_approximate and the number of
% sampling. This part has a great importance and be sure about that
% frequency response is described well.
w_lb = -1; % lower bound is 10^w_lb
w_ub = 2; % upper bound is 10^w_ub
sampling_num = 25; % Increasing sampling may increase the accuracy but also increase the time for computation.

% Please enter ratio for exact frequency response curve.
amp_rat = 1; % Amplitude ratio (Bounds of ecact frequency response will be extenden amp_rat times)
samp_rat = 10; % Sampling ratio (samp_rat times many samples will be taken when generating exact frequency response )

% Please enter time_max for step response and grid number
step_tmax=20; % Final time for step response
step_grid=50; % By increasing step_grid, you can obtain curlier shape but that will increase the time for computation.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' Gs = '); pretty(Gs);
Fs = subs(Gs,s,1i*w);

% Obtaining datas for exact (or more sampled) Frequency Response
w_val = logspace(w_lb-log10(amp_rat),w_ub+log10(amp_rat),sampling_num*samp_rat);
re_sFs = w_val;
for i=1:length(w_val)
    re_sFs(i) = real(subs(Fs,w,w_val(i)));
end

% Obtaining datas for exact (or more sampled) Frequency Response
w_app = logspace(w_lb,w_ub,sampling_num);
R = w_app;
for i=1:length(w_app)
    R(i) = real(subs(Fs,w,w_app(i)));
end

% Preparing figure
f1=figure; title('Frequency Response'); xlabel('Frequency w'); ylabel('R(w)');
set(f1,'units','normalized','pos',[0.05 0.25 0.4 0.5]); hold on; box on;

% Plotting Exact (or more sampled) Frequency Response
plot(w_val,re_sFs,'displayname','Exact','linew',2);

% Plotting Approximate Frequency Response
plot(w_app,R,'r.','displayname','Approximate');

leg = legend(gca,'show');
plot([w_val(1) w_val(end)],[0 0],'k:');
set(gca,'xscale','log');

% Finding R'
R_slope = zeros(1,length(w_app)-1);
for i=1:length(w_app)-1
    R_slope(i) = (R(i+1)-R(i))/(w_app(i+1)-w_app(i));
end
R_slope(end+1)=0; % R'(n+1) is also equated to 0

% Finding b
b = zeros(1,length(R_slope)-1);
for i=1:length(R_slope)-1
    b(i) = (R_slope(i+1)-R_slope(i))*w_app(i+1);
end

% Finding b*w
bw = b.*w_app(2:end);

% Defining the function G1 
G1=inline('(2/pi)*[sinint(x)-(1-cos(x))/x]');

% Obtaining Approximate Step Response
t_val = linspace(step_tmax/10^4,step_tmax,step_grid);
f1_val = zeros(1,length(t_val));
for i=1:length(t_val)
    f1_val(i)=0;
    for j=1:length(bw)
        f1_val(i) = f1_val(i)+b(j)*G1(w_app(j+1)*t_val(i));
    end
end

% Preparing figure and plotting
f2=figure; hold on; grid on; box on;
set(f2,'units','normalized','pos',[0.5 0.25 0.4 0.5]);
plot(t_val,f1_val,'b','displayname','Approximate','linew',2),
title('Step Response (Approximate)');