clc; clear all; close all;

load("../LetterA_Config.mat");

name = sprintf("../LetterA_2em4_1.mat");
load(name);


h(1) = plot(Config(:, 2), Config(:, 3), 'k-');
hold on;
h(2) = plot(pred_config_base(:, 1), pred_config_base(:,2));
