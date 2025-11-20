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

%% ===== 第 1 步：先读取所有文件，找最大值用于统一 Y 轴 =====
all_neo_values = [];
all_theory_values = [];

for k = 1:3
    A = A_list(k);
    f = f_list(k);

    fs = (M * f) / n;

    neo_lines = strtrim(readlines(neo_files(k)));
    neo_dec = str2double(neo_lines);

    Omega = 2*pi*f/fs;
    A_q = A / Afs * MAX;
    psi_theory = A_q^2 * sin(Omega)^2;

    all_neo_values = [all_neo_values; neo_dec];
    all_theory_values = [all_theory_values; psi_theory];
end

%% ===== 统一 Y 轴上限 =====
YMAX = max([max(all_neo_values), max(all_theory_values)]) * 1.2;
fprintf("统一 Y 轴最大值设为: %.2f\n", YMAX);

%% ===== 第 2 步：逐张绘图并保存 SVG =====
for k = 1:3
    A = A_list(k);
    f = f_list(k);
    neo_txt = neo_files(k);

    fs = (M*f)/n;
    t = (0:M-1)/fs;

    neo_lines = strtrim(readlines(neo_txt));
    neo_dec = str2double(neo_lines);

    Omega = 2*pi*f/fs;
    A_q = A / Afs * MAX;
    psi_theory = A_q^2 * sin(Omega)^2;

    % === 单独开一个 figure ===
    fig = figure;
    fig.Position = [200 200 960 300];   % ★★★ 设置长宽比

    stem(t, neo_dec, 'filled'); hold on;
    yline(psi_theory, 'r--', 'LineWidth',1.5);
    ylim([0, YMAX]);
    grid on;

    title(sprintf('A=%d, f=%d Hz: Actual NEO vs Theoretical NEO', A, f));
    xlabel('t (s)');
    ylabel('NEO');
    legend('Actual NEO','Theoretical NEO');

    % === 保存为 SVG ===
    filename = sprintf('NEO_A%d_f%d.svg', A, f);
    exportgraphics(fig, filename, 'ContentType','vector');

    fprintf("已保存：%s\n", filename);
end
