function config_file(signalLen, interpFactor, interpLen, filename)


    fxd_config_type = fi([], 1, 32, 29);
    X1 = (1/interpFactor);
    X2 = (1/(interpFactor)^2);
    
    config0 = dec2hex(signalLen,8);
    config1 = dec2hex(interpFactor,8);
    config2 = cast(X1, 'like',fxd_config_type);
    config3 = cast(X2, 'like',fxd_config_type);
    config4 = dec2hex(interpLen,8);

    fid = fopen(filename, 'w+');
    Strg = config0;
    fprintf(fid,'%s\n', Strg);
    Strg = config1;
    fprintf(fid,'%s\n', Strg);
    Strg = hex(config2);
    fprintf(fid,'%s\n', Strg);
    Strg = hex(config3);
    fprintf(fid,'%s\n', Strg);
    Strg = config4;
    fprintf(fid,'%s\n', Strg);
    fclose(fid);
end