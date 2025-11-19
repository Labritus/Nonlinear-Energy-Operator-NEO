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
            x_q(i) = x_q(i) + 2^halfN;
        else
            x_q(i) = x_q(i);
        end
    end

    %% ==== 生成最终 N-bit ====
    % N-bit = [ 前  N/2 bits = 0  ][ 后 N/2 bits = 补码 ]
    

    for i = 1:M
        lowBits = dec2bin(x_q(i), halfN);    % halfN-bit 补码
        highBits = repmat('0', 1, halfN);     % halfN-bit 0
        bin_str(i) = string([highBits, lowBits]);      % 拼成 N-bit 字符串
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
    figure;        % <--- 关键：每次循环重新开一个图窗口
    hold on;

    t_cont = linspace(0, t(end), 2000);
    x_cont = A * sin(2*pi*f*t_cont + phi);

    plot(t_cont, x_cont, 'LineWidth', 1.8); 


    % ===== 量化后离散采样点（反推成有符号 + 映射回实际幅度）=====

    % 反推补码为有符号数
    x_q_signed = x_q;
    neg_idx = x_q >= 2^(halfN-1);     % halfN 位补码的符号位为1 → negative
    x_q_signed(neg_idx) = x_q_signed(neg_idx) - 2^halfN;

    % 映射回真实幅度
    x_q_float = x_q_signed * (Afs / MAX);

    stem(t, x_q_float, 'filled', 'r', 'LineWidth', 1.2);

    % ===== 图属性 =====
    title(sprintf("A=%d, f=%d Hz, phi=%d°", A, f, phi));
    xlabel("Time (s)");
    ylabel("Amplitude");
    legend("Continuous", "Quantized Sampled");
    grid on;
    set(gca, 'FontSize', 12);







end

