clear; clc; close all;

%% ===== 基本参数 =====
A_list = [1, 2, 3];
f_list = [100, 500, 1000];

n = 2;           
M = 32;            
N = 16;            
halfN = N/2;       
Afs = 3;           
MAX = 2^(halfN-1) - 1;   

neo_files = ["A1f100neo.txt", "A2f500neo.txt", "A3f1000neo.txt"];

%% ===== 第 1 步：先扫描所有文件找最大值 =====
all_neo_values = [];
all_theory_values = [];

for k = 1:3
    A = A_list(k);
    f = f_list(k);
    neo_txt = neo_files(k);

    fs = (M*f)/n;

    neo_lines = strtrim(readlines(neo_txt));
    neo_dec = zeros(M,1);
    for i=1:M
        v = bin2dec(neo_lines(i));
        if v >= 2^(N-1)
            v = v - 2^N;
        end
        neo_dec(i) = v;
    end

    Omega = 2*pi*f/fs;
    A_q = A / Afs * MAX;
    psi_theory = A_q^2 * sin(Omega)^2;

    all_neo_values = [all_neo_values; neo_dec];
    all_theory_values = [all_theory_values; psi_theory];
end

%% ===== 统一 Y 轴范围 =====
YMAX = max([max(all_neo_values), max(all_theory_values)]) * 1.2;

fprintf("统一 Y 轴最大值设为: %.2f\n", YMAX);

%% ===== 第 2 步：正式绘图 =====
figure;

for k = 1:3
    A = A_list(k);
    f = f_list(k);
    neo_txt = neo_files(k);

    % fs
    fs = (M*f)/n;
    t = (0:M-1)/fs;

    % load neo
    neo_lines = strtrim(readlines(neo_txt));
    neo_dec = zeros(M,1);
    for i=1:M
        v = bin2dec(neo_lines(i));
        if v >= 2^(N-1)
            v = v - 2^N;
        end
        neo_dec(i) = v;
    end

    Omega = 2*pi*f/fs;
    A_q = A / Afs * MAX;
    psi_theory = A_q^2 * sin(Omega)^2;

    subplot(3,1,k);
    stem(t, neo_dec, 'filled'); hold on;
    yline(psi_theory, 'r--', 'LineWidth',1.5);
    ylim([0, YMAX]);   % ★ 统一 Y 轴范围
    grid on;

    title(sprintf('A=%d, f=%d Hz: 硬件 NEO vs 理论 NEO', A, f));
    xlabel('时间 t (秒)');
    ylabel('NEO 输出 (整数)');
    legend('硬件 NEO','理论 NEO');
end
