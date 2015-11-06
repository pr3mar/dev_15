function [smoothX, smoothY] = smooth_trajectory(trackX, trackY)

s = 20;
G = fspecial('gauss', [s 1], s / 6);

trackX = trackX(:);
trackY = trackY(:);

smoothX = conv(trackX, G, 'same');
smoothY = conv(trackY, G, 'same');

