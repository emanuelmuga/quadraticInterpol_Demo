function sqnr_dbs =  SQNR_eval(x, xq)
    sqnr_dbs = 10*log10(sum(x.^2)/sum((x - xq).^2));
end