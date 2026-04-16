function rmse = funcRMSE(x, y)
    x = x(:);
    y = y(:);

    diff = x - y;

    rmse = sqrt(mean(diff.^2));
end