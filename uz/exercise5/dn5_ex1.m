f = 0.025;
T = 12;
pz = 1:100;
d = f * T ./ pz;
% plot(d);

w = 648;
h = 488;
f = 2.5 * 10^(-3);
T = 12 * 10^(-2);
pw = 7.4 * 10^(-6);
detLeft = 550;
detRight = 300;
d = f * T / ((detLeft - detRight) * pw)
detRight = 540;
d = f * T / ((detLeft - detRight) * pw)