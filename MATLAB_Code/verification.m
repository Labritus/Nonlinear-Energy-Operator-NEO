clear; clc; close all;

%% ===== 基本参数 =====
A  = 1;          % 输入信号的振幅
f  = 100;        % 输入信号的频率 (Hz)
n  = 2;          % 输入信号包含 n 个周期 (你之前设置的)
M  = 32;         % 样本数 (与你 txt 文件一致)
N  = 16;         % txt 文件中的补码位宽
halfN = N/2;
Afs = 3;

neo_txt = "A1_f100_phi0.txt";   % ← 修改为你的NEO结果文件名

MAX = 2^(halfN-1) - 1;      % e.g. 2047 for N=12

%% ===== 计算采样率 fs =====
fs = (M * f) / n;   % 原始生成信号的方法
fprintf("计算得到采样率 fs = %.2f Hz\n", fs);

%% ===== 真实时间轴 =====
t = (0:M-1) / fs;   % 每个样本对应的真实时间秒

%% ===== 读取 NEO 结果 txt =====
if ~isfile(neo_txt)
    error("找不到 NEO 输出文件: %s", neo_txt);
end

neo_lines = readlines(neo_txt);
neo_lines = strtrim(neo_lines);
neo_lines(neo_lines=="") = [];

if numel(neo_lines) ~= M
    warning("⚠ 样本数与 M 不一致！txt=%d, M=%d", numel(neo_lines), M);
end

neo_dec = zeros(M,1);

for i = 1:M
    bits = neo_lines(i);
    val = bin2dec(bits);
    if val >= 2^(N-1)
        val = val - 2^N;
    end
    neo_dec(i) = val;   % 注意，这就是最终 NEO（整数）
end

%% ===== 离散理论 NEO（正确的版本） =====
Omega = 2*pi*f/fs;                 % 数字角频率
psi_theory = (A / Afs * MAX )^2 * sin(Omega)^2;   % 离散 NEO 理论值

fprintf("离散理论 NEO Ψ = A^2 sin^2(Ω) = %.6f\n", psi_theory);

%% ===== 绘图 =====
figure;
stem(t, neo_dec, 'filled'); hold on;
yline(psi_theory, '--r', '理论 Ψ=(Aω)^2');
grid on;

xlabel('时间 t (秒)');
ylabel('NEO 输出 (整数)');
title(sprintf('NEO 输出与理论连续值对比  (A=%g, f=%g Hz)', A, f));
legend("NEO 离散输出","连续时间理论值");

