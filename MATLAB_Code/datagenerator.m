clear; clc; close all;

%% ==== 参数 ====
phi = 0; % 相位
n = 2; % 测试n个周期
N = 16;
halfN = N/2;
M = 32; % 测试n个周期 M = n * (fs/f) = 2*n fs>=2*f
Afs = 3; % 上限按振幅为3来计算

A_list = [1, 2, 3];
f_list = [100, 500, 1000];

%% ==== DSP 对称量化范围（不会用 -2^(N-1)）====
MAX = 2^(halfN-1) - 1;      % e.g. 2047 for N=12
MIN = -(2^(halfN-1) - 1);   % e.g. -2047 （对称，不会用 -2048）

%% ==== 确保工作目录切到脚本所在目录（保证输出在当前文件夹）====
cd(fileparts(mfilename('fullpath')));

for k = 1:3
    A = A_list(k);
    f = f_list(k);

    %% ==== 自动倒推出采样率，使得 sample 数量刚好 = M ====
    fs = (M * f) / n;     % fs = M * f / n

    T = n/f; % 持续n个周期
    t = (0:M-1) / fs;     % M 点

    %% ==== 生成正弦波 ====
    x = A * sin(2*pi*f*t + phi);


    %% ==== 对称量化（统一按最大振幅来映射）====
    x_q = round( x / Afs * MAX );  % 等价于 x * (MAX/A_FS)

    % 限幅，保证在 [-127,127]
    x_q(x_q > MAX) = MAX;
    x_q(x_q < MIN) = MIN;

    %% ==== 将负数转换为补码位模式（N/2-bit） ====
    % halfN-bit 的补码范围为 0 ~ 2^halfN - 1
    for i = 1:M
        if x_q(i) < 0
            x_q(i) = x_q(i) + 2^N;
        else
            x_q(i) = x_q(i);
        end
    end

    %% ==== 生成最终 N-bit ====
    % 生成 N-bit 二进制字符串
    bin_str = strings(M, 1);
    for i = 1:M
        bin_str(i) = dec2bin(x_q(i), N); % 固定 N 位宽
    end

    %% ==== 输出 txt 文件 ====
    filename = sprintf("A%d_f%d_phi%d.txt", A, f, phi);
    fid = fopen(filename, 'w');

    for i = 1:M
        fprintf(fid, "%s\n", bin_str(i));     % 写入 N-bit 补码字符串
    end

    fclose(fid);


    %% ==== 画图 ====
    % ===== 连续波形 =====
    %% ==== 画图：连续正弦波 vs 补码离散值 ====
    % 把补码整数映射回实际幅度值，便于和原波形对比
    x_q_real = x_q;
    for ii = 1:M
        if x_q_real(ii) >= 2^(N-1)
            x_q_real(ii) = x_q_real(ii) - 2^N;   % 还原成有符号整数
        end
    end
    x_q_real = x_q_real / MAX * Afs;  % 映射回血度范围（与输入一致）

    figure;        % <--- 每组 A,f 开一个新图
    hold on;

    % 连续波形（密集采样，用更高分辨率来画更光滑的曲线）
    t_dense = linspace(0, T, 2000);
    x_dense = A * sin(2*pi*f*t_dense + phi);
    plot(t_dense, x_dense, 'LineWidth', 1.5);

    % 离散采样（补码量化后还原的幅值）
    stem(t, x_q_real, 'filled');

    grid on;
    xlabel("Time (s)");
    ylabel("Amplitude");
    title(sprintf("A=%d, f=%d Hz — Continuous vs Two's Complement Quantized", A, f));
    legend("Continuous sine", "Quantized (two's complement)", "Location", "best");







end

